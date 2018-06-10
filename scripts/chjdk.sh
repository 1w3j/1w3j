#!/usr/bin/env sh

# usage:
# chjdk [-l] [jdkfoldername]

source ~/1w3j/functions.sh

JVM_PATH=/opt/;
JDK_DEFAULT_PATH=/usr/bin/java;

if [[ $1 == "-l" ]] || [[ $1 == "list" ]]; then
  ls -l ${JVM_PATH} | grep 'jdk' -i;
else
  err "Sorry script not implemented yet";
  JDK_PATH="$JVM_PATH$1";
  if [ -e $JDK_PATH ]; then
    check_root;
    msg Linking \"$JDK_DEFAULT_PATH\" to \"$JDK_PATH\";
    [[ -e $JDK_DEFAULT_PATH ]] && warn "Removing $JDK_DEFAULT_PATH" && sudo rm $JDK_DEFAULT_PATH;
    sudo ln -s $JDK_PATH $JDK_DEFAULT_PATH;
    msg "Job Finished";
  else
    err "$JDK_PATH does not exist";
  fi;
fi;
