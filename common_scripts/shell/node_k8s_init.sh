#!/bin/sh

cat > /etc/yum.repos.d/kubernetes.repo << EOF
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

yum install -y kubelet-1.20.1 kubeadm-1.20.1 kubectl-1.20.1



echo "1" >/proc/sys/net/bridge/bridge-nf-call-iptables
echo "1" >/proc/sys/net/ipv4/ip_forward


cat >> /etc/hosts << EOF
192.168.100.103 master
192.168.100.104 node1
EOF

systemctl start kubelet && systemctl enable kubelet
