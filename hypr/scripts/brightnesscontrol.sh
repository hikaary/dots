#!/usr/bin/env sh

ScrDir=`dirname "$(realpath "$0")"`

function print_error
{
cat << "EOF"
    ./brightnesscontrol.sh <action>
    ...valid actions are...
        i -- <i>ncrease brightness [+5%]
        d -- <d>ecrease brightness [-5%]
EOF
}

function send_notification {
    brightness=`brightnessctl info | grep -oP "(?<=\()\d+(?=%)" | cat`
    brightinfo=$(brightnessctl info | awk -F "'" '/Device/ {print $2}')
    angle="$(((($brightness + 2) / 5) * 5))"
    ico="~/.config/dunst/icons/vol/vol-${angle}.svg"
    notify-send -a "t2" -r 91190 -t 800 -i "${ico}" "${brightness}%"
}

function get_brightness {
    brightnessctl -m | grep -o '[0-9]\+%' | head -c-2
}

case $1 in
i)  
    if [[ $(get_brightness) -lt 10 ]] ; then
        brightnessctl set +5%
    else
        brightnessctl set +10%
    fi
    send_notification ;;
d)  
    if [[ $(get_brightness) -le 1 ]] ; then
        brightnessctl set 1%
    elif [[ $(get_brightness) -le 10 ]] ; then
        brightnessctl set 5%-
    else
        brightnessctl set 10%-
    fi
    send_notification ;;
*) 
    print_error ;;
esac

