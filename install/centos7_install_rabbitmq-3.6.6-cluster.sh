#!/bin/bash
#rabbitmq-server-3.6.6
#otp_src_19.2.tar.gz
#https://blog.csdn.net/hao134838/article/details/71512557?utm_source=copy
#https://www.cnblogs.com/saneri/p/7798251.html

#https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/rabbitmq-server-generic-unix-3.6.6.tar.xz
#https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/otp_src_19.2.tar.gz
#http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.6/rabbitmq-server-generic-unix-3.6.6.tar.xz
#http://erlang.org/download/otp_src_19.2.tar.gz

#安装erlang
yum -y install make gcc gcc-c++ kernel-devel m4 ncurses-devel openssl-devel    ncurses-devel
yum -y install xz perl unixODBC unixODBC-devel

mkdir -p /apache/RabbitMQ/erlang/
cd /apache/RabbitMQ/erlang/
#wget http://erlang.org/download/otp_src_19.2.tar.gz
wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/otp_src_19.2.tar.gz
tar xvf otp_src_19.2.tar.gz
cd otp_src_19.2
./configure 
make 
make install
#//输入erl出现如下界面即表示安装完成
#[root@rabbitmq-node1 otp_src_19.2]# erl
#Erlang/OTP 19 [erts-8.2] [source] [64-bit] [smp:8:8] [async-threads:10] [hipe] [kernel-poll:false]
#Eshell V8.2  (abort with ^G)


#安装rabbitmq3.6.6=
cd /apache/RabbitMQ
#wget http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.6/rabbitmq-server-generic-unix-3.6.6.tar.xz
wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/rabbitmq-server-generic-unix-3.6.6.tar.xz
xz -d rabbitmq-server-generic-unix-3.6.6.tar.xz
tar xvf rabbitmq-server-generic-unix-3.6.6.tar

#vi /etc/profile
#export PATH=$PATH:/apache/RabbitMQ/rabbitmq_server-3.6.6/sbin
echo "export PATH=$PATH:/apache/RabbitMQ/rabbitmq_server-3.6.6/sbin" >> /etc/profile
source /etc/profile

#copy .erlang.cookie
#scp /root/.erlang.cookie root@203.195.219.61:/root