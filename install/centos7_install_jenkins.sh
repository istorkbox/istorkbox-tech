#!/bin/bash
#jenkins
#安装文件镜像
#https://blog.csdn.net/w05980598/article/details/80007688
#Jenkins自身采用Java开发,所以要必须安装JDK； 
#本文集成的项目基于jenkins构架,所以jenkins也必须安装；
##maven配置阿里云的镜像源地址，vim /usr/share/maven/conf/settings.xml将下面内容添加进 mirrors 节点
# <mirror>
#    <!--This sends everything else to /public -->
#    <id>nexus-aliyun</id>
#    <mirrorOf>*</mirrorOf>
#    <name>Nexus aliyun</name>
#    <url>http://maven.aliyun.com/nexus/content/groups/public</url>
# </mirror>
 
yum -y install wget

#check dir
cd /usr/local/
if [ ! -d 'src' ]; then
	mkdir 'src'
fi
cd /usr/local/src


#install jdk8
wget https://github.com/istorkbox/install/raw/master/centos7_jdk8.sh && sh centos7_jdk8.sh;
ln -s /usr/local/jdk8/bin/java /usr/bin/java


#download jenkins and install
if [ -f '/usr/local/jenkins/jenkins.war' ]; then
	echo "jenkins has installed"	
else
	mkdir -p /usr/local/jenkins/

	##下载war包安装
	# wget -c -O /usr/local/jenkins/jenkins.war http://mirrors.jenkins.io/war-stable/latest/jenkins.war
	##download file from tencent clund
	# wget -c -O /usr/local/jenkins/jenkins.war https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/jenkins-20180705.war
	# nohup java -jar /usr/local/jenkins/jenkins.war &

	#yum安装
	wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo 
	rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key 
	yum clean all && yum makecache 
	yum install -y jenkins 
	
	##如果是自定义安装的JDK
	##配置 JDK 路径到 Jenkins 中
	# vim /etc/init.d/jenkins
	##将自己的java目录加入到candidates里
	# candidates="
	# /etc/alternatives/java
	# /usr/lib/jvm/java-1.8.0/bin/java
	# /usr/lib/jvm/jre-1.8.0/bin/java
	# /usr/lib/jvm/java-1.7.0/bin/java
	# /usr/lib/jvm/jre-1.7.0/bin/java
	# /usr/bin/java
	# /usr/local/jdk8/bin/java
	# "
	##安装完毕后启动
	
	
	systemctl start jenkins
	
	echo "访问 http://ip:8080/ 进行安装" 
	echo "默认密码如下："
	cat /root/.jenkins/secrets/initialAdminPassword 
	
	echo "jenkins install success"
	
	##No valid crumb was included in the request的解决方案： 
	##在jenkins 的Configure Global Security下 , 取消“防止跨站点请求伪造（Prevent Cross Site Request Forgery exploits）”的
	
fi