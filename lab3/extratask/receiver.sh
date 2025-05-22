#!/bin/bash

pipe=/tmp/dir_pipe
logfile=/tmp/files.log

[ -p "$pipe" ] || { echo "No channel. First - sender.sh"; exit 1; }

while read dirname < "$pipe"; do
    mkdir -p "$dirname"
    echo "Create: $dirname"
    
    find "$dirname" -type f -o -type d | while read -r item; do
        echo "$item" >> "$logfile"
    done
done