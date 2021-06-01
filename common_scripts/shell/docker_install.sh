#!/bin/sh
yum remove docker docker-common docker-selinux docker-engine

yum -y install yum-utils device-mapper-persistent-data lvm2

wget -O /etc/yum.repos.d/docker-ce.repo https://download.docker.com/linux/centos/docker-ce.repo

sed -i 's+download.docker.com+mirrors.tuna.tsinghua.edu.cn/docker-ce+' /etc/yum.repos.d/docker-ce.repo

yum makecache fast

yum -y install docker-ce

systemctl start docker

cat > /etc/docker/daemon.json << EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],

  "registry-mirrors": [
    "https://kfwkfulq.mirror.aliyuncs.com",
    "https://2lqq34jg.mirror.aliyuncs.com",
    "https://pee6w651.mirror.aliyuncs.com",
    "http://hub-mirror.c.163.com"
  ]
}
EOF

systemctl enable docker

systemctl restart docker

docker info


