#!/bin/bash
#docker-ce
#安装文件镜像
#https://github.com/hhhcommon/Linux-Tutorial/blob/master/markdown-file/Docker-Install-And-Usage.md

#CentOS 安装过程：
#安装依赖
sudo yum install -y wget yum-utils device-mapper-persistent-data lvm2

#添加 repo（可能网络会很慢，有时候会报：Timeout，所以要多试几次）
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum makecache fast

#安装docker-ce,速度可能很慢
sudo yum install -y docker-ce

#启动Docker：
systemctl start docker.service

#停止Docker：
systemctl stop docker.service

#启动Docker：
systemctl start docker.service

#查看状态：
systemctl status docker.service

#运行 hello world 镜像：
sudo docker run hello-world

#阿里云镜像加速
#阿里云注册后请访问：https://cr.console.aliyun.com/#/accelerator，你会看到专属的加速地址，
#比如我申请的是：https://rhyqe7c3.mirror.aliyuncs.com
#通过修改daemon配置文件/etc/docker/daemon.json来使用加速器：
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://rhyqe7c3.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker

