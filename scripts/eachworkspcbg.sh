#!/usr/bin/env sh

# one background per workspace (supports 2 wrkspcs)

BASE_DIR=~/1w3j/

IMAGE[0]=OMEN_by_HP.jpg
IMAGE[1]=http-status-codes.png

gsettings set org.cinnamon.desktop.background picture-options "stretched"

setbackground (){
  gsettings set org.cinnamon.desktop.background picture-uri "file://$BASE_DIR$1"
}

xprop -root -spy _NET_CURRENT_DESKTOP | {
  while read -r; do
    CURRENT_DESKTOP=${REPLY:${#REPLY}-1:1}
    echo Current Desktop: $CURRENT_DESKTOP;
    echo $BASE_DIR${IMAGE[$CURRENT_DESKTOP]}
    setbackground ${IMAGE[$CURRENT_DESKTOP]}
  done;
}
