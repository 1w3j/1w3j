#!/usr/bin/env sh

MINE_FOLDER=~/mine;
RM_CHAR=":";

if [ -n "$*" ]; then
  for file in $*; do
    if [ -e "$file" ]; then
      NEW_NAME=`basename "$file" | tr --delete "$RM_CHAR"`;
      NEW_PATH=$MINE_FOLDER/$NEW_NAME;
      echo "(*) Copying $file to $NEW_PATH";
      cp "$file" "$NEW_PATH";
    else
      >&2 echo 3rr0r: "$file": File doesn\'t exist;
    fi;
  done;
else
  >&2 echo "C0py wh4t?";
fi;
