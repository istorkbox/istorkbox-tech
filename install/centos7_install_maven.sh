#!/bin/bash
#apache-maven-3.5.3-bin.tar.gz
#安装文件镜像
#http://mirrors.aliyun.com/apache/maven/maven-3/3.5.3/binaries/apache-maven-3.5.3-bin.tar.gz
#https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/apache-maven-3.5.3-bin.tar.gz
##maven配置阿里云的镜像源地址，vim /usr/local/maven3.5.3/conf/settings.xml将下面内容添加进 mirrors 节点
# <mirror>
#    <!--This sends everything else to /public -->
#    <id>nexus-aliyun</id>
#    <mirrorOf>*</mirrorOf>
#    <name>Nexus aliyun</name>
#    <url>http://maven.aliyun.com/nexus/content/groups/public</url>
# </mirror>

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

#download maven and install
if type mvn >/dev/null 2>&1; then
	echo "maven has installed"	
else
	wget http://mirrors.aliyun.com/apache/maven/maven-3/3.5.3/binaries/apache-maven-3.5.3-bin.tar.gz
	#download from tencent cloud
	#wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/apache-maven-3.5.3-bin.tar.gz
	tar -zxvf apache-maven-3.5.3-bin.tar.gz
	mv apache-maven-3.5.3 /usr/local/maven3.5.3
	echo "MAVEN_HOME=/usr/local/maven3.5.3" >> /etc/profile
	echo "PATH=\$PATH:\$MAVEN_HOME/bin" >> /etc/profile
	echo "MAVEN_OPTS=\"-Xms256m -Xmx356m\"" >> /etc/profile
	echo "export MAVEN_HOME PATH MAVEN_OPTS" >> /etc/profile
	
	source /etc/profile
	
	if type mvn >/dev/null 2>&1;  then
		echo "maven install success"
	else
		echo "maven install failure"
	fi
	
	rm apache-maven-3.5.3-bin.tar.gz
	
	echo "if show '-bash: java command not found', execute the following commands:"
	echo "source /etc/profile"
fi