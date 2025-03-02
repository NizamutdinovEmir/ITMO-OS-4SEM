#!/bin/bash

commands=$(ps -u root -o pid= -o comm= | awk '{print $1" : "$2}')
count=$(echo "$commands" | wc -l)
echo "count = $count" > 1.out
echo "$commands" >> 1.out