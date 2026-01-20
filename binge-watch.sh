#!/bin/bash

LIST_FILE_NAME="binge_list.txt"
USAGE="$(basename "$0") [ file_list ] -- program to track and autorun your series
program can be run without arguments to resume next episode from the $LIST_FILE_NAME

where:
    file_list - a list of files to watch. Will create $LIST_FILE_NAME to store watching progress. 
      List can be created by calling script with *.{file_extension}
"

VLC_FLAGS="-f --play-and-exit"

# Generate a list of films to watch using input arguments
if [[ $# -ne 0 ]]; then
  for var in "$@"; do
    echo $var >>$LIST_FILE_NAME
  done
fi

while true; do

  #Check if script was run correctly
  if [[ ! -f "./$LIST_FILE_NAME" ]]; then
    printf "Script did not find $LIST_FILE_NAME in current folder. Did you forget to provide list of files to watch?\n\n"
    echo "$USAGE"
    exit 1
  fi

  TO_WATCH=$(head -n 1 $LIST_FILE_NAME)

  #Panic exit at empty line
  if [ -z "$TO_WATCH" ]; then
    echo "File $LIST_FILE_NAME is empty, looks like you finished :("
    exit 0
  fi

  echo "Starting $TO_WATCH"
  vlc $VLC_FLAGS "$TO_WATCH" &>/dev/null


  echo "Are you done watching $TO_WATCH?"
  read -p " \"y\" or \"n\"." -n 1 -r
  echo

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    sed -i "1d" $LIST_FILE_NAME
  else
    exit 0
  fi

  echo "You want to watch next one?"
  read -p " \"y\" or \"n\"." -n 1 -r
  echo

  if [[ $REPLY =~ ^[Nn]$ ]]; then
    exit 0
  fi
done
