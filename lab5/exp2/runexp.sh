#!/bin/bash

N=5400000
K=30

for ((i=1; i<=K; i++)); do
    ./newmem.sh $N &
    sleep 1
done

wait
echo "All proccesses have done"