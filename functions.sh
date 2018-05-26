#!/usr/bin/env sh

handle_funcname(){
    SH=`readlink /proc/$$/exe`
    CURRENT_FUNCTION_NAME_INDEX=1;
    case "$SH" in
      /usr/bin/zsh)
        # it seems that in zsh the first item in an array starts with 1
        FUNCTIONS=( ${funcstack[*]} );
        CURRENT_FUNCTION_NAME_INDEX=2;
        ;;
      /usr/bin/sh)
        # but in sh it starts with 0
        FUNCTIONS=( ${FUNCNAME[*]} );
        ;;
      /usr/bin/bash)
        FUNCTIONS=( ${FUNCNAME[*]} );
        ;;
      *)
        err "Please implement a handling function to use with $0 shell";
        ;;
    esac
}

err()
{
    SH=`readlink /proc/$$/exe`
    CURRENT_FUNCTION_NAME_INDEX=1;
    case "$SH" in
      /usr/bin/zsh)
        # it seems that in zsh the first item in an array starts with 1
        FUNCTIONS=( ${funcstack[*]} );
        CURRENT_FUNCTION_NAME_INDEX=2;
        ;;
      /usr/bin/sh)
        # but in sh it starts with 0
        FUNCTIONS=( ${FUNCNAME[*]} );
        ;;
      /usr/bin/bash)
        FUNCTIONS=( ${FUNCNAME[*]} );
        ;;
      *)
        err "Please implement a handling function to use with $0 shell";
        ;;
    esac
    echo >&2 -e `tput bold; tput setaf 1`"[-] ${FUNCTIONS[1]} ERROR: ${*}"`tput sgr0`;
    exit 1337;
}

warn()
{
    SH=`readlink /proc/$$/exe`
    CURRENT_FUNCTION_NAME_INDEX=1;
    case "$SH" in
      /usr/bin/zsh)
        # it seems that in zsh the first item in an array starts with 1
        FUNCTIONS=( ${funcstack[*]} );
        CURRENT_FUNCTION_NAME_INDEX=2;
        ;;
      /usr/bin/sh)
        # but in sh it starts with 0
        FUNCTIONS=( ${FUNCNAME[*]} );
        ;;
      /usr/bin/bash)
        FUNCTIONS=( ${FUNCNAME[*]} );
        ;;
      *)
        err "Please implement a handling function to use with $0 shell";
        ;;
    esac
    echo >&2 -e `tput bold; tput setaf 3`"[!] ${FUNCTIONS[1]} WARNING: ${*}"`tput sgr0`;
}

msg()
{
    SH=`readlink /proc/$$/exe`
    CURRENT_FUNCTION_NAME_INDEX=1;
    case "$SH" in
      /usr/bin/zsh)
        # it seems that in zsh the first item in an array starts with 1
        FUNCTIONS=( ${funcstack[*]} );
        CURRENT_FUNCTION_NAME_INDEX=2;
        ;;
      /usr/bin/sh)
        # but in sh it starts with 0
        FUNCTIONS=( ${FUNCNAME[*]} );
        ;;
      /usr/bin/bash)
        FUNCTIONS=( ${FUNCNAME[*]} );
        ;;
      *)
        err "Please implement a handling function to use with $0 shell";
        ;;
    esac
    echo -e `tput bold; tput setaf 2`"[+] ${FUNCTIONS[$CURRENT_FUNCTION_NAME_INDEX]}: ${*}"`tput sgr0`;
}

is_sourced_in_external_function(){
    [ ${#FUNCTIONS[*]} -gt 3 ]
}

usage() {
    cat << EOF
This script manages utilities used for the repository, can be used to change the default UNIX user too
Usage: ./functions.sh [-h|--help] [--change-us3r]
    -h, --help              Shows this message
    --change-us3r           Change the default UNIX us3r name for usage in scripts from this repo
EOF
}

us3r_exists() {
    [ -n "$US3R" ];
}

create_us3r() {
    echo -n 'Type your UNIX username: ';
    read US3R;
    echo "${US3R}" 1> ~/1w3j/us3r && msg "${US3R}" successfully changed;
}

detect_us3r() {
    if us3r_exists; then
        if [[ ! "${1}" = "--quiet" ]]; then
            msg "UNIX user ${US3R} detected!!";
        fi
    else
        create_us3r;
    fi;
}

functions() {
    US3R=`cat ~/1w3j/us3r 2>/dev/null`;
    case "$1" in
    --change-us3r)
        create_us3r;
        ;;
    --help|-h)
        usage;
        ;;
    *)
#       e.g. $ source resetintellijkey.sh --just-get-configpath
        if is_sourced_in_external_function; then
            detect_us3r --quiet;
        else
            detect_us3r;
        fi;
        ;;
    esac;
}

functions ${*};
