#!/bin/bash

get_empty_firefox_window() {
    # hyprctl clients -j | jq -r '.[] | select(.class == "firefox" and .title == "Claude — Mozilla Firefox") | .address'
    hyprctl clients -j | jq -r '.[] | select(.class == "firefox" and .title == "Mozilla Firefox") | .address'
}

firefox &
firefox --new-window https://claude.ai/ &

sleep 2

empty_window=$(get_empty_firefox_window)

if [ ! -z "$empty_window" ]; then
    hyprctl dispatch movetoworkspacesilent special:gpt,address:$empty_window
else
    echo "Не удалось найти пустое окно Firefox"
fi
