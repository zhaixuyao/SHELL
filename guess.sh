#!/bin/bash
num=$[RANDOM%100+1]
i=0
while :
do
   read -p "随机数1-100,你猜:" guess
   let i++                                 #猜一次，计数器加1，统计猜的次数
   if [ $guess -eq $num ];then
        echo "恭喜，猜对了"
        echo "你猜了$i次"
        exit
   elif [ $guess -gt $num ];then
        echo "猜大了"
   else 
        echo "猜小了"
   fi 
