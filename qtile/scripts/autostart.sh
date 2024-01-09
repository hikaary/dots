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
      timeout 1000 'systemctl suspend'  &

