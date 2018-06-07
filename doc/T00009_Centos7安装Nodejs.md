Centos7安装Nodejs

- 用脚本一键进行安装(v9.9.0)

  文件来自阿里云镜像
  
  https://npm.taobao.org/mirrors/node
  
  https://npm.taobao.org/mirrors/node/v9.9.0/node-v9.9.0-linux-x64.tar.gz

```
  cd /opt
  touch nodeinstall.sh
  vi nodeinstall.sh
  sh nodeinstall.sh 
```  

- 安装脚本`nodeinstall.sh`

```shell
echo 'start install node'
#install wget
#https://blog.csdn.net/ithomer/article/details/9288353

if type wget >/dev/null 2>&1; then
	echo '...'
else
	echo 'start install wget'
	yum -y install wget
fi

#download node and intall
if [ ! -d 'downloads' ]; then
  mkdir 'downloads'
fi


#download node and install
if type node >/dev/null 2>&1; then
 echo "node has installed"
else
	cd 'downloads'
	wget https://npm.taobao.org/mirrors/node/v9.9.0/node-v9.9.0-linux-x64.tar.gz
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
```