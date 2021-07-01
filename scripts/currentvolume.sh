#!/usr/bin/env bash

awk -F "[][]" '/%/ { print $2 }' <( amixer sget Master) | tail -n-1
