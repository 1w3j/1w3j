#!/usr/bin/env zsh

source ~/1w3j/functions.sh

CURRENT_COURSE_DIR=~/Current\ Course
CURRENT_COURSE_INFO_FILENAME=current_course_info.txt
CURRENT_COURSE_INFO_FILENAME_LOCATION=${CURRENT_COURSE_DIR}/${CURRENT_COURSE_INFO_FILENAME}
should_delete_previous_courses=""

link_course() {
    course_tobe_linked="$1"
    extension="${course_tobe_linked##*.}"
    if [[ ${extension} = "zip" ]]; then
        zipped_course_name="$(basename ${course_tobe_linked})%.*"
        msg "Unzipping Course..." && unzip -q ${course_tobe_linked} -d ${CURRENT_COURSE_DIR}
        msg "Creating Current Course Info..." && echo "${zipped_course_name}" > ${CURRENT_COURSE_INFO_FILENAME_LOCATION}
        if [[ -z "${2}" ]]; then
            msg "Moving inner course folder content..." && mv ${CURRENT_COURSE_DIR}/"${zipped_course_name}"/* ${CURRENT_COURSE_DIR}
            msg 'Deleting empty folder...' && rm -r ${CURRENT_COURSE_DIR}/"${zipped_course_name}"
        fi
    else
        #msg "Linking Course \"${course_tobe_linked}\"..." && cp -rs "$course_tobe_linked"/* $CURRENT_COURSE_DIR
        msg "Linking Course \"${course_tobe_linked}\"..." && cp -r "${course_tobe_linked}/*" ${CURRENT_COURSE_DIR}
        msg "Creating Current Course Info..." && echo `basename "$course_tobe_linked"` > ${CURRENT_COURSE_INFO_FILENAME_LOCATION}
    fi
}

display_current_course() {
    if [[ -f ${CURRENT_COURSE_INFO_FILENAME_LOCATION} ]]; then
        echo '|'
        echo -e '|' "\t"`cat ${CURRENT_COURSE_INFO_FILENAME_LOCATION}`
        echo '|'
    else
        warn -e "Wow ${CURRENT_COURSE_INFO_FILENAME_LOCATION} does not exist. but this is what its folder contains:\n"
    fi
}

currentcourse() {
    # check if $CURRENT_COURSE_DIR exists
    if [[ ! -d ${CURRENT_COURSE_DIR} ]]; then
        #if not, create it.
        msg "Creating folder "${CURRENT_COURSE_DIR}" for you..." && mkdir ${CURRENT_COURSE_DIR}
    fi
    # if a path is passed as arg
    if [[ -e "${1}" ]]; then
        display_current_course
        # if $CURRENT_COURSE_DIR has files inside
        if find -L "${CURRENT_COURSE_DIR}" -mindepth 1 -print -quit | grep -q . ; then
            msg "${CURRENT_COURSE_DIR} has these contents: "
            find -L ${CURRENT_COURSE_DIR} -maxdepth 1 | head -n-1 | tail -n+2  # trimming the first and the last line
            echo -e '\r'
        fi
        # anything before '?' are variables
        read 'should_delete_previous_courses?Do you want to remove your previous courses (Y/n): '
        if [[ ${should_delete_previous_courses} = "y" || ${should_delete_previous_courses} = "Y" ]]; then
            msg Removing "$CURRENT_COURSE_DIR"'/*...' && rm -rf ${CURRENT_COURSE_DIR}/*
            link_course "$1"
        else
            if [[ ${should_delete_previous_courses} = "n" || ${should_delete_previous_courses} = "N" ]]; then
                # msg "Then go fuck yourself";  # well, no
                # exit 0;
                echo 'Adding new course to the folder' && link_course "${1}" "without deleting previous courses"
            else
                err "\"${should_delete_previous_courses}\" is not a valid answer"
                exit 1
            fi
        fi
    else
        # if $CURRENT_COURSE_INFO_FILENAME_LOCATION exists AND $CURRENT_COURSE_DIR has contents
        display_current_course
        ls -l ${CURRENT_COURSE_DIR}
    fi
}

currentcourse "${@}"
