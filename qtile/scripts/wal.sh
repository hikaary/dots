#!/bin/bash

WALLPAPER="$HOME/.config/qtile/images/wallpaper.png"
TEMPLATE_DIR="$HOME/.config/wal/templates"

wal -i "$WALLPAPER"

for script in "$TEMPLATE_DIR"/*.sh; do
	[ -e "$script" ] || continue
	bash "$script"
done
