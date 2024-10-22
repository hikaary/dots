#!/bin/sh

swww-daemon
directory=~/.config/wallpapers/mocha-green.png
wallpaper=$(find "$directory" -type f | shuf -n 1)
swww img "$wallpaper" --resize crop --transition-type wipe --transition-angle 30 --transition-fps 60 --transition-duration 1.5 #setting wallpaper
