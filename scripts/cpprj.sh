#!/usr/bin/env sh
if [ $# -eq 2  ]; then
    echo "\n"
    target=`echo $1 | cut -d/ -f1`
    echo "copying to...`realpath $2`"
    mkdir -p $2
    cp -r $target/* $2
    cd $2
else
    #prints to stderr; use (>&2 echo '...') to avoid interaction with other redirections
    >&2 echo "usage: $0 originalprojectfolder targetfoldername"
fi