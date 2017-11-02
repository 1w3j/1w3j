#!/usr/bin/env sh

# usage:
# chjdk [-l] [jdkfoldername]

JVM_PATH=/usr/lib/jvm/
JDK_DEFAULT_PATH=/usr/lib/jvm/default-runtime

err() {
    echo >&2 `tput bold; tput setaf 1`"[-] ERROR: ${*}"`tput sgr0`
    exit 1
}

msg() {
    echo `tput bold; tput setaf 2`"[+] ${*}"`tput sgr0`
}

warn() {
    echo >&2 `tput bold; tput setaf 1`"[!] WARNING: ${*}"`tput sgr0`
}

check_root() {
    if [ $EUID -ne 0 ] ; then
        err "you must be root"
    fi
}


if [ $1 == "-l" ] || [ $1 == "list" ]; then
  ls -l ${JVM_PATH};
else
  JDK_PATH="$JVM_PATH$1"
  if [ -e $JDK_PATH ]; then
    check_root
    msg Linking \"$JDK_DEFAULT_PATH\" to \"$JDK_PATH\";
    [[ -e $JDK_DEFAULT_PATH ]] && warn "Removing $JDK_DEFAULT_PATH" && sudo rm $JDK_DEFAULT_PATH;
    sudo ln -s $JDK_PATH $JDK_DEFAULT_PATH
    msg "Job Finished"
  else
    err "$JDK_PATH does not exist";
  fi;
fi;
