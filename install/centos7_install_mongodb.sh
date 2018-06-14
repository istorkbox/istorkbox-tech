#!/bin/bash
#mongodb-linux-x86_64-3.6.5.tgz
#https://blog.csdn.net/rzrenyu/article/details/79472508
#https://www.cnblogs.com/zhoujinyi/p/4610050.html

#下载 mongodb
#安装包放在/usr/local/src目录里
cd /usr/local/src

if [ ! -f 'mongodb-linux-x86_64-3.6.5.tgz' ]; then
    #wget http://downloads.mongodb.org/linux/mongodb-linux-x86_64-3.6.5.tgz
    #download from tencent cloud
    wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/mongodb-linux-x86_64-3.6.5.tgz
fi

sleep 5s

#解压和编译
#解压下载的源码包
tar -zvxf mongodb-linux-x86_64-3.6.5.tgz

#移动到指定位置
rm -rf /usr/local/mongodb
mv mongodb-linux-x86_64-3.6.5/ /usr/local/mongodb

#在/usr/local/mongodb下创建文件夹
cd /usr/local/mongodb
mkdir -p data/db
mkdir logs

#在/usr/local/mongodb/bin下新建配置mongodb.conf
cd /usr/local/mongodb/bin

sudo tee /usr/local/mongodb/bin/mongodb.conf <<-'EOF'
dbpath = /usr/local/mongodb/data/db #数据文件存放目录
logpath = /usr/local/mongodb/logs/mongodb.log #日志文件存放目录
port = 27017 #端口
fork = true #以守护程序的方式启用，即在后台运行
auth=true
bind_ip=0.0.0.0
EOF

#环境变量配置
echo "modify \'/etc/profile\' file."	
echo "export MONGODB_HOME=/usr/local/mongodb" >> /etc/profile
echo "export PATH=\$PATH:\$MONGODB_HOME/bin" >> /etc/profile

#生效环境变量
source /etc/profile

cd /usr/local/mongodb/bin

mongod -f mongodb.conf

#此时我们能查看 mongodb 版本号，说明我们已经安装成功了。
mongo -version

