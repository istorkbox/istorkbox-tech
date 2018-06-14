#!/bin/bash
#redis-4.0.10.tar.gz
#https://redis.io/download

#安装依赖包
yum install -y gcc-c++ tcl

#下载 redis
#安装包放在/usr/local/src目录里
cd /usr/local/src

if [ ! -f 'redis-4.0.10.tar.gz' ]; then
    wget http://download.redis.io/releases/redis-4.0.10.tar.gz
    #download from tencent cloud
    #wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/redis-4.0.10.tar.gz
fi

if [ ! -f 'redis.conf' ]; then
wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/redis-4.0.10/redis.conf
fi

sleep 5s

#解压和编译
#解压下载的源码包
tar -zvxf redis-4.0.10.tar.gz

#移动到指定位置
rm -rf /usr/local/redis
mv redis-4.0.10 /usr/local/redis

#在/usr/local/redis下创建文件夹
cd /usr/local/redis
#编译
make

#copy config file
#"redis.conf" file set redis login password: "123456"
cp -rf /usr/local/src/redis.conf /usr/local/redis/redis.conf

cd /usr/local/redis/src
./redis-server -v
./redis-server ../redis.conf

