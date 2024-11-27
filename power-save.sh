#!/bin/bash

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Функция для логирования
log() {
  echo -e "${GREEN}[+]${NC} $1"
}

error() {
  echo -e "${RED}[!]${NC} $1"
}

warning() {
  echo -e "${YELLOW}[*]${NC} $1"
}

# Проверка на root права
if [ "$EUID" -ne 0 ]; then
  error "Пожалуйста, запустите скрипт с правами root"
  exit 1
fi

# Функция для проверки и установки пакетов
install_packages() {
  local packages=(
    "acpi"      # ACPI утилиты
    "acpi_call" # Дополнительные ACPI функции
    "powertop"  # Анализ энергопотребления
    "thermald"  # Термальный контроль
    "cpupower"  # Управление CPU
  )

  log "Установка необходимых пакетов..."
  pacman -Sy --needed --noconfirm "${packages[@]}"
  log "Установка auto-cpufreq из AUR..."
  paru -S --noconfirm auto-cpufreq
}

# Настройка параметров системы
configure_system() {
  log "Настройка параметров системы..."

  # Настройка VM
  cat >/etc/sysctl.d/99-sysctl-performance.conf <<EOF
# Оптимизация VM
vm.swappiness = 10
vm.vfs_cache_pressure = 50
vm.dirty_ratio = 10
vm.dirty_background_ratio = 5
vm.dirty_writeback_centisecs = 1500

# Оптимизация сети
net.core.netdev_max_backlog = 16384
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 2000000
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_mtu_probing = 1

# Оптимизация файловой системы
fs.inotify.max_user_watches = 524288
EOF

  # Настройка CPU
  cat >/etc/default/cpupower <<EOF
governor='ondemand'
min_freq="800MHz"
max_freq="auto"
EOF

  # Настройка планировщика IO для SSD/NVME
  cat >/etc/udev/rules.d/60-ioschedulers.rules <<EOF
# SSD и NVMe
ACTION=="add|change", KERNEL=="sd[a-z]|nvme[0-9]n[0-9]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"
# HDD
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
EOF
}

# Настройка автоматического переключения режимов
setup_power_switching() {
  log "Настройка автоматического переключения режимов питания..."

  cat >/usr/local/bin/power-mode-switch.sh <<EOF
#!/bin/bash

# Функция для настройки производительности
set_performance() {
    cpupower frequency-set -g performance
    if systemctl is-active auto-cpufreq > /dev/null; then
        auto-cpufreq --force=performance
    fi
    powertop --auto-tune
    echo performance > /sys/devices/system/cpu/cpufreq/policy*/scaling_governor
    echo 0 > /sys/module/snd_hda_intel/parameters/power_save
    echo 1000 > /proc/sys/vm/dirty_writeback_centisecs

    # AMD GPU специфичные настройки
    if [ -d "/sys/class/drm/card0/device/power_dpm_force_performance_level" ]; then
        echo high > /sys/class/drm/card0/device/power_dpm_force_performance_level
    fi
}

# Функция для настройки энергосбережения
set_powersave() {
    cpupower frequency-set -g powersave
    if systemctl is-active auto-cpufreq > /dev/null; then
        auto-cpufreq --force=powersave
    fi
    powertop --auto-tune
    echo powersave > /sys/devices/system/cpu/cpufreq/policy*/scaling_governor
    echo 1 > /sys/module/snd_hda_intel/parameters/power_save
    echo 1500 > /proc/sys/vm/dirty_writeback_centisecs

    # AMD GPU специфичные настройки
    if [ -d "/sys/class/drm/card0/device/power_dpm_force_performance_level" ]; then
        echo auto > /sys/class/drm/card0/device/power_dpm_force_performance_level
    fi
}

# Основной цикл
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

  # Создание systemd службы
  cat >/etc/systemd/system/power-mode-switch.service <<EOF
[Unit]
Description=Automatic Power Mode Switching
After=multi-user.target

[Service]
Type=simple
ExecStart=/usr/local/bin/power-mode-switch.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF
}

# Активация служб
enable_services() {
  log "Активация служб..."

  # Загрузка необходимых модулей ядра
  log "Загрузка модулей ядра..."
  modprobe acpi_cpufreq
  modprobe cpufreq_ondemand

  # Проверка доступных governors
  available_governors=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors)
  log "Доступные governors: $available_governors"

  # Выбор подходящего governor
  if echo "$available_governors" | grep -q "ondemand"; then
    chosen_governor="ondemand"
  elif echo "$available_governors" | grep -q "schedutil"; then
    chosen_governor="schedutil"
  else
    chosen_governor="performance"
  fi

  log "Выбран governor: $chosen_governor"

  # Настройка CPUpower
  log "Настройка CPUpower..."
  cat >/etc/default/cpupower <<EOF
# Define CPUpower governor
governor='$chosen_governor'
# Limit frequency range
min_freq="800MHz"
max_freq="auto"
# Optional extra settings
freq_governor="$chosen_governor"
EOF

  # Применение настроек для каждого ядра CPU
  for cpu in /sys/devices/system/cpu/cpu[0-9]*; do
    if [ -f "$cpu/cpufreq/scaling_governor" ]; then
      echo "$chosen_governor" >"$cpu/cpufreq/scaling_governor" 2>/dev/null ||
        warning "Не удалось установить governor для $(basename $cpu)"
    fi
  done

  # Добавление модулей в автозагрузку
  cat >/etc/modules-load.d/cpupower.conf <<EOF
acpi_cpufreq
cpufreq_$chosen_governor
EOF

  # Перезагрузка модулей
  systemctl restart systemd-modules-load.service

  # Включаем службы по очереди
  systemctl enable cpupower.service
  systemctl start cpupower.service || warning "Не удалось запустить cpupower.service, проверьте journalctl -xe"

  # Включаем и запускаем thermald
  systemctl enable thermald.service
  systemctl start thermald.service || warning "Не удалось запустить thermald.service"

  # Если установлен auto-cpufreq, включаем его
  if systemctl list-unit-files | grep -q auto-cpufreq; then
    systemctl enable auto-cpufreq.service
    systemctl start auto-cpufreq.service || warning "Не удалось запустить auto-cpufreq.service"
  fi

  # Включаем наш сервис переключения режимов
  systemctl enable power-mode-switch.service
  systemctl start power-mode-switch.service || warning "Не удалось запустить power-mode-switch.service"

  # Проверяем статус служб
  log "Статус служб:"
  for service in cpupower thermald auto-cpufreq power-mode-switch; do
    if systemctl is-enabled $service.service &>/dev/null; then
      status=$(systemctl is-active $service.service)
      if [ "$status" = "active" ]; then
        log "✓ $service.service активен"
      else
        warning "⚠ $service.service не активен (статус: $status)"
        log "Подробности ошибки $service.service:"
        journalctl -u $service.service -n 5
      fi
    fi
  done
}

# Основная функция
main() {
  log "Начало оптимизации системы..."

  install_packages
  configure_system
  setup_power_switching
  enable_services

  # Применение изменений
  systemctl daemon-reload

  log "Оптимизация завершена успешно!"
  warning "Пожалуйста, перезагрузите систему для применения всех изменений."
  warning "После перезагрузки система будет автоматически оптимизировать производительность и энергопотребление."
}

# Запуск основной функции
main
