#!/bin/sh

FILE_PATH="/etc/sysconfig/network-scripts/ifcfg-ens33"

init() {
    NUM=`sed -n "/$1/=" $FILE_PATH`
    stty erase ^H
    read -p "please input $1:" VAL
    if [ "$NUM" == "" ] 
	then
		sed -i "\$a\\$1=$VAL" $FILE_PATH
	else
		sed -i "${NUM}c $1=$VAL" $FILE_PATH
	fi
}

init BOOTPROTO
init ONBOOT
init IPADDR
init NETMASK
init GATEWAY
init DNS1

service network restart

exit 0