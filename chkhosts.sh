#!/bin/bash
for i in {1..254}
do
    ping -c 3 -i 0.2 -W 1 192.168.4.$i &> /dev/null
    if [ $? -eq 0 ] ; then
        echo "Host 192.168.4.$i is up."
    else
        echo "Host 192.168.4.$i is down."
    fi
done
