#!/bin/bash
#aerospike-server-community-4.5.1.5-el7.tgz
#安装文件镜像
#https://www.cnblogs.com/yaoyuan2/p/10540700.html
#https://www.aerospike.com/artifacts/aerospike-server-community/4.5.1.5/aerospike-server-community-4.5.1.5-el7.tgz

##如果需要,Centos7关闭防火墙
#临时关闭
# systemctl stop firewalld
#禁止开机启动
# systemctl disable firewalld

if type wget >/dev/null 2>&1; then
	echo '...'
else
	echo 'start install wget'
	yum -y install wget
fi

#check dir
cd /usr/local/
if [ ! -d 'src' ]; then
	mkdir 'src'
fi
cd /usr/local/src

#download aerospike and install
wget https://www.aerospike.com/artifacts/aerospike-server-community/4.5.1.5/aerospike-server-community-4.5.1.5-el7.tgz

#升级openssl
yum update openssl


#解压&安装
tar -zxvf aerospike-server-community-4.5.1.5-el7.tgz

##可能要删除锁定的文件
# sudo rm /etc/passwd.lock
# sudo rm /etc/shadow.lock
# sudo rm /etc/group.lock
# sudo rm /etc/gshadow.lock

cd aerospike-server-community-4.5.1.5-el7/
sh asinstall

#查看状态
systemctl status aerospike
asinfo -v STATUS


#其他命令
#停止
systemctl stop aerospike

#重启
systemctl restart aerospike

#查看日志
journalctl -u aerospike -a -o cat -f


#卸载
#查看服务名
rpm -qa |grep -i aerospike

##卸载
# yum remove aerospike-server-community-4.5.1.5-1.el7.x86_64


##tools：

#下载
cd /usr/local/src
wget https://www.aerospike.com/artifacts/aerospike-tools/3.18.1/aerospike-tools-3.18.1-el7.tgz


#解压安装
cd /usr/local/src
tar -zxvf aerospike-tools-3.18.1-el7.tgz
cd aerospike-tools-3.18.1-el7/
sh asinstall

#验证
yum list installed | grep aerospike-tools

##asadm命令
# asadm
# aql
# asinfo

##备份asbackup
# asbackup -n test -o ~/output


##AMC
cd /usr/local/src
#下载社区版
wget https://www.aerospike.com/artifacts/aerospike-amc-community/4.0.22/aerospike-amc-community-4.0.22-1.x86_64.rpm
#安装
rpm -ivh aerospike-amc-community-4.0.22-1.x86_64.rpm
cp /etc/amc/amc.conf /etc/amc/amc.conf.bac
 

##启动&停止&重启
##启动
# /etc/init.d/amc start
##停止
# /etc/init.d/amc stop
##重启
# /etc/init.d/amc restart
##查看状态
# /etc/init.d/amc status

##查看日志
# /var/log/amc/error.log

##查看网页
# http://192.168.1.231:8081
