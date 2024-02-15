#!/bin/bash

export XDG_RUNTIME_DIR="/run/user/$(id -u)"

# Функция для ожидания разблокировки экрана
waitForUnlock() {
    # Ожидаем 5 минут или разблокировки экрана
    local counter=0
    while pgrep swaylock > /dev/null; do
        sleep 1
        let counter+=1
        if [ "$counter" -ge 300 ]; then
            # Если прошло 5 минут и экран все еще заблокирован, отправляем компьютер в сон
            systemctl suspend
            break
        fi
    done
}

# Функция для запуска локскрина
lockAndMaybeSuspend() {
    swaylock &
    # Получаем PID процесса swaylock
    lockPid=$!

    # Ожидаем разблокировку или таймаут
    waitForUnlock

    # Если swaylock все еще работает (экран не разблокирован), отправляем компьютер в сон
    if pgrep -P $lockPid > /dev/null; then
        kill $lockPid
    fi
}

# Запускаем локскрин и возможный переход в сон
lockAndMaybeSuspend
