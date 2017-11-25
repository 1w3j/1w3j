#!/usr/bin/env sh

# Check if ping can reach the specified host, if not NMCLI will reconnect to a specified network name (see 'nmcli connections')
# Usage:
# checkping [qbit]

IP='10.0.10.1';
WIFI_NAME="1b";

RED=$(tput sgr0 && tput setaf 1 && tput bold);
GREEN=$(tput sgr0 && tput setaf 2 && tput bold);
YELLOW=$(tput sgr0 && tput setaf 3);
STD=$(tput sgr0);
UL=$(tput smul); # UnderLine
NUL=$(tput rmul); # No UnderLine

PING_EXIT_CODE_TRIGGER=0;
PING_FAILED_COUNT=0;
PING_FAILED_COUNT_TRIGGER=6;
PING_SLEEP_TIME=2;
NMCLI_EXIT_CODE_TRIGGER=0;

reconnect () {
  # do reconnect
  NMCLI_EXIT_STDOUT=$( sh -c "nmcli -p c u $1 2>&1" );
  NMCLI_EXIT_CODE=$?;
  # if reconnection failed
  if [ $NMCLI_EXIT_CODE -ne $NMCLI_EXIT_CODE_TRIGGER ]; then
    echo $RED$UL"$WIFI_NAME still UNREACHABLE"$NUL": NMCLI returned ("$NMCLI_EXIT_CODE"): "$NMCLI_EXIT_STDOUT;
    echo -e "\r"$UL"Reconnecting..."$NUL;
    # reconnect again
    reconnect $1;
  fi;
}

[[ -n "$*" ]] && [[ "$1" != "qbit" ]] && echo $UL"Did you mean 'qbit'?" && exit 1

echo -e $UL"Using $WIFI_NAME as wireless connection name"$NUL;

# eternal loop
for (( ; ; )); do
  # do ping 
  PING_STDOUT=$( sh -c "ping -q -c 1 $IP 2>&1" );
  PING_EXIT_CODE=$?;
  # if ping failed
  if [ $PING_EXIT_CODE -ne $PING_EXIT_CODE_TRIGGER ]; then 
    # increment failed count by one
    echo $YELLOW"[$(date +'%H:%M:%S')]: Failed Count: "$((++PING_FAILED_COUNT))" --- PING returned "$PING_EXIT_CODE" --- "$(($PING_FAILED_COUNT_TRIGGER-$PING_FAILED_COUNT))" more failed attemps to reconnect";
    # and if failed count reached max attempts
    if [ $PING_FAILED_COUNT -ge $PING_FAILED_COUNT_TRIGGER ]; then
      # kill qbittorrent process if specified
      if [ "$1" == "qbit" ]; then
        if pidof qbittorrent 1>/dev/null; then
          echo $YELLOW"Killing all qbitorrent processes...";
          killall qbittorrent;
          echo $YELLOW"Waiting 3 seconds...";
          sleep 3;
          echo $YELLOW"Wait finished";
        fi;
      fi;
      # reconnect wifi
      echo $RED"Max failed attemps reached("$PING_FAILED_COUNT_TRIGGER") --- PING returned ("$EXIT_CODE") --- Trying to reconnect...";
      reconnect $WIFI_NAME;
    fi;
  # if ping didn't failed
  else
    # print info and set failed count to Zero
    PING_FAILED_COUNT=0;
    PING_STDOUT_INFO=`echo $PING_STDOUT | cut -d"-" -f1`;
    echo -e $GREEN$UL"Host is OK"$NUL": "$PING_STDOUT;
    if [ "$1" == "qbit" ] ; then 
      if ! pidof qbittorrent 1>/dev/null; then
        echo $GREEN"Opening qbittorrent...";
        qbittorrent &>/dev/null &
      fi;
    fi;
    sleep $PING_SLEEP_TIME;
  fi
done;
