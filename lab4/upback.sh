#!/bin/bash

restore_dir="$HOME/restore"
backup_root="$HOME"

if [ ! -d "$restore_dir" ]; then
    mkdir "$restore_dir" || {
        echo "Error: can't create directory $restore_dir"
        exit 1
    }
fi

latest_backup=$(find "$backup_root" -maxdepth 1 -type d -name "Backup-*" | sort -r | head -n 1)

if [ -z "$latest_backup" ]; then
    echo "Error: not find directory with backup"
    exit 1
fi

while IFS= read -r -d '' file; do
    filename=$(basename "$file")
    
    if [[ "$filename" =~ \.[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        continue
    fi
    
    cp "$file" "$restore_dir/$filename"
done < <(find "$latest_backup" -type f -print0)

echo "Files have been restored $latest_backup to $restore_dir"