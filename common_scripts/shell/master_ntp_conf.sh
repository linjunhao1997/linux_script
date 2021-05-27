#!/bin/sh

sed -i 's/^server/#&/' /etc/chrony.conf

sed -i '/www.pool.ntp.org/a\server ntp.aliyun.com iburst' /etc/chrony.conf

timedatectl set-timezone Asia/Shanghai

systemctl restart chronyd

chronyc -a makestep