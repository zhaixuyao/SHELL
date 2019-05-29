#!/bin/bash
SUM=0
while :
do 
read  -p  "请输入整数（0表示结束）："  x
    [ $x -eq 0 ]  &&  break
    SUM=$[SUM+x]
done
echo "总和是：$SUM"
