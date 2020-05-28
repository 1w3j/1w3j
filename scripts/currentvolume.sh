#!/usr/bin/env bash

awk -F "[][]" '/dB/ { print $2 }' <( amixer sget PCM ) | tail -n-1
