#!/bin/bash

# Проверка аргументов
if [ "$#" -ne 1 ]; then
	echo "Usage: $0 <new_position>"
	exit 1
fi

NEW_POSITION=$1
CURRENT_WINDOW=$(tmux display-message -p '#I')

# Проверка, используется ли новая позиция
if tmux list-windows -F '#I' | grep -q "^${NEW_POSITION}$"; then
	# Найти первый свободный индекс, начиная с 100 (или любого большого числа, которое не занято)
	TEMP_INDEX=100
	while tmux list-windows -F '#I' | grep -q "^${TEMP_INDEX}$"; do
		TEMP_INDEX=$((TEMP_INDEX + 1))
	done

	# Переместить текущее окно на временный индекс
	tmux move-window -s ${CURRENT_WINDOW} -t ${TEMP_INDEX}

	# Перемещаем все окна, чтобы освободить новую позицию
	if [ ${NEW_POSITION} -lt ${CURRENT_WINDOW} ]; then
		# Перемещение окон вниз
		for ((i = ${CURRENT_WINDOW} - 1; i >= ${NEW_POSITION}; i--)); do
			tmux move-window -s $i -t $((i + 1))
		done
	else
		# Перемещение окон вверх
		for ((i = ${CURRENT_WINDOW} + 1; i <= ${NEW_POSITION}; i++)); do
			tmux move-window -s $i -t $((i - 1))
		done
	fi

	# Переместить временное окно на новую позицию
	tmux move-window -s ${TEMP_INDEX} -t ${NEW_POSITION}
else
	# Если новая позиция не занята, просто переместить текущее окно на новую позицию
	tmux move-window -s ${CURRENT_WINDOW} -t ${NEW_POSITION}
fi
