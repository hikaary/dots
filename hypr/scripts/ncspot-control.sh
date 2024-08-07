#!/bin/bash

SOCKET_PATH="/run/user/1000/ncspot/ncspot.sock"

function send_command {
    echo "$1" | socat - UNIX-CONNECT:$SOCKET_PATH
}

case "$1" in
    play|pause|playpause|next|previous|stop)
        send_command "$1"
        ;;
    status)
        send_command "status" | jq '.mode, .playable.title, .playable.artists[0]'
        ;;
    current)
        send_command "status" | jq -r '"\(.playable.artists[0]) - \(.playable.title)"'
        ;;
    *)
        echo "Usage: $0 {play|pause|playpause|next|previous|stop|status|current}"
        exit 1
        ;;
esac
