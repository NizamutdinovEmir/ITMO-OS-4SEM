#!/bin/bash

processor_pid=$(cat .pid)

echo "write commands:"
echo "  + (USR1)"
echo "  * (USR2)"
echo "  TERM - exit"

while read -r input; do
    case "$input" in
        "+")
            kill -USR1 "$processor_pid"
            ;;
        "*")
            kill -USR2 "$processor_pid"
            ;;
        "TERM")
            kill -TERM "$processor_pid"
            echo "finish"
            rm -f .pid
            exit 0
            ;;
        *)
            echo "incorrent comand: $input"
            continue
            ;;
    esac
done