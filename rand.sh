#!/bin/bash
x=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
#所有密码的可能性是26+26+10=62（0-61是62个数字）
pass=''
for i in {1..8}
do
num=$[RANDOM%62]
tmp=${x:num:1}
pass=${pass}$tmp
done
echo $pass
