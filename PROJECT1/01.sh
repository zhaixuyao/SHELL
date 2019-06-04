#!/bin/bash
ssh-copy-id 192.168.2.11
scp ./PROJECT1/lnmp_soft.tar.gz ./PROJECT1/wordpress.zip root@192.168.2.11:
ssh 192.168.2.11
#步骤一：安装部署LNMP软件
#1）安装软件包
tar -xf lnmp_soft.tar.gz 
tar -xf lnmp_soft/nginx-1.12.2.tar.gz 
yum -y install gcc openssl-devel pcre-devel 
useradd -s /sbin/nologin  nginx
cd nginx-1.12.2
./configure   --user=nginx   --group=nginx --with-http_ssl_module --with-http_stub_status_module
make && make install
#2)启动服务(nginx、mariadb、php-fpm)
yum -y install php php-mysql php-fpm
ln -s /usr/local/nginx/sbin/nginx /sbin/
nginx
 echo "/usr/local/nginx/sbin/nginx" >> /etc/rc.local
chmod +x /etc/rc.local
ss -utnlp | grep :80  
systemctl start   mariadb                   #启动mariadb服务器
systemctl enable  mariadb  
systemctl start  php-fpm                   #启动php-fpm服务
systemctl enable php-fpm
#3）修改Nginx配置文件，实现动静分离
sed -i '45s/index/index  index.php/' /usr/local/nginx/conf/nginx.conf
ed -i '65,71s/#//' /usr/local/nginx/conf/nginx.conf
sed -i '69s/^/#/' /usr/local/nginx/conf/nginx.conf
sed -i '70s/_params/.conf/' /usr/local/nginx/conf/nginx.conf
nginx -s reload                                  #重新加载配置 
#4）配置数据库账户与权限

#为网站提前创建一个数据库、添加账户并设置该账户有数据库访问权限。
  mysql
   # MariaDB [(none)]> create database wordpress character set utf8mb4;
   # MariaDB [(none)]> grant all on wordpress.* to wordpress@'%' identified by 'wordpress';
   # MariaDB [(none)]> flush privileges;
   # MariaDB [(none)]> exit
#步骤二：上线wordpress代码

#1）上线PHP动态网站代码
yum -y install unzip
systenctl start unzip
systemctl enable unzip
unzip wordpress.zip
 cd wordpress
 nzip wordpress-5.0.3-zh_CN.tar.gz
rdpress/*  /usr/local/nginx/html/
chown -R apache.apache  /usr/local/nginx/html/

