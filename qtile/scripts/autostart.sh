#!/bin/sh

gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Ice" &
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots &

way-displays &
dunst &
firefox &
obsidian &
vesktop &
nekoray &
swayidle -w \
	timeout 500 '~/.config/qtile/scripts/lock.sh'
timeout 1000 'systemctl suspend'
