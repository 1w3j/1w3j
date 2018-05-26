#!/usr/bin/env sh

source ~/1w3j/functions.sh;

MINE_FOLDER=~/mine;
TRIM_CHAR=":";

cptomine(){
  if [ -n "$*" ]; then
    #note $@ does not care of $IFS, $* does
    for file in "$@"; do
      if [ -e "$file" ]; then
        NEW_NAME=`basename "$file" | tr --delete "$TRIM_CHAR"`;
        NEW_PATH=$MINE_FOLDER/$NEW_NAME;
        msg "Copying $file ==> $NEW_PATH";
        # copy and follow soft link if exists
        cp -L "$file" "$NEW_PATH";
      else
        err "$file: File doesn\'t exist";
      fi;
    done;
  else
    err "C0py wh4t?";
  fi;
}

cptomine "${*}";
