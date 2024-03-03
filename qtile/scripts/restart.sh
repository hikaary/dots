#!/bin/bash

# Завершаем текущую сессию qtile
qtile cmd-obj -o cmd -f shutdown

# Запускаем qtile заново
qtile start
