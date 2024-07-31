#!/bin/bash

# Проверка на root права
if [ "$EUID" -ne 0 ]
  then echo "Пожалуйста, запустите скрипт с правами root"
  exit
fi

# Установка и настройка TLP
pacman -S --noconfirm tlp tlp-rdw tlp-dinit 
dinitctl enable tlp

# Установка и настройка cpupower
pacman -S --noconfirm cpupower cpupower-dinit
cpupower frequency-set -g powersave
echo "governor='powersave'" > /etc/default/cpupower
dinitctl enable cpupower

# Установка и настройка термальной оптимизации
pacman -S --noconfirm thermald thermald-dinit
dinitctl enable thermald

# Оптимизация I/O планировщика для SSD
echo "ACTION==\"add|change\", KERNEL==\"sd[a-z]\", ATTR{queue/rotational}==\"0\", ATTR{queue/scheduler}=\"mq-deadline\"" > /etc/udev/rules.d/60-ioschedulers.rules

echo "Оптимизация завершена. Пожалуйста, перезагрузите систему и настройте автоматическое отключение дисплея в конфигурации Hyprland."
