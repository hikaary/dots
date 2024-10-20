#!/bin/bash

# Проверка на root права
if [ "$EUID" -ne 0 ]; then
  echo "Пожалуйста, запустите скрипт с правами root"
  exit
fi

# Установка необходимых пакетов
pacman -S --noconfirm tlp tlp-dinit cpupower cpupower-dinit thermald thermald-dinit acpi

# Настройка TLP
dinitctl enable tlp

# Настройка cpupower
echo "governor='ondemand'" >/etc/default/cpupower
dinitctl enable cpupower

# Настройка термальной оптимизации
dinitctl enable thermald

# Оптимизация I/O планировщика для SSD
echo "ACTION==\"add|change\", KERNEL==\"sd[a-z]\", ATTR{queue/rotational}==\"0\", ATTR{queue/scheduler}=\"mq-deadline\"" >/etc/udev/rules.d/60-ioschedulers.rules

# Функция для настройки производительности при работе от сети
set_performance() {
  cpupower frequency-set -g performance
  echo "CPU governor set to performance mode"
  tlp ac
  echo "TLP set to AC mode"
}

# Функция для настройки энергосбережения при работе от батареи
set_powersave() {
  cpupower frequency-set -g powersave
  echo "CPU governor set to powersave mode"
  tlp bat
  echo "TLP set to battery mode"
  # Дополнительные оптимизации для режима батареи
  echo 1 >/sys/module/snd_hda_intel/parameters/power_save
  echo '1500' >/proc/sys/vm/dirty_writeback_centisecs
  echo 'auto' >/sys/bus/usb/devices/*/power/control
}

# Создание службы для автоматического переключения режимов
cat <<EOF >/etc/dinit.d/power-mode-switch
type = process
command = /usr/local/bin/power-mode-switch.sh
restart = false
depends-on = tlp
depends-on = cpupower
EOF

# Создание скрипта для автоматического переключения режимов
cat <<EOF >/usr/local/bin/power-mode-switch.sh
#!/bin/bash

while true; do
    if acpi -a | grep -q "on-line"; then
        set_performance
    else
        set_powersave
    fi
    sleep 60
done
EOF

chmod +x /usr/local/bin/power-mode-switch.sh

# Активация службы
dinitctl enable power-mode-switch

echo "Оптимизация завершена. Пожалуйста, перезагрузите систему."
echo "После перезагрузки система будет автоматически переключаться между режимами производительности и энергосбережения."
