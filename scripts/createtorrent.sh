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
    udp://tracker.openbittorrent.com:80/announce
    udp://tracker.publicbt.com:80/announce
    udp://tracker.istole.it:80/announce
);
COMMENT="by j3w1";

createtorrent () {
    ANNOUNCERS_STRING_TMP=$(printf ",'%s'" "${ANNOUNCERS[@]}");
    ANNOUNCERS_STRING=${ANNOUNCERS_STRING_TMP:1};
    rm -iI "${TORRENT_PATH}";
    mktorrent -l 24 -c "${COMMENT}" -o "${TORRENT_PATH}" -v "${FOLDER_PATH}" -a "${ANNOUNCERS_STRING}"
}

createtorrent "${*}";
