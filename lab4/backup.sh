#!/bin/bash

source_dir="$HOME/source"
backup_root="$HOME"
backup_report="$backup_root/backup-report"

if [ ! -d "$source_dir" ]; then
    echo "Error: $source_dir not exists"
    exit 1
fi


current_date=$(date +%Y-%m-%d)

# Search last backup
latest_backup=$(find "$backup_root" -maxdepth 1 -type d -name "Backup-*" | sort -r | head -n 1)

create_new_backup=true
if [ -n "$latest_backup" ]; then
    backup_date=$(basename "$latest_backup" | cut -d'-' -f2-)
    backup_timestamp=$(date -d "$backup_date" +%s)
    current_timestamp=$(date -d "$current_date" +%s)
    days_diff=$(( (current_timestamp - backup_timestamp) / 86400 ))
    
    if [ $days_diff -lt 7 ]; then
        create_new_backup=false
    fi
fi

if [ "$create_new_backup" = true ]; then
    backup_dir="$backup_root/Backup-$current_date"
    mkdir "$backup_dir" || {
        echo "Error: can't create $backup_dir"
        exit 1
    }
    
    cp -r "$source_dir/." "$backup_dir/"
    
    # Backup report
    {
        echo "[$current_date] Create new backup directory: $backup_dir"
        echo "Copy:"
        find "$source_dir" -type f -exec basename {} \;
    } >> "$backup_report"
    
    echo "Create: $backup_dir"
else
    backup_dir="$latest_backup"
    updated_files=()
    renamed_files=()
    
    while IFS= read -r -d '' file; do
        filename=$(basename "$file")
        backup_file="$backup_dir/$filename"
        
        if [ ! -e "$backup_file" ]; then
            # File not exists in backup
            cp "$file" "$backup_file"
            updated_files+=("$filename")
        else
            # Exists: check sizes
            source_size=$(stat -c%s "$file")
            backup_size=$(stat -c%s "$backup_file")
            
            if [ "$source_size" -ne "$backup_size" ]; then
                new_name="${backup_file}.${current_date}"
                mv "$backup_file" "$new_name"
                cp "$file" "$backup_file"
                updated_files+=("$filename")
                renamed_files+=("$filename $(basename "$new_name")")
            fi
        fi
    done < <(find "$source_dir" -type f -print0)
    
    if [ ${#updated_files[@]} -gt 0 ] || [ ${#renamed_files[@]} -gt 0 ]; then
        {
            echo "[$current_date] Update: $backup_dir"
            echo "New files:"
            printf "%s\n" "${updated_files[@]}"
            echo "Rename files:"
            printf "%s\n" "${renamed_files[@]}"
        } >> "$backup_report"
    fi
    
    echo "Backup $backup_dir"
fi