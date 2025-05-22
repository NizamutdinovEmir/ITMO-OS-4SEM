#!/bin/bash

pipe=/tmp/calc_pipe

if [[ ! -p $pipe ]]; then
    echo "error, not found pipe"
    exit 1
fi

echo "START commands:"
echo "  +"
echo "  *"
echo "  number"
echo "  QUIT"

while true; do
    read -p "> " input
    
    if [[ -z $input ]]; then
        continue
    fi
    
    echo "$input" > $pipe
    
    if [[ $input == "QUIT" ]]; then
        echo "finish"
        exit 0
    fi
done