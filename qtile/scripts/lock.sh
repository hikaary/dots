#!/bin/bash

# Путь к файлу с цветами pywal
wal_colors="$HOME/.cache/wal/colors.sh"

# Загрузка цветов из pywal
if [ -f "$wal_colors" ]; then
	source "$wal_colors"
else
	echo "Файл цветов pywal не найден. Убедитесь, что pywal был запущен."
	exit 1
fi

# Создаем временную директорию для скриншотов
temp_dir=$(mktemp -d)

# Получаем список активных мониторов
monitors=$(way-displays -g | grep 'name:' | awk '{print $2}' | tr -d "'")

for monitor in $monitors; do
	screenshot_path="$temp_dir/$monitor.png"
	grim -o "$monitor" "$screenshot_path"
	convert "$screenshot_path" -blur 0x8 "$screenshot_path"
done

swaylock_args=()
for monitor in $monitors; do
	screenshot_path="$temp_dir/$monitor.png"
	swaylock_args+=(--image "$monitor:$screenshot_path")
done

swaylock_args+=(
	--inside-color "${color0}88"
	--ring-color "$color1"
	--line-color "$color2"
	--text-color "$color15"
	--text-ver-color "$color15"
	--text-clear-color "$color15"
	--layout-text-color "$color15"
	--key-hl-color "$color4"           # Цвет подсветки клавиш
	--bs-hl-color "$color5"            # Цвет подсветки backspace
	--separator-color "00000000"       # Цвет разделителя
	--layout-bg-color "00000000"       # Цвет фона текста раскладки
	--layout-border-color "00000000"   # Цвет границы текста раскладки
	--ring-ver-color "$color2"         # Цвет кольца при верификации
	--inside-ver-color "${color0}88"   # Внутренний цвет при верификации
	--ring-wrong-color "$color3"       # Цвет кольца при ошибке ввода
	--inside-wrong-color "${color0}88" # Внутренний цвет при ошибке ввода
	--ring-clear-color "$color4"       # Цвет кольца при очистке ввода
	--inside-clear-color "${color0}88" # Внутренний цвет при очистке ввода
	--indicator-radius=100             # Радиус индикатора
	--indicator-thickness=7            # Толщина индикатора
	--font='Hack Nerd Font'            # Шрифт
)

# Запускаем swaylock с аргументами
swaylock "${swaylock_args[@]}"
# Очищаем временную директорию
rm -r "$temp_dir"
