#!/bin/sh

stty erase ^H
read -p "please input clinet network(eg:192.168.1.0/24):" INPUT

sed -i 's/^server/#&/' /etc/chrony.conf

sed -i '/www.pool.ntp.org/a\server ntp.aliyun.com iburst' /etc/chrony.conf

sed -i "/Allow NTP client access from local network/a\allow $INPUT" /etc/chrony.conf

sed -i '/Serve time even if not synchronized to a time source/a\local stratum 10' /etc/chrony.conf


timedatectl set-timezone Asia/Shanghai

systemctl restart chronyd

chronyc -a makestep