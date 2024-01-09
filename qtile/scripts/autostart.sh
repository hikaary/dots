#!/bin/sh

kanshi & 

dunst &
firefox &
webcord &
keepassxc &
obsidian &
gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Ice" &
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots &
swayidle -w \
            timeout 600 'swaylock --screenshots --clock --indicator
  --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --ring-color 103019 --key-hl-color 880033 --line-color 00000000 --inside-color 00000088 --separator-color 00000000 --fade-in 0.2' \
      timeout 1000 'systemctl suspend' \

