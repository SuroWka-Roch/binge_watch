#!/bin/bash

LIST_FILE_NAME="binge_list.txt"

# Generate a list of films to watch using input arguments
if [[ $# -ne 0 ]]; then
  for var in "$@"; do
    echo $var >>$LIST_FILE_NAME
  done
fi

while true; do
  TO_WATCH=$(head -n 1 $LIST_FILE_NAME)

  #Panic exit at empty line
  if [ -z $TO_WATCH ]; then
    echo "File $LIST_FILE_NAME is empty, looks like you finished :("
    exit 0
  fi

  echo "Starting $TO_WATCH"
  vlc "$TO_WATCH" &>/dev/null

  echo "Are you done watching $TO_WATCH?"
  read -p " \"y\" or \"n\"." -n 1 -r
  echo

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    sed -i "/$TO_WATCH/d" $LIST_FILE_NAME
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
