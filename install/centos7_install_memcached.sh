#!/bin/bash
#memcached-1.5.8.tar.gz
#安装文件镜像
#https://memcached.org/files/memcached-1.5.8.tar.gz
#https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/memcached-1.5.8.tar.gz
if type wget >/dev/null 2>&1; then
	echo '...'
else
	echo 'start install wget'
	yum -y install wget
fi

#install lib
yum -y install libevent
yum -y install libevent-devel

#check dir
cd /usr/local/
if [ ! -d 'src' ]; then
	mkdir 'src'
fi
cd /usr/local/src

#download memcached and install
if type memcached >/dev/null 2>&1; then
	echo "memcached has installed"	
else
	wget https://memcached.org/files/memcached-1.5.8.tar.gz
	#download from tencent cloud
	#wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/memcached-1.5.8.tar.gz
	tar -zxvf memcached-1.5.8.tar.gz
	cd memcached-1.5.8
	rm -rf /usr/local/memcached
	./configure --prefix=/usr/local/memcached && make && sudo make install
	
	if type memcached >/dev/null 2>&1;  then
		echo "memcached install success"
	else
		echo "memcached install failure"
	fi
	
	cd /usr/local/src
	rm memcached-1.5.8.tar.gz
fi

#cd /usr/local/memcached/bin

#./memcached -d -m 2048 -l 127.0.0.1 -p 11211 -u root -c 1024 –P /var/memcached/memcached.pid
