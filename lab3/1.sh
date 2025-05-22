#!/bin/bash

dates=$(date '+%F_%T')

mkdir ~/test && {
    echo "catalog test was created successfully" > ~/report
    touch ~/test/"$dates"
}

ping www.net_nikogo.ru 2>/dev/null || echo "${dates} ERROR HOST" >> ~/report