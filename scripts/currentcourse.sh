#!/usr/bin/env zsh

CURRENT_COURSE_DIR=~/Current\ Course
CURRENT_COURSE_INFO_FILENAME=current_course_info.txt
CURRENT_COURSE_INFO_FILENAME_LOCATION=$CURRENT_COURSE_DIR/$CURRENT_COURSE_INFO_FILENAME

link_course () {
  course_tobe_linked="$1"
  extension="${course_tobe_linked##*.}"
  if [[ $extension = "zip" ]]; then
    zipped_course_name="${$(basename $course_tobe_linked)%.*}"
    echo "Unzipping Course..." && unzip -q $course_tobe_linked -d $CURRENT_COURSE_DIR;
    echo "Creating Current Course Info..." && echo "$zipped_course_name" > $CURRENT_COURSE_INFO_FILENAME_LOCATION;
    echo "Moving inner course folder content..." && mv $CURRENT_COURSE_DIR/"$zipped_course_name"/* $CURRENT_COURSE_DIR
    echo 'Deleting empty folder...' && rm -r $CURRENT_COURSE_DIR/"$zipped_course_name"
  else
    #echo "Linking Course \"$course_tobe_linked\"..." && cp -rs "$course_tobe_linked"/* $CURRENT_COURSE_DIR
    echo "Linking Course \"$course_tobe_linked\"..." && cp -r "$course_tobe_linked"/* $CURRENT_COURSE_DIR
    echo "Creating Current Course Info..." && echo `basename "$course_tobe_linked"` > $CURRENT_COURSE_INFO_FILENAME_LOCATION;
  fi;
}

# check if $CURRENT_COURSE_DIR exists
if [[ ! -d $CURRENT_COURSE_DIR ]]; then
  echo "Creating folder "$CURRENT_COURSE_DIR" for you..." && mkdir $CURRENT_COURSE_DIR;
fi
# if a path is passed as arg
if [[ -e "$1" ]]; then
  # if $CURRENT_COURSE_DIR has files inside
  if find "$CURRENT_COURSE_DIR" -mindepth 1 -print -quit | grep -q .; then
    #anythin before ? are variables
    read 'should_delete_previous?Do you want to replace your previous course (Y/n): '
    if [[ $should_delete_previous = "y" || $should_delete_previous = "Y" ]]; then
      echo Removing "$CURRENT_COURSE_DIR"'/*...' && rm -rf $CURRENT_COURSE_DIR/*
      link_course "$1";
    else
      if [[ $should_delete_previous = "n" || $should_delete_previous = "N" ]]; then
        echo "Then go fuck yourself"
        exit 0;
      else
        >&2 echo "\"$should_delete_previous\" is not a valid answer"
        exit 1;
      fi;
    fi;
  else
    link_course "$1"
  fi;
else
  # if $CURRENT_COURSE_INFO_FILENAME_LOCATION exists AND $CURRENT_COURSE_DIR has contents
  if [[ -f $CURRENT_COURSE_INFO_FILENAME_LOCATION ]]; then
    echo '|'
    echo -e '|' "\t"`cat $CURRENT_COURSE_INFO_FILENAME_LOCATION`
    echo '|';
  else
    echo -e "Wow $CURRENT_COURSE_INFO_FILENAME_LOCATION does not exist. but this is the content:\n"
  fi;
  ls -l $CURRENT_COURSE_DIR
fi;
