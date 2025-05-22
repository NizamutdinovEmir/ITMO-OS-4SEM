#!/bin/bash

pipe=/tmp/dir_pipe

[ -p "$pipe" ] || mkfifo "$pipe"

show_files() {
    if [ -s files.log ]; then
        echo "new files"
        cat files.log
        > files.log
    else
        echo "nothing"
    fi
}

> files.log

while true; do
    show_files
    sleep 10
done &

while true; do
    read -p "name directory: " dirname
    if [ "$dirname" = "exit" ]; then
        break
    fi
    echo "$dirname" > "$pipe"
done

pkill -P $$
rm -f "$pipe"
rm -f files.log
echo "finish"