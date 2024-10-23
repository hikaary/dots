#!/bin/sh

# Завершаем старые процессы
pkill -f xdg-desktop-portal-wlr
pkill -f xdg-desktop-portal

sleep 2

# Устанавливаем необходимые переменные окружения для dbus
export XDG_CURRENT_DESKTOP=river
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=river

# Обновляем dbus окружение
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_DESKTOP

sleep 2

# Запускаем portal-wlr первым (важно!)
/usr/lib/xdg-desktop-portal-wlr &
sleep 3

# Запускаем основной портал с явным указанием использовать wlr бэкенд
/usr/lib/xdg-desktop-portal --replace -r &

sleep 2
