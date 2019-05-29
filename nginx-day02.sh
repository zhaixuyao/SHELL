#!bin/bash
#1 案例1：部署LNMP环境
	yum -y install mariadb mariadb-server mariadb-devel php php-mysql php-fpm &>/dev/null
	[ $? -eq 0 ] && echo '软件:mariadb mariadb-sserver mariadb-devel php php-mysql php-fpm安装成功'
	#启动服务  systemctl stop httpd                //如果该服务存在则关闭该服务
	systemctl restart mariadb
	systemctl enable mariadb	
	systemctl restart php-fpm
	systemctl enable php-fpm
#2 案例2：构建LNMP平台
	sed -i '67,73s/#//' /usr/local/nginx/conf/nginx.conf
	sed -i '71s/^/#/' /usr/local/nginx/conf/nginx.conf
	sed -i '72s/_params/.conf/' /usr/local/nginx/conf/nginx.conf
	/usr/local/nginx/sbin/nginx -s reload
		echo -e '<?php\n$i="This is a Page";\necho $i;\n?>' > /usr/local/nginx/html/test.php
	cp /root/lnmp_soft/php_scripts/mysql.php  /usr/local/nginx/html/
	[ $? -eq 0 ] && echo 'LNMP平台构建成功'
#客户端使用浏览器访问服务器PHP首页文档，检验是否成功：firefox http://192.168.4.5/test.php  firefox http://192.168.4.5/mysql.php
#LNMP常见问题

#Nginx的默认访问日志文件为/usr/local/nginx/logs/access.log

#Nginx的默认错误日志文件为/usr/local/nginx/logs/error.log

#PHP默认错误日志文件为/var/log/php-fpm/www-error.log

#如果动态网站访问失败，可用参考错误日志，查找错误信息。
