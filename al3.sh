#!/bin/bash
uptime | awk '{print "1.cpu负载\n1min\t5min\t15min","\n"$8,"\t"$9,"\t"$10}'
ifconfig eth0 | awk '/RX p/{print "2.网卡流量:\t",$5/1024/1024,"mib"}'
free | awk '/Mem/{print "3.内存信息Men:\t",$4}'
df -h | awk 'BEGIN{print "4.磁盘信息:"}/文件/,/\/$/{print "\n",$1,"\t"$4}' | column -t
wc -l /etc/passwd | awk '{print "5.计算机账户数量:\t",$1}'
who | wc -l | awk '{print "6.登录账户数量:\t",$1}'
rpm -qa | wc -l | awk '{print"7.已安装软件包数量:\t",$1}'
ps aux | awk 'END{print "当前开启的进程数:\t" NR}'
