#!/bin/bash

export XDG_RUNTIME_DIR="/run/user/$(id -u)"

# Функция для ожидания разблокировки экрана
waitForUnlock() {
    while pgrep swaylock > /dev/null; do sleep 1; done
}

# Функция для перевода в режим сна и гибернацию
sleepAndHibernate() {
    swaylock 
}


# Запуск функции sleepAndHibernate в фоне
sleepAndHibernate &

# Получение ID фонового процесса
sleepPid=$!

# Ожидание разблокировки экрана
waitForUnlock

# Убийство фонового процесса после разблокировки
kill $sleepPid

