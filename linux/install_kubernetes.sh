#!/bin/bash
# 注意，运行前先docker login 阿里云镜像仓库
set -e

#安装docker
wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo
yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum-config-manager --enable docker-ce-nightly
yum-config-manager --enable docker-ce-test
#yum install docker-ce-<VERSION_STRING> docker-ce-cli-<VERSION_STRING> containerd.io
yum install docker-ce docker-ce-cli containerd.io
systemctl start docker

# 为安装kubeadm,kubelet,kubectl准备镜像，下载阿里云的镜像
GCR_URL=k8s.gcr.io
ALIYUN_URL=registry.cn-hangzhou.aliyuncs.com/google_containers
KUBE_VERSION=v1.14.0
PAUSE_VERSION=3.1
ETCD_VERSION=3.3.10
COREDNS_VERSION=1.3.1
IMAGES=(
  kube-apiserver:${KUBE_VERSION}
  kube-controller-manager:${KUBE_VERSION}
  kube-scheduler:${KUBE_VERSION}
  kube-proxy:${KUBE_VERSION}
  pause:${PAUSE_VERSION}
  etcd:${ETCD_VERSION}
  coredns:${COREDNS_VERSION}
)
for IMAGE in ${IMAGES[@]}; do
  docker pull $ALIYUN_URL/$IMAGE
  docker tag $ALIYUN_URL/$IMAGE $GCR_URL/$IMAGE
  docker rmi $ALIYUN_URL/$IMAGE
done

# 配置k8s yum源为阿里云
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

# 设置系统参数
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF
cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

# 关闭防火墙
systemctl stop firewalld && systemctl disable firewalld

# Set SELinux in permissive mode (effectively disabling it)
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# 关闭swap
swapoff -a
sed -i '/swap/s/^\(.*\)$/#1/g' /etc/fstab

#配置iptables的ACCEPT规则
iptables -F && iptables -X && iptables -F -t nat && iptables -X -t nat && iptables -P FORWARD ACCEPT

# 安装kubeadm,kubelet,kubectl
#yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
yum install -y kubelet-1.14.0-0 kubeadm-1.14.0-0 kubectl-1.14.0-0
systemctl enable --now kubelet

# 配置cgroup，需要配置docker和kubelet
DOCKER_CFG_FILE=/etc/docker/daemon.json
if [ -e $DOCKER_CFG_FILE -a -s $DOCKER_CFG_FILE ];then
  sed -i '/{/a\ \ "exec-opts\":[\"native.cgroupdriver=systemd\"],' $DOCKER_CFG_FILE
  systemctl daemon-reload && systemctl restart docker
fi

KUBELET_CFG_FILE=/etc/systemd/system/kubelet.service.d/10-kubeadm.conf
if [ -e $KUBELET_CFG_FILE -a -s $KUBELET_CFG_FILE ];then
  sed -i 's/cgroup-driver=cgroupfs/cgroup-driver=systemd/g' $KUBELET_CFG_FILE
  systemctl enable kubelet && systemctl start kubelet
fi