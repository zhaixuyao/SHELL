#!/bin/bash
i=1
while [ $i -le 254 ]
do
    IP="192.168.4.$i"
    ping -c 3 -i 0.2 -W 1 $IP &> /dev/null
    if [ $? -eq 0 ] ; then
        echo "Host $IP is up."
    else
        echo "Host $IP is down."
    fi
    let i++
done
