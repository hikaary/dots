#!/bin/sh

gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Ice" &
/usr/bin/pipewire & /usr/bin/pipewire-pulse & /usr/bin/wireplumber &

way-displays &
easyeffects & 
dunst &
firefox &
obsidian &
vesktop &
nekoray &
swayidle -w \
	timeout 500 '~/.config/qtile/scripts/lock.sh' 
  # timeout 1000 'systemctl suspend'
