#!/usr/bin/env bash

# Do not run this script while a VM guest is running

# shellcheck disable=SC1090
source ~/1w3j/functions.sh

msg "Removing license files"
rm -i /etc/vmware/license-ws-*
msg "Restarting services"
sudo /etc/init.d/vmware restart