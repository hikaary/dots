#!/bin/bash

# Загрузка цветов Pywal
source ~/.cache/wal/colors.sh

# Путь к SVG файлам
SVG_DIR="$HOME/.config/qtile/icons"

# Замена цвета во всех SVG файлах
for svg in "$SVG_DIR"/*.svg; do
	sed -i "s/fill=\"#[a-zA-Z0-9]*\"/fill=\"$foreground\"/" "$svg"
done
