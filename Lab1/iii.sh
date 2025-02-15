#!/bin/bash

while true; do
	echo "choise"
	read input
	if [[ "$input" = "1" ]]; then
		nano

	elif [[ "$input" = "2" ]]; then
		vi

	elif [[ "$input" = "3" ]]; then
		links

	else
		echo "exit"
		break
	fi
done
