#!/usr/bin/env sh

#
# Usage:
#
# createtorrent folderpath/ torrentpath
#

source ~/1w3j/functions.sh;

FOLDER_PATH="${1}";
TORRENT_PATH="${2}";
ANNOUNCERS=(
    udp://zer0day.ch:1337,
    udp://tracker.leechers-paradise.org:6969
    udp://open.demonii.com:1337
);
COMMENT="by j3w1";

createtorrent () {
    ANNOUNCERS_STRING="";
    for (( i=0; i<${#ANNOUNCERS[*]}; i++ )); do
        if [ $((${#ANNOUNCERS[*]} - 1)) -eq ${i} ]; then
            ANNOUNCERS_STRING="${ANNOUNCERS_STRING}","${ANNOUNCERS[${i}]}";
        else
            ANNOUNCERS_STRING="${ANNOUNCERS_STRING}""${ANNOUNCERS[${i}]}";
        fi;
    done;
    mktorrent -l 24 -c "${COMMENT}" -o "${TORRENT_PATH}" -v "${FOLDER_PATH}" -a "${ANNOUNCERS_STRING}"
}

createtorrent "${*}";
