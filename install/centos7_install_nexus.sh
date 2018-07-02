#!/bin/bash

#nexus-3.12.1-01-unix.tar.gz
#https://blog.csdn.net/smartbetter/article/details/55116889
#https://www.sonatype.com/download-oss-sonatype
#https://download.sonatype.com/nexus/3/latest-unix.tar.gz
#https://sonatype-download.global.ssl.fastly.net/repository/repositoryManager/3/nexus-3.12.1-01-unix.tar.gz

echo 'start install nexus'

#install wget
yum -y install wget

cd /usr/local/src

#install jdk8
wget https://github.com/istorkbox/install/raw/master/centos7_jdk8.sh && sh centos7_jdk8.sh;

#download nexus and install
if [ -d 'nexus' ]; then
	echo "nexus has installed"
else
	if [ ! -f 'nexus-3.12.1-01-unix.tar.gz' ]; then
	  # download file from website
	  sudo wget https://sonatype-download.global.ssl.fastly.net/repository/repositoryManager/3/nexus-3.12.1-01-unix.tar.gz
	  # download file from tencent clund
	  #sudo wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/nexus-3.12.1-01-unix.tar.gz
	fi
	
	tar -zxvf nexus-3.12.1-01-unix.tar.gz
	rm -rf /usr/local/nexus
	mv nexus-3.12.1-01 /usr/local/nexus
	
	
	##自定义配置虚拟机可打开 nexus.vmoptions 文件进行配置
	##(如果Linux硬件配置比较低的话,建议修改为合适的大小,否则会出现运行崩溃的现象)：
	##//虚拟机选项配置文件
	# vim /usr/local/nexus/bin/nexus.vmoptions                  
	sed -i "s#-Xms1200M#-Xms512M#g" /usr/local/nexus/bin/nexus.vmoptions
	
	##启动 Nexus（默认端口是8081），Nexus 常用的一些命令包括：
	# /usr/local/nexus/bin/nexus {start|stop|run|run-redirect|status|restart|force-reload}，
	
	#下面我们启动Nexus：启动后稍等会儿才能正常访问

	/usr/local/nexus/bin/nexus start
	
	##WARNING: ************************************************************
	##WARNING: Detected execution as "root" user.  This is NOT recommended!
	##WARNING: ************************************************************
	##Starting nexus
	##上面在启动过程中出现警告：“不推荐使用root用户启动”。这个警告不影响Nexus的正常访问和使用。去掉上面WARNING的办法请自行百度。 
	##到此安装完毕。下面访问服务器 localhost:8081，可以看到：
	
	curl localhost:8081
	echo "nexus install success"

fi