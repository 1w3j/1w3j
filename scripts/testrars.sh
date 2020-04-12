#!/usr/bin/env bash

# Usage:
#
# $ testrars dir [--bad-only]
#
# where 'dir' is a folder containing rar archives
# prints a list of corrupted archives to stderr
# --bad-only makes the script output bad rars' absolute paths

if [[ -n "${1}" ]]; then
  if [[ -e "${1}" ]]; then
    FILES=()
    for file in ${1}/*.rar; do
        [[ -f "${file}" ]] && FILE=$(realpath "${file}")
        #echo file: "${FILE}"
        FILES=("${FILE}" "${FILES[@]}")
    done;
    QTY_FILES=$((${#FILES[@]}))
    if [[ ${QTY_FILES} -gt 0 ]]; then
      if [[ "${2}" != "--bad-only" ]]; then
        echo "${QTY_FILES} rar archives found:"
        for (( i=0; i<=$((${QTY_FILES} - 1 )); i++ )); do
          echo -e "\t$(( ${i} + 1 )) $(basename "${FILES[$i]}")"
          [[ ${i} -eq 10 ]] && break
        done
        read -p 'Press ENTER to continue the test or Ctrl-c the shit out of here'
      fi;
      for file in "${FILES[@]}"; do
        #echo -e "${f}"
        unrar t "${file}" &>/dev/null
        UNRAR_EXIT_CODE="${?}"
        if [[ ${UNRAR_EXIT_CODE} -eq 0 ]] && [[ "${2}" != "--bad-only" ]]; then
          echo [OK]..."${file}"
        else
          if [[ ${UNRAR_EXIT_CODE} -ne 0 ]]; then
            if [[ "${2}" = "--bad-only" ]]; then
              echo "${file}"
            else
              echo [BAD]..."${file}"
            fi
          fi
        fi
      done
    else
      >&2 echo "0 rars found...Nothing to do!"
      exit 1
    fi
  else
    >&2 echo "${1}": Folder doesn\'t exist
    exit 2
  fi
else
  >&2 echo "What folder did you say?"
  exit 3
fi
