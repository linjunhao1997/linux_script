#!/bin/sh

stty erase ^H
read -p "please input hostname:" HOSTNAME
hostnamectl set-hostname $HOSTNAME