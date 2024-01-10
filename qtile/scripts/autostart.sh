#!/bin/sh
gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Ice" &
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots &

dunst &
firefox &
webcord &
obsidian &
swayidle -w \
      timeout 1000 'systemctl suspend'  &

