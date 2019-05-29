#!/bin/bash
c=$[RANDOM%61]
read -p "中午吃啥?" 
if [ $c -ge 50 ];then
    echo "中午吃户县软面"
elif [ $c -ge 40 ];then
    echo " 中午吃俺娘面"
elif [ $c -ge 30 ];then
    echo "中午喝米汤"
elif [ $c -ge 20 ];then
    echo "中午吃砂锅"
else
    echo "中午吃肉夹馍"
fi

