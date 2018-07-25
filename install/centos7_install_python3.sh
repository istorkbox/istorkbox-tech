#!/bin/bash
#Python-3.7.0.tar.xz
#安装文件镜像
#https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tar.xz
#https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/Python-3.7.0.tar.xz
#https://blog.csdn.net/u010510962/article/details/80690084


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

#download python3 and install
if [ ! -d '/usr/local/python3' ] then
	echo "python3 has installed"	
else
	yum groupinstall 'Development Tools' 
	yum install -y zlib-devel bzip2-devel openssl-devel ncurese-devel 
	yum install -y openssl-devel
	
	wget https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tar.xz
	#download from tencent cloud
	#wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/Python-3.7.0.tar.xz
	
	tar Jxvf Python-3.7.0.tar.xz
	cd /usr/local/src/Python-3.7.0
	./configure --prefix=/usr/local/python3.7 
	make && make install 
	
	#建立指向新python3和pip3的软链接
	ln -s /usr/local/python3/bin/python3.7 /usr/bin/python 
	ln -s /usr/local/python3/bin/pip3 /usr/bin/pip 

	#检查python和pip版本 
	python --version
	pip --version
	
##pip: command not found
##参考链接https://www.quora.com/How-to-fix-%E2%80%9Cpip-command-not-found%E2%80%9D 
##出现这个的原因一般有两个： 
#1. 未安装pip 
#2. pip安装了，但是没有配置$PATH环境变量
#如果是第二个原因，此时echo $PATH 查看pip的安装目录是否在PATH中，如果没有，在~/.bash_profile中添加export PATH=$PATH:/usr/local/bin（假设pip的安装目录为/usr/local/bin）然后source ~/.bash_profile使之生效。
