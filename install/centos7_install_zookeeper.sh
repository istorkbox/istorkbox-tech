#!/bin/bash
#keeper-3.4.12.tar.gz
#安装文件镜像
#https://github.com/hhhcommon/Linux-Tutorial/blob/master/markdown-file/Zookeeper-Install.md
#http://www.apache.org/dyn/closer.cgi/zookeeper/
#https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/zookeeper-3.4.12/zookeeper-3.4.12.tar.gz
#https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/zookeeper-3.4.12.tar.gz
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

#download zookeeper and install
#wget https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/zookeeper-3.4.12/zookeeper-3.4.12.tar.gz
#download from tencent cloud
wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/zookeeper-3.4.12.tar.gz

tar -zxvf zookeeper-3.4.12.tar.gz
mv zookeeper-3.4.12 /usr/local/zookeeper

cd /usr/local/zookeeper/conf
mv zoo_sample.cfg zoo.cfg

mkdir -p /usr/local/zookeeper/data
mkdir -p /tmp/zookeeper

#将配置文件中的这个值,原值：dataDir=/tmp/zookeeper 改为：dataDir=/usr/local/zookeeper/data
sed -i "s#dataDir=/tmp/zookeeper#dataDir=/usr/local/zookeeper/data#g" /usr/local/zookeeper/conf/zoo.cfg

#防火墙开放2181端口
firewall-cmd --zone=public --add-port=2181/tcp --permanent
firewall-cmd --reload

#启动zookeeper
sh /usr/local/zookeeper/bin/zkServer.sh start

#查看zookeeper状态
sh /usr/local/zookeeper/bin/zkServer.sh status

##停止zookeeper
# sh /usr/local/zookeeper/bin/zkServer.sh stop

##Zookeeper客户端工具
#zooweb
cd /usr/local/src

#下载zooweb
wget https://github.com/hhhcommon/zooweb/raw/master/app/zooweb-1.1.jar

#移动目录
mkdir -p cp -p /usr/local/zooweb/
mv zooweb-1.1.jar /usr/local/zooweb/zooweb-1.1.jar

#启动zooweb
cd /usr/local/zooweb/
nohup java -jar zooweb-1.1.jar

# 查询是否能访问
curl http://localhost:9345

