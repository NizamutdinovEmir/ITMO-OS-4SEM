#!/bin/bash

# Проверяем, запущен ли скрипт с правами root
if [[ $EUID -ne 0 ]]; then
    echo "Этот скрипт должен быть запущен с правами root. Используйте sudo."
    exit 1
fi

declare -A start_bytes

# Получаем список всех процессов
pids=$(ls /proc | grep -E '^[0-9]+$')

# Записываем начальные значения прочитанных байт
for pid in $pids; do
    io_file="/proc/$pid/io"
    if [[ -r "$io_file" ]]; then
        start_bytes[$pid]=$(grep '^read_bytes:' "$io_file" | awk '{print $2}')
        if [[ -z "${start_bytes[$pid]}" ]]; then
            start_bytes[$pid]=0
        fi
    else
        start_bytes[$pid]=0
    fi
done

echo "1 min..."

# Ждем 1 минуту
sleep 60

declare -A end_bytes

# Записываем конечные значения прочитанных байт
for pid in $pids; do
    io_file="/proc/$pid/io"
    if [[ -r "$io_file" ]]; then
        end_bytes[$pid]=$(grep '^read_bytes:' "$io_file" | awk '{print $2}')
        if [[ -z "${end_bytes[$pid]}" ]]; then
            end_bytes[$pid]=0
        fi
    else
        end_bytes[$pid]=0
    fi
done

declare -A diff_bytes

# Вычисляем разницу и сохраняем результаты
for pid in "${!start_bytes[@]}"; do
    diff=$((end_bytes[$pid] - start_bytes[$pid]))
    if [[ $diff -gt 0 ]]; then
        diff_bytes[$pid]=$diff
    fi
done

# Сортируем процессы по объему прочитанных данных
sorted_pids=$(for pid in "${!diff_bytes[@]}"; do
    echo "$pid:${diff_bytes[$pid]}"
done | sort -t ":" -k2 -nr | head -n 3)

echo "first 3"

# Выводим результаты
for entry in $sorted_pids; do
    pid=$(echo "$entry" | cut -d ':' -f1)
    bytes=$(echo "$entry" | cut -d ':' -f2)
    if [[ -r "/proc/$pid/cmdline" ]]; then
        cmdline=$(tr '\0' ' ' < "/proc/$pid/cmdline")
    else
        cmdline="N/A"
    fi
    echo "$pid:$cmdline:$bytes"
done