#!/bin/bash
read -p "请输入用户名:"  username              #读取用户名
stty -echo                                  #关闭回显
read -p "请输入密码:"  passwd              #读取密码
stty echo                                  #恢复回显
echo ""                                      #恢复回显后补一个空行
useradd "$username"
echo "$passwd" | passwd --stdin "$username"
