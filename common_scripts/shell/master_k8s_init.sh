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

systemctl start kubelet && systemctl enable kubelet


echo "1" >/proc/sys/net/bridge/bridge-nf-call-iptables


cat >> /etc/hosts << EOF
192.168.100.103 master
192.168.100.104 node1
199.232.68.133 raw.githubusercontent.com
EOF

#kubernetes-version=v1.20.1：指定要安装的版本号。
#apiserver-advertise-address：指定用 Master 的哪个IP地址与 Cluster的其他节点通信。
#service-cidr：指定Service网络的范围，即负载均衡VIP使用的IP地址段。
#pod-network-cidr：指定Pod网络的范围，即Pod的IP地址段。
#ignore-preflight-errors=：忽略运行时的错误，例如执行时存在[ERROR NumCPU]和[ERROR Swap]，忽略这两个报错就是增加--ignore-preflight-errors=NumCPU 和--ignore-preflight-errors=Swap的配置即可。
#image-repository：Kubenetes默认Registries地址是 k8s.gcr.io，一般在国内并不能访问 gcr.io，可以将其指定为阿里云镜像地址：registry.aliyuncs.com/google_containers
kubeadm reset

kubeadm init --kubernetes-version=v1.20.1 \
--pod-network-cidr=10.244.0.0/16 \
--service-cidr=10.96.0.0/12 \
--apiserver-advertise-address=192.168.100.103 \
--ignore-preflight-errors=Swap \
--ignore-preflight-errors=NumCPU \
--image-repository registry.cn-hangzhou.aliyuncs.com/google_containers


#初始化操作主要经历了下面15个步骤，每个阶段均输出均使用[步骤名称]作为开头。如果安装失败，可以执行 kubeadm reset 命令将主机恢复原状，重新执行 kubeadm init 命令再次进行安装
#1[init]：指定版本进行初始化操作
#2[preflight] ：初始化前的检查和下载所需要的Docker镜像文件。
#3[kubelet-start] ：生成kubelet的配置文件”/var/lib/kubelet/config.yaml”，没有这个文件kubelet无法启动，所以初始化之前的kubelet实际上启动失败。
#4[certificates]：生成Kubernetes使用的证书，存放在/etc/kubernetes/pki目录中。
#5[kubeconfig] ：生成 KubeConfig 文件，存放在/etc/kubernetes目录中，组件之间通信需要使用对应文件。
#6[control-plane]：使用/etc/kubernetes/manifest目录下的YAML文件，安装 Master 组件。
#7[etcd]：使用/etc/kubernetes/manifest/etcd.yaml安装Etcd服务。
#8[wait-control-plane]：等待control-plan部署的Master组件启动。
#9[apiclient]：检查Master组件服务状态。
#10[upload-config]：更新配置
#11[kubelet]：使用configMap配置kubelet。
#12[patchnode]：更新CNI信息到Node上，通过注释的方式记录。
#13[mark-control-plane]：为当前节点打标签，打了角色Master，和不可调度标签，这样默认就不会使用Master节点来运行Pod。
#14[bootstrap-token]：生成token记录下来，后边使用kubeadm join往集群中添加节点时会用到
#15[addons]：安装附加组件CoreDNS和kube-proxy


mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml



################node执行kubeadm init最后给出的token用kubeam join加入集群####################

kubectl get node
kubectl get pod --all-namespaces -o wide


#kubectl create deployment nginx-deploy --image=nginx
#kubectl expose deployment nginx-deploy --port=80 --type=NodePort
#kubectl get pod,svc