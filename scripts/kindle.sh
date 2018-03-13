#!/usr/bin/env zsh

# Open Kindle for PC app and links the book in 'My Kindle Content' to the original path, in order to save space
# usage: $ kindle "/path/to/book.pdf"

KINDLE_APP_PATH=~/.wine/drive_c/Program\ Files\ \(x86\)/Amazon/Kindle/Kindle.exe
MY_KINDLE_CONTENT_PATH=~/Documents/My\ Kindle\ Content

if [[ "$1" = "-l" ]]; then
  ls -l "$MY_KINDLE_CONTENT_PATH";
else
  if [[ -e "$1" ]]; then
    wine "$KINDLE_APP_PATH" "$1" &>/dev/null;
    DUPLICATED_BOOK_PATH="$MY_KINDLE_CONTENT_PATH"/$(basename "$1");
    echo -e "\n"
    echo removing "$DUPLICATED_BOOK_PATH";
    rm "$DUPLICATED_BOOK_PATH";
    echo linking "$1" '->' "$DUPLICATED_BOOK_PATH";
    ln -s "$1" "$DUPLICATED_BOOK_PATH";
  else
    >&2 echo "$1" does not exist;
    exit 1;
  fi;
fi;
