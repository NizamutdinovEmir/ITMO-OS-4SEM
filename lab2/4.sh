#!/bin/bash

tempfile=$(mktemp)

for pid in $(ls /proc | grep -E '^[0-9]+$'); do
    status="/proc/$pid/status"
    sched="/proc/$pid/sched"

    if [[ -f "$status" && -f "$sched" ]]; then
        ppid=$(grep '^PPid:' "$status" | awk '{print $2}')

        sum_exec_runtime=$(grep '^se.sum_exec_runtime' "$sched" | awk '{print $3}')
        nr_switches=$(grep '^nr_switches' "$sched" | awk '{print $3}')

        if [[ "$nr_switches" -gt 0 ]]; then
            art=$(echo "scale=2; $sum_exec_runtime / $nr_switches" | bc)
        else
            art=0
        fi

        echo "ProcessID=$pid : Parent_ProcessID=$ppid : Average_Running_Time=$art" >> "$tempfile"
    fi
done

sort -t "=" -k 4 -n "$tempfile" > 4.out

rm "$tempfile"

