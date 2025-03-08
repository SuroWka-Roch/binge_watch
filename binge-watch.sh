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
  echo "Starting $TO_WATCH"
  vlc $TO_WATCH &>/dev/null
  echo "Are you done watching $TO_WATCH?"
  read -p " \"y\" will run next, \"n\" to exit program." -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    sed -i "/$TO_WATCH/d" $LIST_FILE_NAME
  else
    exit 0
  fi
done
