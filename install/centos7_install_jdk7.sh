#!/bin/bash

#jdk-7u80-linux-x64.tar.gz
#https://blog.csdn.net/ithomer/article/details/9288353

echo 'start install jdk8'

#install wget
if type wget >/dev/null 2>&1; then
	echo '...'
else
	echo 'start install wget'
	yum -y install wget
fi

cd /usr/local

# check downloads directory
if [ ! -d 'src' ]; then
	mkdir 'src'
fi

#download java and install
if type java >/dev/null 2>&1; then
	echo "java has installed, java home:$JAVA_HOME"
else
	cd /usr/local/src
	
	if [ ! -f 'jdk-7u80-linux-x64.tar.gz' ]; then
	  # download file from oracle website
	  #http://download.oracle.com/otn/java/jdk/7u80-b15/jdk-7u80-linux-x64.tar.gz
	  # download file from tencent clund
	  sudo wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/jdk-7u80-linux-x64.tar.gz
	fi
	
	tar -zxvf jdk-7u80-linux-x64.tar.gz
	rm -rf /usr/local/jdk7
	mv jdk1.7.0_80 /usr/local/jdk7
	
	echo "modify \'/etc/profile\' file."	
	
	echo "JAVA_HOME=/usr/local/jdk7" >> /etc/profile
	echo "JRE_HOME=/usr/local/jdk7/jre" >> /etc/profile
	echo "PATH=\$JAVA_HOME/bin:\$JRE_HOME/bin:\$PATH" >> /etc/profile
	echo "export JAVA_HOME JRE_HOME CLASS_PATH PATH" >> /etc/profile
	
	source /etc/profile
	
	if  type java >/dev/null 2>&1;  then
		echo "jdk7 install success"
	else
		echo "jdk7 install failure"
	fi
	#rm jdk-7u80-linux-x64.tar.gz
	echo "if show '-bash: java command not found', execute the following commands:"
	echo "source /etc/profile"
	cd ..
fi