#!/bin/bash

curppid=0
avgsum=0
avg=0
cnt=0

while read -r line; do
    cleaned_line=$(echo "$line" | sed "s/[^0-9.]\+/ /g" | sed "s/^ //g")
    pid=$(awk '{print $1}' <<< "$cleaned_line")
    ppid=$(awk '{print $2}' <<< "$cleaned_line")
    art=$(awk '{print $3}' <<< "$cleaned_line")

    if [[ $ppid != $curppid ]]; then
        if [[ $cnt -gt 0 ]]; then
            avg=$(echo "scale=2; $avgsum/$cnt" | bc | awk '{printf "%.2f", $0}')
            echo "Average_Children_Running_Time_Of_ParentID=$curppid is $avg" >> 5.out
        fi
        curppid=$ppid
        avgsum=$art
        cnt=1
    else
        avgsum=$(echo "$avgsum+$art" | bc | awk '{printf "%.2f", $0}')
        cnt=$((cnt+1))
    fi

    if [[ -n $pid ]]; then
        echo "ProcessID=$pid : Parent_ProcessID=$ppid : Average_Running_Time=$art" >> 5.out
    fi
done < 4.out

if [[ $cnt -gt 0 ]]; then
    avg=$(echo "scale=2; $avgsum/$cnt" | bc | awk '{printf "%.2f", $0}')
    echo "Average_Children_Running_Time_Of_ParentID=$curppid is $avg" >> 5.out
fi