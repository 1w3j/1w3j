#!/usr/bin/env sh

# Usage:
#
# $ testrars dir
#
# where 'dir' is a folder containing rar archives
# prints a list of corrupted archives to stderr

if [ -n "$1" ]; then
  if [ -e "$1" ]; then
    FILES=();
    for f in $1/*.rar; do
        [ -f "$f" ] && FILE=$(realpath "$f");
        #echo file: "$FILE";
        FILES=("$FILE" "${FILES[@]}");
    done;
    QTY_FILES=${#FILES[@]};
    if [ ${#FILES[@]} -gt 0 ]; then
      if [[ "$2" != "--bad-only" ]]; then
        echo "$QTY_FILES rar archives found:";
        for (( i=1; i<=${QTY_FILES}; i++ )); do
          echo -e "\t$i) $(basename "${FILES[$i]}")";
          [ $i -eq 10 ] && break;
        done;
        read -p 'Press ENTER to continue the test or Ctrl-c the shit out of here';
      fi;
      for f in "${FILES[@]}"; do
        #echo -e "$f"
        unrar t "$f" &>/dev/null;
        UNRAR_EXIT_CODE="$?";
        if [[ $UNRAR_EXIT_CODE -eq 0 ]] && [[ "$2" != "--bad-only" ]]; then
          echo [OK]..."$f";
        else
          if [[ $UNRAR_EXIT_CODE -ne 0 ]]; then
            if [[ "$2" = "--bad-only" ]]; then
              echo "$f";
            else
              echo [BAD]..."$f";
            fi;
          fi;
        fi;
      done;
    else
      >&2 echo "0 rars found...Nothing to do!";
    fi;
  else
    >&2 echo "$1": Folder doesn\'t exist;
  fi;
else
  >&2 echo "What folder did you say?"
fi;
