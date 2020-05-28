#!/usr/bin/env bash
# RUN
# Inno Setup script
unset DISPLAY
script_name=${1}
[[ -f "${script_name}" ]] && script_name=$(winepath -w "${script_name}")
wine "C:\Program Files (x86)\Inno Setup 5\ISCC.exe" "${script_name}" "${2}" "${3}" "${4}" "${5}" "${6}" "${7}" "${8}" "${9}"
