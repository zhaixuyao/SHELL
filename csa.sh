#!/bin/bash
　echo 'server0.example.com' > /etc/hostname
[ $? -eq 0 ] && echo "修改主机名成功"
nmcli connection modify "System eth0" ipv4.method manual ipv4.addresses '172.25.0.11/24 172.25.0.254' ipv4.dns 172.25.254.254 connection.autoconnect yes　
nmcli connection up "System eth0"
[ $? -eq 0 ] && echo "修改IP成功"　
#１.搭建软件仓库
rm -rf /etc/yum.repos.d/*.repo
echo '[dvd]
name=dvd
baseurl=http://classroom.example.com/content/rhel7.0/x86_64/dvd
enabled=1
gpgcheck=0' >  /etc/yum.repos.d/dvd.repo
	yum clean all &>/dev/null 
	yum repolist &>/dev/null
[ $? -eq 0 ] && echo "yum搭建成功"
#2.划分逻辑卷
vgcreate systemvg /dev/vdb1　
lvcreate -n vo -L 200M systemvg　
mkfs.ext3 /dev/systemvg/vo　
vgextend systemvg /dev/vdb2　
lvextend -L 300M /dev/systemvg/vo　
resize2fs /dev/systemvg/vo　
echo '/dev/systemvg/vo   /vo  ext3 defaults 0 0' >> /etc/fstab
mkdir /vo
sleep 2
mount -a　
[ $? -eq 0 ] && echo "2.划分逻辑卷成功"
#３．创建用户账户
	groupadd adminuser 
	useradd -G adminuser natasha 
	useradd -G adminuser harry  
	useradd -s /sbin/nologin sarah 
	echo flectrag | passwd --stdin natasha 
	echo flectrag | passwd --stdin harry  
	echo flectrag | passwd --stdin sarah 
[ $? -eq 0 ] && echo "创建用户账户成功"
#4.配置文件/var/tmp/fstab的权限
	\cp /etc/fstab  /var/tmp/fstab
sleep 1
	setfacl -m u:natasha:rw /var/tmp/fstab
sleep 2
	setfacl -m u:harry:- /var/tmp/fstab
[ $? -eq 0 ] && echo "4．文件/var/tmp/fstab的权限配置成功"
#5.cron任务
echo '23 14 * * * /bin/echo　hiya' > /var/spool/cron/natasha
systemctl restart crond
systemctl enable crond
[ $? -eq 0 ] && echo "5.cron任务成功"
#6.共享目录
	mkdir /home/admins
	chown :adminuser /home/admins
	chmod 2770 /home/admins
[ $? -eq 0 ] && echo "6.共享目录成功"
#7.安装内核
wget http://classroom.example.com/content/rhel7.0/x86_64/errata/Packages/kernel-3.10.0-123.1.2.el7.x86_64.rpm &>/dev/null
yum -y install kernel-3.10.0-123.1.2.el7.x86_64.rpm　&>/dev/null
[ $? -eq 0 ] && echo "7.安装内核成功"
#9.autofs配置
	yum -y install autofs &>/dev/null
	mkdir /home/guests
		echo '/home/guests  /etc/auto.guests' > /etc/auto.master
		echo '* -rw classroom.example.com:/home/guests/&' > /etc/auto.guests
	systemctl restart autofs
	systemctl enable autofs &>/dev/null
[ $? -eq 0 ] && echo "autofs配置成功"
#10.NTP
	yum -y install chrony &>/dev/null
		sed -i 's/^server/#server/' /etc/chrony.conf
		echo 'server classroom.example.com iburst' >> /etc/chrony.conf
	systemctl restart chronyd
	systemctl enable chronyd
[ $? -eq 0 ] && echo "NTP配置成功"

#11
	useradd alex　
	usermod -u 3456 alex
	echo flectrag | passwd --stdin alex 
[ $? -eq 0 ] && echo "11配置用户成功"
#12.swp分区
mkswap /dev/vdb5
echo '/dev/vdb5 swap swap defaults 0 0 ' >> /etc/fstab
sleep 2
swapon -a
[ $? -eq 0 ] && echo "12.swp分区成功"
#13查找文件
	mkdir /root/findfiles
	find / -user student -type f -exec cp -p {} /root/findfiles/ \; &>/dev/null

[ $? -eq 0 ] && echo "13查找文件成功"

#14
	grep seismic /usr/share/dict/words > /root/wordlist
[ $? -eq 0 ] && echo "14查找字符窜成功"
#15创建逻辑卷
vgcreate -s 16M datastore /dev/vdb3　
lvcreate -L 50 -n database datastore　
mkfs.ext3 /dev/datastore/database　
mkdir /mnt/database
echo '/dev/datastore/database  /mnt/database ext3 defaults 0 0' >> /etc/fstab
sleep 2
mount -a
[ $? -eq 0 ] && echo "15创建逻辑卷成功"
#16
	tar -jcPf /root/backup.tar.bz2 /usr/local/
[ $? -eq 0 ] && echo "16创建归档成功"
exit
