#!/bin/bash
if [ $# -eq 0 ]; then
    echo -e "myip.opendns.com:\n";
    dig +short myip.opendns.com @resolver1.opendns.com;
    echo -e "ipinfo.io:\n";
    curl "ipinfo.io";
    echo -e "\r"
else
    if [ $1 = "-s" -o $1 = "-short" ]; then
        curl "ipinfo.io/ip"
    fi
fi
