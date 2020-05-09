#!/usr/bin/env bash
if [[ ${#} -eq 2  ]]; then
    echo -e "\n"
    target=`echo ${1} | cut -d/ -f1`
    echo "Copying to...`realpath ${2}`"
    mkdir -p ${2}
    cp -ir ${target}/* ${2}
    cd ${2} || exit
else
    #prints to stderr; use (>&2 echo '...') to avoid interaction with other redirection
    >&2 echo "usage: ${0} originalprojectfolder targetfoldername"
fi
