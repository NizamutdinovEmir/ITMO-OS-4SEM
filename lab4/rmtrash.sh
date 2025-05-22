#!/bin/bash

if [ $# -ne 1 ]; then
    echo "error with arg" >&2
    exit 1
fi

file_to_remove="$1"

if [ ! -e "$file_to_remove" ]; then
    echo "Error: file '$file_to_remove' not exist" >&2
    exit 1
fi

trash_dir="$HOME/.trash"
if [ ! -d "$trash_dir" ]; then
    if ! mkdir "$trash_dir"; then
        echo "Error: can't create $trash_dir" >&2
        exit 1
    fi
    echo "Create: $trash_dir"
fi

link_name=$(date +%s)
while [ -e "$trash_dir/$link_name" ]; do
    link_name=$((link_name + 1))
done

if ! ln "$file_to_remove" "$trash_dir/$link_name"; then
    echo "Can't create" >&2
    exit 1
fi

if ! rm "$file_to_remove"; then
    echo "Error: can't delete file" >&2
    rm "$trash_dir/$link_name"
    exit 1
fi

log_file="$HOME/trash.log"
echo "$(realpath "$file_to_remove") $link_name" >> "$log_file"

echo "File '$file_to_remove' move to trash - $link_name"