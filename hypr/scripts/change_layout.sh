#!/bin/bash

LAYOUT=$(hyprctl -j getoption general:layout | jq '.str' | sed 's/"//g')

case $LAYOUT in
"master")
	hyprctl keyword general:layout dwindle
	hyprctl keyword bind SUPER,O,togglesplit
  notify-send -e -u low -i "$notif" "Dwindle Layout"
	;;
"dwindle")
	hyprctl keyword general:layout master
  notify-send -e -u low -i "$notif" "Master Layout"
	;;
*) ;;

esac
