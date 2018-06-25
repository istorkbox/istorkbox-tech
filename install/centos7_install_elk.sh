#!/bin/bash

#jdk-8u171-linux-x64.tar.gz
#elasticsearch-6.2.2.tar.gz
#logstash-6.2.2.tar.gz
#kibana-6.2.2-linux-x86_64.tar.gz
#https://github.com/istorkbox/istorkbox-tech/blob/master/install/centos7_install_jdk8.sh
#https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.2.2.tar.gz
#https://artifacts.elastic.co/downloads/logstash/logstash-6.2.2.tar.gz
#https://artifacts.elastic.co/downloads/kibana/kibana-6.2.2-linux-x86_64.tar.gz
#https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.2.2-linux-x86_64.tar.gz

#删除原来有的elk目录
rm -rf /usr/local/elk*

#安装说明
cd /usr/local/src
mkdir /usr/local/elk
install_dir=`pwd`
install_version=elk-6.2.2
install_ip=`ip addr |grep inet |egrep -v "inet6|127.0.0.1" |awk '{print $2}' |awk -F "/" '{print $1}'`
elk_dir=/usr/local/elk
echo "当前目录为:$install_dir"
echo "当前版本为:$install_version"
echo "当前本机IP:$install_ip"


#卸载系统自带JDK
# rpm -qa | grep java
##如返回列表:
##tzdata-java-2014g-1.el6.noarch
##java-1.6.0-openjdk-1.6.0.0-11.1.13.4.el6.x86_64
##java-1.7.0-openjdk-1.7.0.65-2.5.1.2.el6_5.x86_64
##.noarch结尾文件可不删除

# rpm -e --nodeps java-1.6.0-openjdk-1.6.0.0-11.1.13.4.el6.x86_64
# rpm -e --nodeps java-1.6.0-openjdk-1.6.0.0-11.1.13.4.el6.x86_64

#安装rz/sz命令等
yum install -y lrzsz vim wget

echo "安装JDK8"
#安装JDK8
wget https://github.com/istorkbox/install/raw/master/centos7_jdk8.sh && sh centos7_jdk8.sh;

#更新配置：
source /etc/profile 
#查看是否安装成功：
java -version

echo "安装Elasticsearch"
#安装Elasticsearch
#我的ELK搭建笔记（阿里云上部署）
#https://mp.weixin.qq.com/s?__biz=MzI5ODE0ODA5MQ==&mid=504794250&idx=1&sn=529e0320fbbcda06beca1a7262c10c45&chksm=7748651e403fec088bae8f7f6f5cc79e3f8f961a3f8a960807f688c21443e7bad5ed98e0cccf&mpshare=1&scene=1&srcid=0321XQ2wS5rWnUdIPBw9Zdce#rd
#https://www.elastic.co/guide/en/elasticsearch/reference/current/zip-targz.html
#https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.2.2.tar.gz

#下载完成后解压tar包
cd $install_dir 

if [ ! -f 'elasticsearch-6.2.2.tar.gz' ]; then
	#wget -c https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.2.2.tar.gz
	#download file from tencent clund
	sudo wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/elasticsearch-6.2.2.tar.gz
fi

tar -zxvf elasticsearch-6.2.2.tar.gz
mv elasticsearch-6.2.2 /usr/local/elk/elasticsearch-6.2.2

#切换到elasticsearch目录
cd /usr/local/elk/elasticsearch-6.2.2

#安装x-pack
#bin/elasticsearch-plugin install x-pack

#创建elk用户(密码123456),elasticsearch不允许用root用户运行
#增加elk组
#增加elk用户并附加到elk组
#给目录权限
#后台运行elk
groupadd elk          
useradd elk -g elk -p 123456 
cd /usr/local/elk         
chown -R elk:elk elasticsearch-6.2.2  

#修改一些配置,防止启动报错        
echo "soft nproc 165536" >> /etc/security/limits.conf
echo "hard nproc 165536" >> /etc/security/limits.conf
echo "vm.max_map_count=262144" >> /etc/sysctl.conf 
echo "vm.max_map_count=262144" >> /etc/sysctl.conf 
sysctl -p

#修改elasticsearch本身配置
#/usr/local/elk/elasticsearch-6.2.2/config/elasticsearch.yml       

mkdir -pv /usr/local/elk_data/elasticsearch/data
mkdir -pv /usr/local/elk_data/elasticsearch/logs
chown -R elk:elk /usr/local/elk_data  

echo "# 集群的名字
cluster.name: elk-pro
# 节点名字
node.name: elk-pro-node-1
# 数据存储目录（多个路径用逗号分隔）
path.data: /usr/local/elk_data/elasticsearch/data
# 日志目录  
path.logs: /usr/local/elk_data/elasticsearch/logs 
# 本机的ip地址
network.host: $install_ip  
# 监听端口（默认）  
http.port: 9200
# 设置集群中master节点的初始列表，可以通过这些节点来自动发现新加入集群的节点
discovery.zen.ping.unicast.hosts: ["$install_ip"]
# 开放外网访问
network.bind_host: 0.0.0.0
bootstrap.system_call_filter: false" >> /usr/local/elk/elasticsearch-6.2.2/config/elasticsearch.yml

su - elk -c '/usr/local/elk/elasticsearch-6.2.2/bin/elasticsearch -d'   

ps -ef|grep elasticsearch

curl http://127.0.0.1:9200/

#会响应类似,如果报错看日志
#{
#  "name" : "Z1wh4be",
#  "cluster_name" : "elasticsearch",
#  "cluster_uuid" : "zCQJdlQkQx2lU5fCgFv2Rw",
#  "version" : {
#    "number" : "6.2.2",
#    "build_hash" : "10b1edd",
#    "build_date" : "2018-02-16T19:01:30.685723Z",
#    "build_snapshot" : false,
#    "lucene_version" : "7.2.1",
#    "minimum_wire_compatibility_version" : "5.6.0",
#    "minimum_index_compatibility_version" : "5.0.0"
#  },
#  "tagline" : "You Know, for Search"
#}

#elasticsearch-head插件安装
#http://blog.csdn.net/laoyang360/article/details/51472821

#如果在外部不能访问,主要原因在于防火墙的存在，导致的端口无法访问。
#CentOS7使用firewall而不是iptables。所以解决这类问题可以通过添加firewall的端口，使其对我们需要用的端口开放。
#1.使用命令  firewall-cmd --state查看防火墙状态。得到结果是running或者not running
#2.在running 状态下，向firewall 添加需要开放的端口
#命令为 firewall-cmd --permanent --zone=public --add-port=8080/tcp //永久的添加该端口。去掉--permanent则表示临时。
#4.firewall-cmd --reload //加载配置，使得修改有效。
#5.使用命令 firewall-cmd --permanent --zone=public --list-ports //查看开启的端口，出现8080/tcp这开启正确
#6.再次使用外部浏览器访问，这出现信息界面。
firewall-cmd --zone=public --list-ports
firewall-cmd --zone=public --add-port=9200/tcp
firewall-cmd --zone=public --add-port=5606/tcp
firewall-cmd --reload


#关闭防火墙：
#临时关闭
systemctl stop firewalld
#禁止开机启动
systemctl disable firewalld

##开启防火墙的命令
# systemctl start firewalld.service
##关闭防火墙的命令
# systemctl stop firewalld.service
##开机自动启动
# systemctl enable firewalld.service
##关闭开机自动启动
# systemctl disable firewalld.service
##查看防火墙状态
# systemctl status firewalld
		
#在虚拟机上安装了zookeeper与elasticsearch，在本机可以正常访问zookeeper，但elasticsearch则无法正常访问。	telnet 9200 端口也不同。
#查看虚拟机端口情况如下：	
netstat -ap | grep 9200

##启动失败
##[1]: max file descriptors [4096] for elasticsearch process is too low, increase to at least [65536]
##[2]: max number of threads [1024] for user [elk] is too low, increase to at least [4096]
##[3]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
##http://blog.csdn.net/lijiaz5033/article/details/73614617

##[1]: max file descriptors [4096] for elasticsearch process is too low, increase to at least [65536]
##原因：无法创建本地文件问题,用户最大可创建文件数太小
##解决方案：切换到root用户，编辑limits.conf配置文件， 添加类似如下内容：
# vi /etc/security/limits.conf
##添加如下内容:
# * soft nofile 165536
# * hard nofile 131072
# * soft nproc 165536
# * hard nproc 165536

##[2]: max number of threads [3884] for user [elk] is too low, increase to at least [4096]
##原因：无法创建本地线程问题,用户最大可创建线程数太小
##解决方案：切换到root用户，进入limits.d目录下，修改90-nproc.conf 配置文件。
##vi /etc/security/limits.d/90-nproc.conf
##找到如下内容：
# * soft nproc 1024
##修改为
# * soft nproc 2048

##[3]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
##原因：最大虚拟内存太小
##解决办法： 
##切换到root用户修改配置sysctl.conf
#vi /etc/sysctl.conf 
##添加下面配置：
# vm.max_map_count=655360
# vm.max_map_count=655360
##或者
# vm.max_map_count=262144
# vm.max_map_count=262144
##并执行命令：
# sysctl -p
##然后，重新启动elasticsearch，即可启动成功。



echo "安装Logstash"
#安装Logstash
#https://www.elastic.co/guide/en/logstash/current/installing-logstash.html#package-repositories
#https://artifacts.elastic.co/downloads/logstash/logstash-6.2.2.tar.gz

#下载完成后解压tar包 
cd $install_dir 

if [ ! -f 'logstash-6.2.2.tar.gz' ]; then
	#wget -c https://artifacts.elastic.co/downloads/logstash/logstash-6.2.2.tar.gz
	#download file from tencent clund
	sudo wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/logstash-6.2.2.tar.gz
fi

tar -zxvf logstash-6.2.2.tar.gz
mv logstash-6.2.2 /usr/local/elk/logstash-6.2.2
cd /usr/local/elk/logstash-6.2.2

#测试一段syslog日志文本。在logstash主目录创建配置文件sample.conf，内容如下
echo 'input {
	stdin {
		type => "syslog"
	}
}
filter {

}
output {
	elasticsearch {
		hosts => "http://127.0.0.1:9200" 
	}
	
	stdout {
		codec => rubydebug
	}
}' >> /usr/local/elk/logstash-6.2.2/sample.conf

##或者
#input { stdin { } }
#output {
#	elasticsearch { hosts => ["127.0.0.1:9200"] }
#	stdout { codec => rubydebug }
#}

#chown -R elk:elk logstash-6.2.2

#启动Logstash
cd /usr/local/elk/logstash-6.2.2
#bin/logstash -f sample.conf
#/usr/local/elk/logstash-6.2.2/bin/logstash -f sample.conf   
#sleep 15

# ps -ef|grep logstash


#安装Kibana
#https://www.elastic.co/guide/en/kibana/current/install.html
#https://artifacts.elastic.co/downloads/kibana/kibana-6.2.2-linux-x86_64.tar.gz
#下载完成后解压tar包 
cd /usr/local/src
if [ ! -f 'kibana-6.2.2-linux-x86_64.tar.gz' ]; then
	#wget -c https://artifacts.elastic.co/downloads/kibana/kibana-6.2.2-linux-x86_64.tar.gz
	#download file from tencent clund
	sudo wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/kibana-6.2.2-linux-x86_64.tar.gz
fi

tar -zxvf kibana-6.2.2-linux-x86_64.tar.gz
mv kibana-6.2.2-linux-x86_64 /usr/local/elk/kibana-6.2.2
cd /usr/local/elk/kibana-6.2.2
#chown -R elk:elk kibana-6.2.2

#配置config/kibana.yml
cd /usr/local/elk/kibana-6.2.2
echo "#配置elasticsearch地址
elasticsearch.url: "http://127.0.0.1:9200"
#配置让外部可以访问
server.host: \"0.0.0.0\"" >> /usr/local/elk/kibana-6.2.2/config/kibana.yml

#su elk
#nohup /usr/local/elk/kibana-6.2.2/bin/kibana 

#curl http://127.0.0.1:5601


#安装Filebeat
#https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.2.2-linux-x86_64.tar.gz

cd /usr/local/src
if [ ! -f 'filebeat-6.2.2-linux-x86_64.tar.gz' ]; then
	#wget -c https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.2.2-linux-x86_64.tar.gz
	#download file from tencent clund
	sudo wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/filebeat-6.2.2-linux-x86_64.tar.gz
fi

tar -zxvf filebeat-6.2.2-linux-x86_64.tar.gz
mv filebeat-6.2.2-linux-x86_64 /usr/local/filebeat-6.2.2
cd /usr/local/filebeat-6.2.2

#/usr/local/filebeat-6.2.2/filebeat -e -c filebeat.yml -d "publish"

#start logstash
echo 'sleep some time, logstash start slow'
/usr/local/elk/logstash-6.2.2/bin/logstash -f sample.conf   
sleep 15

#start logstash(don't use 'Ctrl+C' close shell window, use 'exit' leave)
nohup /usr/local/elk/kibana-6.2.2/bin/kibana &

#start filebeat
/usr/local/filebeat-6.2.2/filebeat -e -c filebeat.yml -d "publish"



##-------------------------------------------------------
## stop firewall
# systemctl stop firewalld.service

## elasticsearch start
# /usr/local/elk/elasticsearch-6.2.2/bin/elasticsearch

## kibana start
# /usr/local/elk/kibana-6.2.2/bin/kibana

## logstash start
# /usr/local/elk/logstash-6.2.2/bin/logstash -f cfg_product_log.conf

##linux filebeat start
# /usr/local/filebeat-6.2.2/filebeat -e -c filebeat.yml

##window filebeat start
# D:
# cd D:\Software\elk\filebeat-6.2.2-windows-x86_64\
# filebeat.exe -e -c filebeat.yml -d "publish"

##-------------------------------------------------------
