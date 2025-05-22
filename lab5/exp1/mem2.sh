#!/bin/bash

> report2.log

array=()
counter=0

while true; do
    array+=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")
    ((counter++))

    if ((counter % 100000 == 0)); then
        echo "Size of the array: ${#array[@]}" >> report2.log
    fi
done