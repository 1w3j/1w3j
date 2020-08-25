#! /usr/bin/env bash

# shellcheck disable=SC1090
source ~/1w3j/functions.sh

MUSIC_FOLDER=/storage/5D42-7A0D/Music
#SONGS_LIST_FOLDER=~/.config/cmus/playlists
SONGS_LIST_FOLDER=~/liststest
M3U_OUTPUT_FILE_PATH="$(pwd)"

list_song_lists() {
    msg "These are the files that can generate m3u playlist files"
    for song_list in "${SONGS_LIST_FOLDER}"/*; do
        local n=$((n + 1)) #increment by one
        echo "${n}) ${song_list##*/}"
    done
    unset n
}

check_song_list_number() {
    if [[ ${1} -ge $(find "${SONGS_LIST_FOLDER}" | wc -l) || ${1} -le 0 ]]; then
        err "The selected number is not included on the song listing. Check the -ls argument."
        exit 1
    fi
}

get_song_list() {
    for song_list in "${SONGS_LIST_FOLDER}"/*; do
        local n=$((n + 1))
        if [[ ${1} -eq ${n} ]]; then
            echo -e "${song_list##*/}"
        fi
    done
    unset n
}

remove_duplicated_songs() {
    check_song_list_number "${1}"
    local selected_song_list duplicated_list show_cleaned_list cleaned_list
    selected_song_list=$(get_song_list "${1}")
    msg "Selected playlist: ${selected_song_list}"
    duplicated_list="$(sort "${SONGS_LIST_FOLDER}/${selected_song_list}" | uniq -d)" # uniq -d prints only repeated lines
    cleaned_list="$(sort "${SONGS_LIST_FOLDER}/${selected_song_list}" | uniq)"
    if [[ -n ${duplicated_list} ]]; then
        read -r -p "$(msg "There are $(echo "${duplicated_list}" | wc -l) duplicated songs. Do you want to print them? (Y/n): ")" show_cleaned_list
        case "${show_cleaned_list}" in
            [yY]*)
                echo -e "${duplicated_list}"
                read -r -p "$(msg "Proceed to clean the playlist from these duplicates? (Press ENTER)")"
                ;;
        esac
        echo "${cleaned_list}" > "${SONGS_LIST_FOLDER}/${selected_song_list}" && msg "Successfully removed all duplicated song files"
    else
        msg "There aren't duplicated songs. Nothing to do here."
    fi
}

print_dupes() {
    check_song_list_number "${1}"
    local duplicated_list
    duplicated_list="$(sort "${SONGS_LIST_FOLDER}/$(get_song_list "${1}")" | uniq -d)"
    if [[ -n ${duplicated_list} ]]; then
        echo -e "${duplicated_list}"
    else
        msg "There aren't duplicated songs. Nothing to do here."
    fi
}

remove_songs_from_another_list() {
    if [[ -n ${1} ]] && [[ -e ${2} ]]; then
        check_song_list_number "${1}"
        local line_numbers selected_song_list
        selected_song_list="$(get_song_list "${1}")"
        while IFS=$'\n' read -r song; do
            line_numbers="${line_numbers}$(echo "${song}" | cut -d: -f 1)d;"
            if [[ ${3} == "-print" ]]; then
                echo -e "${song}"
            fi
        done <<< "$(while IFS=$'\n' read -r song; do
            grep -Fxn "${song}" "${SONGS_LIST_FOLDER}/${selected_song_list}" | head -n+1
        done < "${2}")" # head -n+1 because we just need to grep the first entry in case a duped entry exists
        if [[ ${3} != "-print" ]] && [[ ${line_numbers} != "d;" ]]; then
            echo "sed -i -e ${line_numbers} ${SONGS_LIST_FOLDER}/${selected_song_list}"
            read -r -p "$(msg "Proceed to clean the playlist from these duplicates? (Press ENTER)")"
            sed -i -e "${line_numbers}" "${SONGS_LIST_FOLDER}/${selected_song_list}"
        else
            if [[ ${line_numbers} == "d;" ]]; then
                msg "Couldn't match any song. Nothing to do here."
            fi
        fi
    else
        if [[ -z ${1} ]]; then
            err "Please enter a song list number"
        else
            if [[ ! -e ${2} ]]; then
                err "'${2}': File does not exist"
            fi
        fi
    fi
}

print_not_available_songs_from_file() {
    if [[ -n ${1} ]] && [[ -e ${2} ]]; then
        check_song_list_number "${1}"
        local line_numbers selected_song_list
        selected_song_list="$(get_song_list "${1}")"
        while IFS=$'\n' read -r song; do
            if [[ ${4} != "-v" ]]; then # -v for inVert
                if ! grep -qFx "${song}" "${SONGS_LIST_FOLDER}/${selected_song_list}"; then
                    echo -e "${song}"
                fi
            else
                if grep -qFx "${song}" "${SONGS_LIST_FOLDER}/${selected_song_list}"; then
                    echo -e "${song}"
                fi
            fi
        done < "${2}"
    else
        if [[ -z ${1} ]]; then
            err "Please enter a song list number"
        else
            if [[ ! -e ${2} ]]; then
                err "'${2}': File does not exist"
            fi
        fi
    fi
}

# m3u files content order is as follows:
# #EXTM3U
# #EXTINF:<seconds>,<file_name>
# #<path_to_song>
# #EXTINF:<seconds>,<file_name>
# #<path_to_song>
# ...
generate_m3u() {
    check_song_list_number "${1}"
    local song_metadata song_seconds m3u_content counter selected_song_list song selected_song_list_line_count
    selected_song_list="$(get_song_list "${1}")"
    selected_song_list_line_count=$(wc -l < "${SONGS_LIST_FOLDER}/${selected_song_list}")
    m3u_content="#EXTM3U\n"
    while IFS=$'\n' read -r song; do
        counter=$((counter + 1))
        song_metadata="$(mutagen-inspect "${song}")"
        if ! grep -qe '^- Unknown file type' <<< "${song_metadata}"; then
            song_seconds="$(echo "${song_metadata}" | grep -e '^-\s' | perl -pe 's/.*\s(?=[0-9]+\.[0-9]*\sseconds)//' | perl -pe 's/(?=seconds).*//' | sed -e 's/\..*$//' | tr -d ' ')"
        else
            msg "[${counter}] ${song} -- skipping unknown file type"
            continue
        fi
        if [[ ! ${song_seconds} =~ ^[0-9]+$ ]]; then
            err "Bad parsing of music file metadata -> 'seconds'. Needs debugging.\n\nFile: ${song}\n\nmutagen output:\n${song_metadata}\n\n'seconds' variable result: ${song_seconds}\n\nCounter: ${counter}"
        fi
        if [[ ${selected_song_list_line_count} -eq ${counter} ]]; then
            m3u_content="${m3u_content}#EXTINF:${song_seconds},$(basename "${song}" | sed -e 's/\..*$//')\n${song}"
        else
            m3u_content="${m3u_content}#EXTINF:${song_seconds},$(basename "${song}" | sed -e 's/\..*$//')\n${song}\n"
        fi
    done < "${SONGS_LIST_FOLDER}/${selected_song_list}"
    echo -e "${m3u_content}" > "${M3U_OUTPUT_FILE_PATH}/${selected_song_list}.m3u"
    #    echo -e "${m3u_content}"
}

print_usage() {
    cat << EOF
Usage: ${0##*/} { <song_list_number> [-pd [-n]|-rd|-ls] } | { [-rff|-pnaff|-paff] <song_list_number> SONGS_LIST_FILE [-print] }
Options:
    song_list_number        An integer listed on the list-songlist command or -ls representing the file to be parsed, if used without any other flag, then it will generate a m3u playlist file
    --list-songlists,-ls    List a numbered list of the files that can be parsed into m3u's playlists
    --print-dupes,-pd       Prints all duplicated entries inside the song list, use '-n' after this argument to output the respective line number of each entry
    --remove-dupes,-rd      Cleans the selected song list from duplicated entries
    --remove-from-file,-rff Uses SONGS_LIST_FILE entries and greps them in order to remove each one from the actual selected song list, the file must contain only file paths of songs on each line. Use the optional -print flag to just print all entries that would be deleted and not to perform deletion
    --non-available,-pnaff  Look for each entry in SONG_LIST_FILE and prints those that didn't match any entry inside the selected song list
    --print-available,-paff Look for each entry in SONG_LIST_FILE and prints those that DID match the respective entry inside the selected song list
    --help,-h               Show this message
EOF
}

mkplaylist() {
    case "${1}" in
        --help | -h)
            print_usage
            exit 0
            ;;
        --list-songslists | -ls)
            list_song_lists
            exit 0
            ;;
        --remove-dupes | -rd)
            remove_duplicated_songs "${2}"
            ;;
        --print-dupes | -pd)
            print_dupes "${2}"
            exit 0
            ;;
        --remove-from-file | -rff)
            remove_songs_from_another_list "${2}" "${3}" "${4}"
            ;;
        --non-available | -pnaff)
            print_not_available_songs_from_file "${2}" "${3}" "${4}"
            ;;
        --print-available | -paff)
            print_not_available_songs_from_file "${2}" "${3}" "${4}" -v
            ;;
        [0-9] | [0-9][0-9])
            case "${2}" in
                --remove-dupes | -rd)
                    remove_duplicated_songs "${1}"
                    ;;
                --print-dupes | -pd)
                    print_dupes "${1}"
                    exit 0
                    ;;
                *)
                    generate_m3u "${1}"
                    ;;
            esac
            ;;
        *)
            print_usage
            exit 0
            ;;
    esac
}

mkplaylist "${@}"
