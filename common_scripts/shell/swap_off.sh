#!/bin/sh

echo "vm.swappiness=1">> /etc/sysctl.conf

swapoff -a

sysctl -p