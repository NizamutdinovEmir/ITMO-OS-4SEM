#!/bin/bash

./loop.sh & pid0=$!
./loop.sh & pid1=$!
./loop.sh & pid2=$!

echo "Processes: $pid0, $pid1, $pid2"

cpulimit -p $pid0 -l 10 -b >/dev/null 2>&1

sleep 3

if kill $pid2 2>/dev/null; then
    echo "3rd process was killed ($pid2)"
else
    echo "3rd process ($pid2) already terminated"
fi

echo -e "\nCurrent CPU usage:"
ps -o pid,%cpu,comm -p $pid0,$pid1 | grep -E "PID|loop.sh"

while true; do
    sleep 60
done