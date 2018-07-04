#!/bin/bash
#keepalived-2.0.5.tar.gz
#http://www.keepalived.org/download.html

#安装依赖包
yum -y update
yum -y install curl gcc gcc-c++ pcre pcre-devel zlib zlib-devel openssl openssl-devel libnl libnl-devel libnl3-devel net-snmp-devel libnfnetlink-devel

#下载源码包,安装包放在/usr/local/src目录
cd /usr/local/src

if [ ! -f 'keepalived-2.0.5.tar.gz' ]; then
    wget http://www.keepalived.org/software/keepalived-2.0.5.tar.gz
    #download from tencent cloud
    #wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/keepalived-2.0.5.tar.gz
fi

sleep 5s

#解压安装
tar zxvf keepalived-2.0.5.tar.gz
cd keepalived-2.0.5
./configure --prefix=/usr/local/keepalived
make && make install


#将keepalived安装成Linux系统服务：
#因为没有使用keepalived的默认路径安装（默认是/usr/local）,安装完成之后，需要做一些工作
#复制默认配置文件到默认路径
mkdir /etc/keepalived

cp /usr/local/src/keepalived-2.0.5/keepalived/etc/init.d/keepalived /etc/init.d/
cp /usr/local/src/keepalived-2.0.5/keepalived/etc/sysconfig/keepalived /etc/sysconfig/
cp /usr/local/keepalived/etc/keepalived/keepalived.conf /etc/keepalived/


# 启动keepalived 服务
service keepalived start  

##设置keepalived开机启动
# chkconfig keepalived on  

##启动keepalived 
# systemctl start keepalived.service

##停止keepalived
# systemctl stop keepalived.service

##设置keepalived开机启动
# systemctl enable keepalived.service

##查看keepalived进程
# ps -ef | grep keepalived

##查看虚拟IP状态
# ip a
