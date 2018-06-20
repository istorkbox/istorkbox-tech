#!/bin/bash
#tomcat安装
#文件镜像
#apache-tomcat-6.0.53.tar.gz
#https://archive.apache.org/dist/tomcat/tomcat-6/v6.0.53/bin/apache-tomcat-6.0.53.tar.gz
#https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/apache-tomcat-6.0.53.tar.gz
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


if [ ! -f 'apache-tomcat-6.0.53.tar.gz' ]; then
	#download zookeeper and install
	wget https://archive.apache.org/dist/tomcat/tomcat-6/v6.0.53/bin/apache-tomcat-6.0.53.tar.gz
	#download from tencent cloud
	#wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/apache-tomcat-6.0.53.tar.gz
fi

tar -zxvf apache-tomcat-6.0.53.tar.gz
mv apache-tomcat-6.0.53 /usr/local/tomcat6

#启动:
cd /usr/local/tomcat6
/usr/local/tomcat6/bin/startup.sh

# 查询是否能访问
curl http://localhost:8080/

##停止:
# /usr/local/tomcat6/bin/shutdown.sh

