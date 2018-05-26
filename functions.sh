#!/usr/bin/env sh

err()
{
    echo >&2 -e `tput bold; tput setaf 1`"[-] ${FUNCNAME[1]} ERROR: ${*}"`tput sgr0`;
    exit 1337;
}

warn()
{
    echo >&2 -e `tput bold; tput setaf 3`"[!] ${FUNCNAME[1]} WARNING: ${*}"`tput sgr0`;
}

msg()
{
    echo -e `tput bold; tput setaf 2`"[+] ${FUNCNAME[1]}: ${*}"`tput sgr0`;
}

is_called_within_external_function(){
    [ ${#FUNCNAME[*]} -gt 4 ]
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
        if [[ ! ${1} = "--quiet" ]]; then
            msg "UNIX user ${US3R} detected!!";
        fi
    else
        create_us3r;
    fi;
}

init_sh() {
    US3R=`cat ~/1w3j/us3r 2>/dev/null`;
    case "$1" in
    --change-us3r)
        create_us3r;
        ;;
    --help|-h)
        usage;
        ;;
    *)
#       e.g. resetintellijkey.sh --just-get-configpath
        if is_called_within_external_function; then
            detect_us3r --quiet;
        else
            detect_us3r;
        fi;
        ;;
    esac;
}

init_sh ${*};
