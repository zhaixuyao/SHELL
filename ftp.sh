#!/bin/bash
yum -y install vsftpd &>/dev/null
rpm -q vsftpd
cp /etc/vsftpd/vsftpd.conf  /etc/vsftpd/vsftpd.conf.old
sed -i 's/^#anon/anon/' /etc/vsftpd/vsftpd.conf
systemctl restart vsftpd
systemctl enable vsftpd
chmod 777 /var/ftp/pub
