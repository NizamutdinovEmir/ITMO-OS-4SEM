#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Error: name file"
    exit 1
fi

file_to_restore="$1"
trash_dir="$HOME/.trash"
log_file="$HOME/trash.log"

if [ ! -d "$trash_dir" ]; then
    echo "Error: $trash_dir not exists"
    exit 1
fi

if [ ! -f "$log_file" ]; then
    echo "Error: $log_file not exitsts"
    exit 1
fi

matches=()
while IFS= read -r line; do
    original_path=$(echo "$line" | awk '{print $1}')
    link_name=$(echo "$line" | awk '{print $2}')
    filename=$(basename "$original_path")
    
    if [ "$filename" = "$file_to_restore" ]; then
        matches+=("$original_path $link_name")
    fi
done < "$log_file"

if [ ${#matches[@]} -eq 0 ]; then
    echo "File '$file_to_restore' not exists in trash"
    exit 0
fi

for match in "${matches[@]}"; do
    original_path=$(echo "$match" | awk '{print $1}')
    link_name=$(echo "$match" | awk '{print $2}')
    
    echo "Find file: $original_path"
    read -p "Return (y/n): " answer
    
    if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
        target_dir=$(dirname "$original_path")
        if [ ! -d "$target_dir" ]; then
            echo "Directory not exists, file will be return in base path"
            target_dir="$HOME"
            original_path="$target_dir/$(basename "$original_path")"
        fi
        
        if [ -e "$original_path" ]; then
            read -p "File '$original_path' already exists. New name: " new_name
            original_path="$target_dir/$new_name"
        fi
        
        if ln "$trash_dir/$link_name" "$original_path"; then
            rm "$trash_dir/$link_name"
            sed -i "/$link_name$/d" "$log_file"
            echo "Success: '$original_path'"
        else
            echo "Error: can't return file"
        fi
    fi
done