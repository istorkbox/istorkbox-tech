#!/bin/bash
#mycat
#安装文件镜像
#https://github.com/hhhcommon/Linux-Tutorial/blob/master/markdown-file/Mycat-Install-And-Settings.md
#http://dl.mycat.io/1.6-RELEASE/Mycat-server-1.6-RELEASE-20161028204710-linux.tar.gz
#https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/Mycat-server-1.6-RELEASE-20161028204710-linux.tar.gz
#https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/mycat-1.6.tar.gz

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

##在MySQL实例mysql1中执行如下初始化脚本：
# CREATE DATABASE /*!32312 IF NOT EXISTS*/`adg_system_0000` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
# USE `adg_system_0000`;
##在MySQL实例mysql2中执行如下初始化脚本：
# CREATE DATABASE /*!32312 IF NOT EXISTS*/`adg_system_0001` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
# USE `adg_system_0001`;
##在MySQL实例mysql3中执行如下初始化脚本：
# CREATE DATABASE /*!32312 IF NOT EXISTS*/`adg_system_0002` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
# USE `adg_system_0002`;


#Mycat 安装
#JDK8安装
wget https://github.com/istorkbox/install/raw/master/centos7_jdk8.sh && sh centos7_jdk8.sh;

#下载
cd /usr/local/src
#wget http://dl.mycat.io/1.6-RELEASE/Mycat-server-1.6-RELEASE-20161028204710-linux.tar.gz
# download from tencent cloud
#wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/Mycat-server-1.6-RELEASE-20161028204710-linux.tar.gz

#download file
wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/mycat-1.6.tar.gz

#解压
tar -zxvf mycat-1.6.tar.gz
mv /usr/local/src/mycat-1.6 /usr/local/mycat

#设置 Mycat 的环境变量vim /etc/profile，添加如下内容：
echo "MYCAT_HOME=/usr/local/mycat" >> /etc/profile
echo "export PATH=\$PATH:\$MYCAT_HOME/bin" >> /etc/profile

source /etc/profile

echo "source /etc/profile"

#进入Mycat目录：
cd /usr/local/mycat/bin

#后台启动：
/usr/local/mycat/bin/mycat start 

##查看日志"
# tail -300f /usr/local/mycat/logs/mycat.log

echo -e "查看日志"
echo -e "tail -300f /usr/local/mycat/logs/mycat.log\n"

##控制台启动：
# /usr/local/mycat/bin/mycat console

##重启：
# /usr/local/mycat/bin/mycat restart

##停止：
# /usr/local/mycat/bin/mycat stop

##连接 Mycat,然后输入mycat的adg_system_user用户密码:123456(server.xml 中配置的)
# mysql -h203.195.174.41 -uadg_system_user -p -P8066

##不建议 的连接方式：
##SQLyog 软件，我这边是报：find no Route:select * from youmeek_nav.nav_url limit 0, 1000
##Windows 系统下使用 cmd 去连接，我这边是报：ERROR 1105 (HY000): Unknown character set: 'gbk'
##MySQL-Front 软件，没用过，但是别人说是有兼容性问题
##建议 的连接方式：
##Navicat for mysql 软件
##Linux 下的 MySQL 客户端命令行

##使用 Navicat 连接 MyCat 测试 SQL
# https://github.com/hhhcommon/Linux-Tutorial/blob/master/markdown-file/Mycat-Install-And-Settings.md#%E4%BD%BF%E7%94%A8-navicat-%E8%BF%9E%E6%8E%A5-mycat-%E6%B5%8B%E8%AF%95-sql