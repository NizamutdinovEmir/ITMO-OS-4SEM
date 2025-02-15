#!/bin/bash

cut -d: -f1,3 /etc/passwd | sort -t: -k2 -n
