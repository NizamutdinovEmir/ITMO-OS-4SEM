#!/bin/bash

ps -e -o pid,etimes,comm= | sort -n -k2 | awk 'NR==1 {print $1}'