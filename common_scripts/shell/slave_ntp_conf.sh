#!/bin/sh

stty erase ^H
read -p "please input master IP:" INPUT


sed -i 's/^server/#&/' /etc/chrony.conf

sed -i   "/www.pool.ntp.org/a\server $INPUT iburst" /etc/chrony.conf

timedatectl set-timezone Asia/Shanghai

systemctl restart chronyd

chronyc -a makestep

chronyc sourcestats -v