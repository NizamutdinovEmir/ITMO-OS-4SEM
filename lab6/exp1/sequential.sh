#!/bin/bash

N=$1

for ((i=1; i<=$N; i++))
do
    ./fibonacci $((40 + i % 5)) > /dev/null
done