#!/usr/bin/env bash

if [[ -e "$1" ]]; then
  echo Linking "$1" -\> ~/Bittorrent && ln -s "$(realpath $1)" ~/Bittorrent
else
    echo "$1 does not exist"
fi