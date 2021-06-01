#!/bin/sh

echo "vm.swappiness=0">> /etc/sysctl.conf
sed -i 's/^\/dev\/mapper\/centos-swap/#&/' /etc/fstab

swapoff -a

sysctl -p