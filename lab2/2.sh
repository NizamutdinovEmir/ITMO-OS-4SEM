#!/bin/bash

ps -e -o pid= -o comm= | grep '^/sbin/' | awk '{print $1}' > 2.out