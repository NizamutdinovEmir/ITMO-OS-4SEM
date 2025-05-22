#!/bin/bash

echo $$ > .pid

value=1
mode="add"

trap 'mode="add"; echo "mode +' USR1
trap 'mode="multiply"; echo "mode *"' USR2
trap 'echo "TERM"; exit' TERM

echo "start (PID: $$). value: $value"

while true; do
    case $mode in
        "add")
            value=$((value + 2))
            ;;
        "multiply")
            value=$((value * 2))
            ;;
    esac
    
    echo "current value: $value"
    sleep 1
done