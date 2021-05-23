#!/bin/sh

SELINUX_PATH=/etc/selinux/config
SELINUX=`sed -rn "/^(SELINUX=).*\$/p" $SELINUX_PATH`

sed -ri "s@^(SELINUX=).*\$@\1disabled@g" $SELINUX_PATH

if [ $SELINUX == 'SELINUX=enforcing' ];then
    read -p "SELinux permissive. you need reboot system ( yes or no ):" INPUT
    [ $INPUT == 'yes' -o $INPUT == 'y' ] && reboot || echo "please Manual operation reboot"
else
    echo "SELINUX disabled"
fi