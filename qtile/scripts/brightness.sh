#!/bin/bash

last_state=""

while true; do
    battery_level=$(cat /sys/class/power_supply/BAT0/capacity)
    
    if [[ "$battery_level" -le 20 && "$last_state" != "20" && "$last_state" != "10" ]]; then
        brightnessctl set 70%
        notify-send "Низкий заряд батареи" "Уровень заряда батареи ниже 20%, яркость уменьшена до 70%"
        last_state="20"
    elif [[ "$battery_level" -le 10 && "$last_state" != "10" ]]; then
        brightnessctl set 50%
        notify-send "Критический заряд батареи" "Уровень заряда батареи ниже 10%, яркость уменьшена до 50%"
        last_state="10"
    elif [[ "$battery_level" -gt 20 && "$last_state" == "20" ]]; then
        last_state=""
    elif [[ "$battery_level" -gt 10 && "$last_state" == "10" ]]; then
        last_state=""
    fi

    sleep 60 
done
