#!/bin/bash
#jdk-8u171-linux-x64.tar.gz
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

#download jdk8 and install
if type java >/dev/null 2>&1; then
	echo "jdk8 has installed, java home:$JAVA_HOME"
else
	cd 'src'
	
	if [ ! -f 'jdk-8u171-linux-x64.tar.gz' ]; then
	  # download file from oracle website
	  sudo wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-linux-x64.tar.gz"
	  # download file from tencent clund
	  #sudo wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/jdk-8u171-linux-x64.tar.gz
	fi
	
	tar -zxvf jdk-8u171-linux-x64.tar.gz
	rm -rf /usr/local/jdk8
	mv jdk1.8.0_171 /usr/local/jdk8
	
	echo "modify \'/etc/profile\' file."	
	
	echo "JAVA_HOME=/usr/local/jdk8" >> /etc/profile
	echo "JRE_HOME=/usr/local/jdk8/jre" >> /etc/profile
	echo "PATH=\$JAVA_HOME/bin:\$JRE_HOME/bin:\$PATH" >> /etc/profile
	echo "export JAVA_HOME JRE_HOME CLASS_PATH PATH" >> /etc/profile
	
	source /etc/profile
	
	if  type java >/dev/null 2>&1;  then
		echo "jdk8 install success"
	else
		echo "jdk8 install failure"
	fi
	#rm jdk-8u171-linux-x64.tar.gz
	cd ..
fi