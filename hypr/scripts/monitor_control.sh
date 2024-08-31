#!/bin/bash

sleep 5

check_monitors() {
  MONITORS=$(hyprctl monitors -j | jq -r '.[].name')
  OTHER_MONITORS=$(echo "$MONITORS" | grep -v "^eDP-1$")
  echo $OTHER_MONITORS

  if [ -n "$OTHER_MONITORS" ]; then
    sleep 2
    hyprctl keyword monitor "eDP-1,disable"
    killall wpaperd
    wpaperd -d
  else
    sleep 2
    hyprctl keyword monitor "eDP-1,2560x1600@120, 0x0, 1.333333"
    killall wpaperd
    wpaperd -d
  fi
}

check_monitors

socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do
  case ${line%>>*} in
  monitoradded* | monitorremoved*)
    check_monitors
    ;;
  esac
done
