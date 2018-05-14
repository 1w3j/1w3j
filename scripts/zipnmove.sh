#!/usr/bin/env sh
#
#   Simple script that makes zip files from folders without
#   keeping the source directory
#

SOURCE_DIR="$1"

source ~/1w3j/scripts/functions;

if [ -n "$1" ]; then
    if [ -e "$1" ]; then
        FOLDERS=();
        for d in $1/*; do
            if [ -d "$d" ]; then
                FOLDER=$(realpath "$d");
                echo adding folder: "$FOLDER";
                FOLDERS=("$FOLDER" "${FOLDERS[@]}");
            fi;
        done;
        QTY_FOLDERS=$((${#FOLDERS[@]}));
        if [ $QTY_FOLDERS -gt 0 ]; then
            echo "$QTY_FOLDERS folders found, showing first 10: ";
            for (( i=0; i<=$((${QTY_FOLDERS}-1)); i++ )); do
                echo -e "\t$((${i}+1)) $(basename "${FOLDERS[$i]}")";
                [ ${i} -eq 10 ] && break;
            done;
            read -p "Press ENTER to continue to zip or Ctrl-c the shit out of here";
            cd ${SOURCE_DIR};
            for (( i=0; i<=$((${QTY_FOLDERS}-1)); i++ )); do
                CURRENT_FOLDER=`basename "${FOLDERS[$i]}"`;
                echo -e "\t<=====================" "${CURRENT_FOLDER}" "========================>";
                zip -m -r -9 "${CURRENT_FOLDER}" "${CURRENT_FOLDER}";
            done;
        else
            warn "0 folders found.. Nothing to do !";
            exit 2;
        fi;
    else
        err "Folder doesn\'t exist";
    fi;
else
    err "What folder did you say?";
fi;