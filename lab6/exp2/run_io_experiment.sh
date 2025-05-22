#!/bin/bash

OUTPUT_FILE=$1
SCRIPT_TO_RUN=$2

rm -f $OUTPUT_FILE
touch $OUTPUT_FILE

for N in {1..20}; do
    for ((j=1; j<=10; j++)); do
        { time ./$SCRIPT_TO_RUN $N > /dev/null 2>&1 ; } 2>> $OUTPUT_FILE
    done
done