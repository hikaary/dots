#!/bin/bash

V2RAY_CONFIG="/home/hikary/.config/v2ray/vpn.json"
V2RAY_BLOCK_CONFIG="/home/hikary/.config/v2ray/block.json"

set_proxy() {
    pkill -f "v2ray"
    
    v2ray run --config="$V2RAY_CONFIG" &
    
    dunstify -a "v2ray" "Proxy enabled"
}

unset_proxy() {
    pkill -f "v2ray"
    
    v2ray run --config="$V2RAY_BLOCK_CONFIG" &
    
    dunstify -a "v2ray" "Proxy disabled"
}

check_proxy() {
    if pgrep -f "v2ray.*$V2RAY_CONFIG" > /dev/null; then
        return 0
    else
        return 1
    fi
}

if check_proxy; then
    unset_proxy
else
    set_proxy
fi
