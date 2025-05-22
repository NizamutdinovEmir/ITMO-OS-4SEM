#!/bin/bash

N=$1 
array=()

while [ ${#array[@]} -le $N ]; do
    array+=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")
done

echo "All good. Size of the array: ${#array[@]}"