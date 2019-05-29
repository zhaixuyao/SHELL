#!/bin/bash
read -p "请输入要ping的IP:" s
	ping -c 3 -i 0.2 -W 1 $s &>/dev/null
	if [ $? -eq 0 ];then
	echo $s"通了"
fi
