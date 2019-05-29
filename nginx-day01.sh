#!/bin/bash
		#NSD Operation DAY01
#构建Nginx服务器
	tar -xf /root/lnmp_soft.tar.gz -C /root/
	yum -y install gcc pcre-devel openssl-devel &>/dev/null
	[ $? -eq 0 ] && echo "依赖包:gcc pcre-devel openssl-devel安装成功"
	useradd -s /sbin/nologin nginx
	tar -xf /root/lnmp_soft/nginx-1.10.3.tar.gz -C /root/
	cd /root/nginx-1.10.3/
./configure --prefix=/usr/local/nginx --user=nginx --group=nginx --with-http_ssl_module    #指定安装路径/指定用户/指定组/开启SSL加密功能
	make && make install   #编译并安装
	/usr/local/nginx/sbin/nginx    #启动服务
	[ $? -eq 0 ] && echo 'nginx服务已启动'
	/usr/local/nginx/sbin/nginx -V   #查看软件信息
	#设置防火墙与SELinux（非必须的操作，如果有则关闭）
	systemctl stop firewalld   
	setenforce 0   
#用户认证 修改Nginx配置文件 /usr/local/nginx/conf/nginx.conf
	sed -i '37aauth_basic "Input Password:";\n\tauth_basic_user_file "/usr/local/nginx/pass";' /usr/local/nginx/conf/nginx.conf
	yum -y install httpd-tools
	#创建密码文件
	htpasswd -c /usr/local/nginx/pass tom 
	# 追加用户，不使用-c选项
	htpasswd /usr/local/nginx/pass jerry
	#重新加载配置文件
	/usr/local/nginx/sbin/nginx -s reload
	#登录192.168.4.10客户端主机进行测试 firefox http://192.168.4.5                    //输入密码后可以访问
#基于域名的虚拟主机
	#修改Nginx服务配置
	#指定域名www.a.com
	sed -i '37s/localhost;/www.a.com;/' /usr/local/nginx/conf/nginx.conf
	sed -i '86,95s/#//' /usr/local/nginx/conf/nginx.conf
	#指定端口
	sed  -i '87s/8000/80/' /usr/local/nginx/conf/nginx.conf
	sed  -i '88s/^/#/' /usr/local/nginx/conf/nginx.conf
	#指定域名www.b.com
	sed -i '89s/somename.*/www.b.com;/' /usr/local/nginx/conf/nginx.conf
	#指定网站根路径
	sed -i '92s/html/www/' /usr/local/nginx/conf/nginx.conf
	#创建网站根目录及对应首页文件
	mkdir /usr/local/nginx/www
	echo "www" > /usr/local/nginx/www/index.html
	/usr/local/nginx/sbin/nginx -s reload
	#修改客户端主机192.168.4.10的/etc/hosts文件，进行域名解析 登录192.168.4.10客户端主机进行测试  firefox http://www.a.com            //输入密码后可以访问  firefox http://www.b.com            //直接访问
#SSL虚拟主机
	#生成私钥
	openssl genrsa > /usr/local/nginx/conf/cert.key
	#生成证书
	 openssl req -new -x509 -key /usr/local/nginx/conf/cert.key > /usr/local/nginx/conf/cert.pem
	sed -i '100,117s/#//' /usr/local/nginx/conf/nginx.conf
	sed -i '102s/localhost/www.c.com/' /usr/local/nginx/conf/nginx.conf
	/usr/local/nginx/sbin/nginx -s reload
	#修改客户端主机192.168.4.10的/etc/hosts文件，进行域名解析  firefox https://www.c.com            //信任证书后可以访问
