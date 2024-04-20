#!/bin/sh

gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Ice" &
/usr/bin/pipewire & /usr/bin/pipewire-pulse & /usr/bin/wireplumber &
xrdb -merge ~/.Xresources & 

way-displays &
easyeffects & 
dunst &
beeper & 
qutebrowser &
firefox & 
obsidian &
vesktop &
spotifyd --config-path /home/hikary/.config/spotifyd --no-daemon --proxy socks5://localhost:1080 &
swayidle -w \
	timeout 500 '~/.config/qtile/scripts/lock.sh' 
  # timeout 1000 'systemctl suspend'
