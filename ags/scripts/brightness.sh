#!/bin/bash

LOCKFILE=/tmp/brightness.lock

get_brightness() {
  brightnessctl g
}

set_brightness() {
  local brightness=$1
  if (($(echo "$brightness < 5" | bc -l))); then
    brightness=5
  fi
  brightnessctl s $brightness%
}

set() {
  if [ -n "$1" ]; then
    set_brightness $1
  else
    echo "Not enough arguments"
    exit 1
  fi
}

get() {
  if [ -e "$LOCKFILE" ] && kill -0 "$(cat $LOCKFILE)"; then
    local target_brightness=$(cat $LOCKFILE)
    echo $target_brightness
    exit 0
  fi
  percentage=$(get_brightness)
  echo "$percentage"
}

if [[ "$1" == "--set" ]]; then
  set $2
elif [[ "$1" == "--get" ]]; then
  get
fi
