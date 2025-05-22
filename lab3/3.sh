#!/bin/bash

current_day=$(date +%u)
echo "5 * * * $current_day $(pwd)/1.sh" | crontab