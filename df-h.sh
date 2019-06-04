#!/bin/bash
for i in 41 42 43
do
	ssh 192.168.2.$i "LANG=en growpart /dev/vda 1 ;lsblk;blkid /dev/vda1;xfs_growfs /dev/vda1;df -h"
done
