#!/usr/bin/env bash

US3R="?"

err(){
    eval "$(cat ~/1w3j/handle_funcname.inc.sh)"
    # shellcheck disable=SC2006
    echo >&2 -e "$(tput bold; tput setaf 1)[-] ${FUNCTIONS[1]} ERROR: ${*}$(tput sgr0)"
    exit 163
}

warn(){
    eval "$(cat ~/1w3j/handle_funcname.inc.sh)"
    echo >&2 -e "$(tput bold; tput setaf 3)[!] ${FUNCTIONS[1]} WARNING: ${*}$(tput sgr0)"
}

msg(){
    eval "$(cat ~/1w3j/handle_funcname.inc.sh)"
    echo -e "$(tput bold; tput setaf 2)[+] ${FUNCTIONS[$CURRENT_FUNCTION_NAME_INDEX]}: ${*}$(tput sgr0)"
}

check_root() {
    if [[ ${EUID} -ne 0 ]]; then
        err "You must be root"
    fi
}

append() {
    # ${1} -> string to be appended
    # ${2} -> file path to append to
    if [[ -z $(grep "\<${1}\>" ${2}) ]]; then echo "${1}" >> ${2}; fi
}

replace_us3r_in_file(){
    if [[ -n "${1}" ]]; then
        sed -i "s/\$US3R/${US3R}/g" "${1}"
    else
        err "File argument missing"
    fi
}

is_sourced_in_external_function(){
    [[ ${#FUNCTIONS[*]} -gt 3 ]]
}

usage() {
    case "${0##*/}" in
        functions.sh)
            cat << EOF

This script manages utilities used for the repository, can be used to change the default UNIX user too
Usage: ./functions.sh [-h|--help] [--change-us3r]
    -h, --help              Shows this message
    --change-us3r           Change the default UNIX us3r name for usage in scripts from this repo
EOF
        ;;
    esac
}

us3r_exists() {
    [[ -n "${US3R}" ]]
}

create_us3r() {
    echo -n 'Type your UNIX username: '
    read -r US3R
    echo "${US3R}" 1> ~/1w3j/us3r && msg "${US3R}" successfully changed
}

detect_us3r() {
    if us3r_exists; then
        if [[ ! "${1}" = "--quiet" ]]; then
            msg "UNIX user ${US3R} detected!!"
        fi
    else
        create_us3r
    fi;
}

functions() {
    US3R=$(cat ~/1w3j/us3r 2>/dev/null)
    case "${1}" in
        --create-us3r)
            create_us3r
            ;;
        --help|-h)
            usage
            ;;
        *)
    #       e.g. when called within a function in scripts
    #             $ source resetintellijkey.sh --just-get-configpath
            if is_sourced_in_external_function; then
                detect_us3r --quiet
            else
                detect_us3r
            fi
            ;;
    esac
}

functions "${@}"
