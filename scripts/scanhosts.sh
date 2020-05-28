#!/usr/bin/env bash

# Usage:
#         scanhosts [number of the subnet]
# Example:
#         $ scanhosts 0   # pings all 192.168.0.* IPs
#         $ scanhosts 43   # pings all 192.168.43.* IPs

for ip in $(seq 1 254); do
    ping -c 1 192.168.${1}.${ip}>/dev/null
    [[ $? -eq 0 ]] && echo 192.168."$1".${ip} UP || : # NOTE: ':' double points make output pipe to devnull
done
