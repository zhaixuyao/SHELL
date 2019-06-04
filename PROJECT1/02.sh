#!/bin/bash
for i in 5 11 12 13 21 31; 
do
 ssh-copy-id 192.168.2.$i; 
done
#步骤一：部署数据库服务器

#1）准备一台独立的服务器，安装数据库软件包
ssh root@192.168.2.21 "yum -y install mariadb mariadb-server mariadb-devel;
 systemctl start mariadb ;
systemctl enable mariadb;
exit;"
#2)将之前单机版LNMP网站中的数据库迁移到新的数据库服务器。

#登陆192.168.2.11主机，备份数据库并拷贝给新的服务器，关闭旧的数据库服务。
ssh root@192.168.2.11 "mysqldump wordpress > wordpress.bak ;
scp wordpress.bak 192.168.2.21:/root/ ;
systemctl stop mariadb ;
systemctl disable mariadb ;
exit;"
#登陆192.168.2.21主机，使用备份文件还原数据库。
#创建空数据库：
   # MariaDB [(none)]> create database wordpress character set utf8mb4;
   # MariaDB [(none)]> exit
#使用备份文件还原数据：
#重新创建账户并授权访问：
   # MariaDB [(none)]> grant all on wordpress.* to wordpress@'%' identified by 'wordpress';
   # MariaDB [(none)]> flush privileges;
   # MariaDB [(none)]> exit

ssh 192.168.2.21 "mysql ;
 mysql wordpress < wordpress.bak ;
   mysql;
exit;"
#3）修改wordpress网站配置文件，调用新的数据库服务器。

#Wordpress在第一次初始化操作时会自动生产配置文件：wp-config.php，登陆192.168.2.11修改该文件即可调用新的数据库服务。
ssh 192.168.2.11 "sed -i '35c define('DB_HOST', '192.168.2.21');'  /usr/local/nginx/html/wp-config.php ;
exit;"
#Web服务器集群
#步骤一：部署web2和web3服务器
for i in 12 13
do
ssh-copy-id 192.168.2.$i
scp ./linux-soft/02/lnmp_soft.tar.gz  root@192.168.2.$i:
done
for i in 12 13
 do
 ssh 192.168.2.$i "tar -xf lnmp_soft.tar.gz   ; tar -xf lnmp_soft/nginx-1.12.2.tar.gz  ; yum -y install gcc pcre-devel openssl-devel ; cd nginx-1.12.2 ;useradd -s /sbin/nologin nginx ; ./configure --user=nginx --group=nginx --with-http_ssl_module --with-http_stub_status_module ; make && make install ; yum -y install php php-fpm php-mysql mariadb-devel ;"
 done
#2）修改nginx配置实现动静分离（web2和web3操作）

#web2修改默认首页index.php，配置两个location实现动静分离。
ssh 192.168.2.12 "sed -i '45s/index/index  index.php/' /usr/local/nginx/conf/nginx.conf;
sed -i '65,71s/#//' /usr/local/nginx/conf/nginx.conf;
sed -i '69s/^/#/' /usr/local/nginx/conf/nginx.conf;
sed -i '70s/_params/.conf/' /usr/local/nginx/conf/nginx.conf;
/usr/local/nginx/sbin/nginx -s reload;
scp /usr/local/nginx/conf/nginx.conf root@192.168.2.13:/usr/local/nginx/conf/;
/usr/local/nginx/sbin/nginx -s reload;
exit;"
#3）启动相关服务
for i in 12 13
do
ssh 192.168.2.$i
" echo '/usr/local/nginx/sbin/nginx' >> /etc/rc.local;
 chmod +x /etc/rc.local;
/usr/local/nginx/sbin/nginx;
systemctl start  php-fpm;
 systemctl enable php-fpm;"
done
#步骤二：部署NFS，将网站数据迁移至NFS共享服务器   
ssh root@192.168.2.31 "yum install nfs-utils;
 mkdir /web_share;
 sed -i '1c /web_share  192.168.2.0/24(rw,no_root_squash) ' /etc/exports;
 systemctl restart rpcbind;
systemctl eanble rpcbind;
systemctl restart nfs;
 systemctl enable nfs;
exit;"
#2）迁移旧的网站数据到NFS共享服务器

#将web1（192.168.2.11）上的wordpress代码拷贝到NFS共享。
ssh root@192.168.2.11 "cd /usr/local/nginx/;
 tar -czpf html.tar.gz html/;
scp html.tar.gz 192.168.2.31:/web_share/;
exit;"
#登陆nfs服务器，将压缩包解压
ssh 192.168.2.31 " cd /web_share/;
tar -xf html.tar.gz;
exit;"
#3)所有web服务器访问挂载NFS共享数据。
for i in 11 12 13
do
ssh 192.168.2.$i  "rm -rf /usr/local/nginx/html/*;
 yum -y install nfs-utils;
echo "192.168.2.31:/web_share/html /usr/local/nginx/html/ nfs defaults 0 0" >> /etc/fstab;
 mount -a;
echo 'mount -a ' >>/etc/rc.local;"
done
#步骤三：部署HAProxy代理服务器
#1）部署HAProxy

#安装软件，手动修改配置文件，添加如下内容。
#步骤三：部署DNS域名服务器
#修改主配置文件，添加zone。
#3）修改正向解析记录文件。
#注意：保留文件权限。
#启动服务
ssh root@192.168.4.5 "yum -y install haproxy ;
sed -i '1a listen wordpress *:80\nbalance roundrobin\nserver web1 192.168.2.11:80 check inter 2000 rise 2 fall 3\n server web2 192.168.2.12:80 check inter 2000 rise 2 fall 3\n server web3 192.168.2.13:80 check inter 2000 rise 2 fall 3' /etc/haproxy/haproxy.cfg;
systemctl start haproxy;
 systemctl enable haproxy;

yum -y  install bind bind-chroot;
sed -i '13c  listen-on port 53 { any; };' /etc/named.conf;
sed -i '19c  allow-query     { any; };'  /etc/named.conf;
sed -i '52c zone "lab.com" IN { '  /etc/named.conf;
sed -i '54c   file "lab.com.zone";' /etc/named.conf;
cp -p /var/named/named.localhost /var/named/lab.com.zone;
sed -i '8c @        NS     dns.lab.com.' /var/named/lab.com.zone;
sed -i '9c dns     A       192.168.4.5 ' /var/named/lab.com.zone;
sed -i '10c www     A       192.168.4.5' /var/named/lab.com.zone;

systemctl start named;
 systemctl enable named;
exit;"

#步骤四：修改wordpress配置文件
#1）修改wp-config.php

#在define('DB_NAME', 'wordpress')这行前面添加如下两行内容：
ssh root@192.168.2.13 "sed -i  '20a define('WP_SITEURL', 'http://www.lab.com');\ndefine('WP_HOME', 'http://www.lab.com');'  /usr/local/nginx/html/wp-config.php;
exit;"
