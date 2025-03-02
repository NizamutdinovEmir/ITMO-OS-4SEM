#!/bin/bash

max_memory=0
max_pid=0

for pid in $(ls /proc | grep -E '^[0-9]+$'); do
    status="/proc/$pid/status"
    if [[ -f "$status" ]]; then
        memory=$(grep '^VmRSS:' "$status" | awk '{print $2}')

        if [[ -n "$memory" && "$memory" -gt "max_memory" ]]; then
            max_memory=$memory
            max_pid=$pid
        fi
    fi
done

if [[ "$max_pid " -gt 0 ]]; then
    echo "PID: $max_pid"
    echo "Memory: $max_memory"
else
    echo "error"
fi

top -b -n 1 -o RES | head -n 12 