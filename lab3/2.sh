#!/bin/bash

( sleep 120 ; ./1.sh ) &> /dev/null &

tail -n 0 -f ~/report