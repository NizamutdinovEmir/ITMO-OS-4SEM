#!/bin/bash

pipe=/tmp/calc_pipe
mode="+"
result=1

trap "echo 'finish'; rm -f $pipe; exit" SIGINT SIGTERM

echo "start - mode +"

while true; do
    read input < $pipe
    
    case $input in
        "+")
            mode="+"
            echo "mode +"
            ;;
        "*")
            mode="*"
            echo "mode *"
            ;;
        [0-9]*)
            if [[ $mode == "+" ]]; then
                result=$((result + input))
            else
                result=$((result * input))
            fi
            echo "current result: $result"
            ;;
        "QUIT")
            echo "stop, result:  $result"
            rm -f $pipe
            exit 0
            ;;
        *)
            echo "error, incorrect input '$input'"
            rm -f $pipe
            exit 1
            ;;
    esac
done