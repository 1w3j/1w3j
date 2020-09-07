#!/usr/bin/env bash

# shellcheck disable=SC1090
source ~/1w3j/functions.sh

CURRENT_COURSE_DIR=~/Current\ Course
CURRENT_COURSE_INFO_FILENAME=current_course_info.txt
CURRENT_COURSE_INFO_FILENAME_LOCATION=${CURRENT_COURSE_DIR}/${CURRENT_COURSE_INFO_FILENAME}
CURRENT_COURSE_DIR_ADDED_COURSES="$(find -L "${CURRENT_COURSE_DIR}" -mindepth 1 -maxdepth 1 -type d)" # trimming the first line

add_course() {
    local course extension course_name course_file tmp_folder tmp_content
    course="${1}"
    course_file="$(basename "${course}")"
    extension="${course_file##*.}"
    tmp_folder="${CURRENT_COURSE_DIR}"/tmp
    if [[ ${extension} == "zip" ]] || [[ ${extension} == "rar" ]]; then
        course_name="${course_file%.*}"
        case ${extension} in
            zip)
                msg "Unzipping Course '${course_name}'..." && unzip -o "${course}" -d "${tmp_folder}"
                ;;
            rar)
                msg "Unrar Course '${course_name}'..." && mkdir -p "${tmp_folder}" && unrar x -y "${course}" "${tmp_folder}"
                ;;
        esac
        # sometimes archives does not contain a root directory and course folders were directly compressed in a 0 depth
        # tree root folder, in this case, when moving contents from tmp folder would complicated things a bit, since it
        # is supposed that tmp/${course_name}/ must be the correct structure, and not a bunch of without-root folders
        # like: 'tmp/{01 Introduction, 02 Getting Started with bitchx, 03 ...}', moving these folder would completely
        # mess with the desired structure for the handling of multiple courses to be added in the future. So -gt 1
        # because if there are 2 or more folders in the temp folder it is supposed that the archive was a without-root
        # one.
        tmp_content="$(find -L "${tmp_folder}" -mindepth 1 -maxdepth 1)"
        mkdir -p "${CURRENT_COURSE_DIR}/${course_name}"
        if [[ $(wc -l <<< "${tmp_content}") -gt 1 ]] && [[ "$(basename "${tmp_content}")" != "${course_name}" ]]; then
            msg "Moving inner content of temp folder..." && mv "${tmp_folder}"/* "${CURRENT_COURSE_DIR}/${course_name}"
        else
            # first * globbed content at this point, must only be one folder, the second * must contain the rest of the
            # course content
            mv "${tmp_folder}"/*/* "${CURRENT_COURSE_DIR}/${course_name}"
        fi
        msg 'Deleting temp folder...' && rm -r "${tmp_folder}"
        msg "Creating current course info..." && echo "${course_name}" > "${CURRENT_COURSE_INFO_FILENAME_LOCATION}"
    else # if user selected a folder
        if [[ -d ${course} ]]; then
            #msg "Linking Course \"${course}\"..." && cp -rs "$course"/* $CURRENT_COURSE_DIR
            msg "Copying course '${course}'..." && cp -r "${course}" "${CURRENT_COURSE_DIR}"
            msg "Creating current course info..." && echo "${course_name}" > "${CURRENT_COURSE_INFO_FILENAME_LOCATION}"
        else
            err "Selected course is neither a folder, nor a zip or a rar, nothing to do here..."
        fi
    fi
}

display_current_course() {
    if [[ -f ${CURRENT_COURSE_INFO_FILENAME_LOCATION} ]]; then
        echo '|'
        echo -e '|' "\t$(cat "${CURRENT_COURSE_INFO_FILENAME_LOCATION}")"
        echo '|'
    else
        warn "Wow ${CURRENT_COURSE_INFO_FILENAME_LOCATION} does not exist"
    fi
}

currentcourse() {
    local should_delete_previous_courses
    # check if $CURRENT_COURSE_DIR exists
    if [[ ! -d ${CURRENT_COURSE_DIR} ]]; then
        #if not, create it.
        msg "Creating folder ${CURRENT_COURSE_DIR} for you..." && mkdir "${CURRENT_COURSE_DIR}"
    fi
    # if a path is passed as arg
    if [[ -e ${1} ]]; then
        display_current_course
        should_delete_previous_courses="n" # default to 'n' just in case there aren't any courses already added
        # if $CURRENT_COURSE_DIR has files inside
        if find -L "${CURRENT_COURSE_DIR}" -mindepth 1 -maxdepth 1 -type d | grep -q .; then
            msg "'${CURRENT_COURSE_DIR}' has these contents: "
            echo -e "${CURRENT_COURSE_DIR_ADDED_COURSES}"
            echo -e '\r'
            read -r -p "Do you want to remove your previous courses (Y/n): " should_delete_previous_courses
        fi
        # anything before '?' are variables
        case "${should_delete_previous_courses}" in
            [yY]*)
                msg Removing "${CURRENT_COURSE_DIR}"'/*...' && rm -rf "${CURRENT_COURSE_DIR:?}"/*
                ;;
            [nN]*)
                msg "'Do not to delete previously added courses' mode is activated"
                ;;
            *)
                err "\"${should_delete_previous_courses}\" is not a valid answer"
                exit 137
                ;;
        esac
        msg 'Adding new course to the folder' && add_course "${1}"
    else
        display_current_course
        # if $CURRENT_COURSE_INFO_FILENAME_LOCATION exists AND $CURRENT_COURSE_DIR has contents
        if find -L "${CURRENT_COURSE_DIR}" -mindepth 1 -maxdepth 1 -type d | grep -q .; then
            ls -l "${CURRENT_COURSE_DIR}"/
        else
            msg "There aren't any courses added yet, got removed someway"
        fi
    fi
}

currentcourse "${@}"
