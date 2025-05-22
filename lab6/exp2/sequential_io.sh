#!/bin/bash

N=$1

for ((i=1; i<=$N; i++)); do
    ./file_processor "file_$i.dat" > /dev/null
done