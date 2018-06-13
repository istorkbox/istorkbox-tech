#!/bin/bash
#node-v9.9.0-linux-x64.tar.gz
#文件来自阿里云镜像
#https://npm.taobao.org/mirrors/node
#https://npm.taobao.org/mirrors/node/v9.9.0/node-v9.9.0-linux-x64.tar.gz

if type wget >/dev/null 2>&1; then
	echo '...'
else
	echo 'start install wget'
	yum -y install wget
fi

#download node and intall
cd /usr/local/
if [ ! -d 'src' ]; then
  mkdir 'src'
fi


#download node and install
if type node >/dev/null 2>&1; then
 echo "node has installed"
else
	cd 'src'
	wget https://npm.taobao.org/mirrors/node/v9.9.0/node-v9.9.0-linux-x64.tar.gz
	#download from tencent cloud
	#wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/node-v9.9.0-linux-x64.tar.gz
	tar -zxvf node-v9.9.0-linux-x64.tar.gz
	mv node-v9.9.0-linux-x64 /usr/local/node
	echo "export PATH=/usr/local/node/bin:\$PATH" >> /etc/profile
	source /etc/profile
	if  type node >/dev/null 2>&1;  then
		if  type npm >/dev/null 2>&1;  then
			echo "node install success"
		else
			echo "node install failure"
		fi
	else
		echo "node install failure"
	fi
	rm node-v9.9.0-linux-x64.tar.gz
	cd ..
fi