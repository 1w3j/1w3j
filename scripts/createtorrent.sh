#!/usr/bin/env bash

#
# Usage:
#
# createtorrent folderpath/ torrentpath
#

source ~/1w3j/functions.sh

FOLDER_PATH="$(realpath "${1}")"
TORRENT_PATH="$(realpath "${2}")"
ANNOUNCERS=(
#    udp://tracker.openbittorrent.com:80/announce
#    udp://tracker.publicbt.com:80/announce
#    udp://tracker.istole.it:80/announce
    http://182.176.139.129:6969/announce
    udp://public.popcorn-tracker.org:6969/announce
    http://5.79.83.193:2710/announce
    http://91.218.230.81:6969/announce
    udp://tracker.ilibr.org:80/announce
);
COMMENT="by j3w1"

createtorrent () {
    ANNOUNCERS_STRING_TMP=$(printf ",%s" "${ANNOUNCERS[@]}")
    ANNOUNCERS_STRING=${ANNOUNCERS_STRING_TMP:1}
    rm -i "${TORRENT_PATH}"
    mktorrent -l 24 -c "${COMMENT}" -o "${TORRENT_PATH}" -v "${FOLDER_PATH}" -a "${ANNOUNCERS_STRING}"
}

createtorrent "${@}"
