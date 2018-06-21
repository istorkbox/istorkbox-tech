#!/bin/bash
#mycat
#安装文件镜像
#https://github.com/hhhcommon/Linux-Tutorial/blob/master/markdown-file/Mycat-Install-And-Settings.md
#http://dl.mycat.io/1.6-RELEASE/Mycat-server-1.6-RELEASE-20161028204710-linux.tar.gz
#https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/Mycat-server-1.6-RELEASE-20161028204710-linux.tar.gz

#Docker安装：
#安装依赖
sudo yum -y install curl
sudo yum install -y wget yum-utils device-mapper-persistent-data lvm2

#添加 repo（可能网络会很慢，有时候会报：Timeout，所以要多试几次）
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum makecache fast

#安装docker-ce,速度可能很慢
sudo yum install -y docker-ce

#启动Docker：
systemctl start docker.service

#停止Docker：
#systemctl stop docker.service

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

#Docker 快速部署 MySQL
docker run --name mysql1 -p 3316:3306 -e MYSQL_ROOT_PASSWORD=root -d daocloud.io/library/mysql:5.7.13
docker run --name mysql2 -p 3326:3306 -e MYSQL_ROOT_PASSWORD=root -d daocloud.io/library/mysql:5.7.13
docker run --name mysql3 -p 3336:3306 -e MYSQL_ROOT_PASSWORD=root -d daocloud.io/library/mysql:5.7.13

#Mycat 安装
#JDK8安装
wget https://github.com/istorkbox/install/raw/master/centos7_jdk8.sh && sh centos7_jdk8.sh;

