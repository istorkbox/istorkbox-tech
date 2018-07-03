#!/bin/bash

#ActiveMQ
#https://blog.csdn.net/u011325787/article/details/51421112
#http://apache.fayea.com/activemq/5.13.5/apache-activemq-5.13.5-bin.tar.gz


#环境说明
cd /usr/local/src
install_dir=`pwd`
install_version=activemq-5.13.5
install_ip=`ip addr |grep inet |egrep -v "inet6|127.0.0.1" |awk '{print $2}' |awk -F "/" '{print $1}'`
echo "当前目录为:$install_dir"
echo "当前版本为:$install_version"
echo "当前本机IP:$install_ip"


#安装依赖
yum -y install gcc gcc-c++ automake autoconf libtool make cmake
yum -y install perl pcre* zlib openssl openssl-devel pcre pcre-devel

#download activemq
cd /usr/local/src
if [ ! -f 'apache-activemq-5.13.5-bin.tar.gz' ]; then
    wget http://apache.fayea.com/activemq/5.13.5/apache-activemq-5.13.5-bin.tar.gz
    #download from tencent cloud
    #wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/apache-activemq-5.13.5-bin.tar.gz
fi
sleep 5s


#解压编译
tar -zxvf apache-activemq-5.13.5-bin.tar.gz
rm -rf /usr/local/activemq-5.13.5
mv apache-activemq-5.13.5 /usr/local/activemq-5.13.5


#安全配置（消息安全）
#ActiveMQ 如果不加入安全机制的话，任何人只要知道消息服务的具体地址(包括 ip，端口，消息地址
#[队列或者主题地址]，)， 都可以肆无忌惮的 发送、 接收消息。 关 于 ActiveMQ 安装配置
http://activemq.apache.org/security.html
cp -rf /usr/local/activemq-5.13.5/conf/activemq.xml /usr/local/activemq-5.13.5/conf/activemq.xml.bak
cp -rf /usr/local/activemq-5.13.5/conf/jetty.xml /usr/local/activemq-5.13.5/conf/jetty.xml.bak
cp -rf /usr/local/activemq-5.13.5/conf/jetty-realm.properties /usr/local/activemq-5.13.5/conf/jetty-realm.properties.bak

cd /usr/local/src
wget https://github.com/istorkbox/istorkbox-tech/raw/master/install/activemq-5.13.5/activemq.xml
#wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/activemq-5.13.5/activemq.xml

wget https://github.com/istorkbox/istorkbox-tech/raw/master/install/activemq-5.13.5/jetty-realm.properties
#wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/activemq-5.13.5/jetty-realm.properties

rm -rf /usr/local/activemq-5.13.5/conf/activemq.xml
rm -rf /usr/local/activemq-5.13.5/conf/jetty-realm.properties
cp -rf /usr/local/src/activemq.xml /usr/local/activemq-5.13.5/conf/activemq.xml
cp -rf /usr/local/src/jetty-realm.properties /usr/local/activemq-5.13.5/conf/jetty-realm.properties


##/usr/local/activemq-5.13.5/conf/jetty.xml可修改控制台端口
# <property name="port" value="8161"/>


#启动
cd /usr/local/activemq-5.13.5
/usr/local/activemq-5.13.5/bin/activemq start


#检查 activemq 是否启动并监听了80端口：
netstat -ntulp | grep 8161

#默认密码admin/admin
curl http://$install_ip:8161
echo "访问的地址http://$install_ip:8888";


##如果启动失败,异常信息类似:
##"Failed to start Apache ActiveMQ ([localhost, ID:VM_0_17_centos-44678-1530601945884-0:1], java.net.URISyntaxException: 
##Illegal character in hostname at index 7: ws://VM_0_17_centos:61614?maximumConnections=1000&wireFormat.maxFrameSize=104857600) | org.apache.activemq.broker.BrokerService | main"
##修改主机名,中间不要有下划线"_"
# vi /etc/hostname
# vi /etc/hosts
# vi /etc/sysconfig/network

##停止
# /usr/local/activemq-5.13.5/bin/activemq stop

##控制台启动
# /usr/local/activemq-5.13.5/bin/activemq console

##重启activemq
# /usr/local/activemq-5.13.5/bin/activemq restart

##如果访问不了，或是出现其他信息看下错误立即：
# vi /var/log/activemq/error.log