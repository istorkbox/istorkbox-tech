#!/bin/bash
#rocketmq-all-4.2.0-bin-release.zip
#http://blog.paascloud.net/2018/02/21/java-env/rocketmq/rocketmq-synchro-double-write/
#https://blog.csdn.net/lovesomnus/article/details/51769977
#https://www.jianshu.com/p/9d4e0ff358c6
#TencentCloud
#https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/rocketmq-all-4.2.0-bin-release.zip
#https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/rocketmq-all-4.3.0-bin-release.zip


###配置域名
#192.168.241.101 paascloud-rocketmq-001
#192.168.241.102 paascloud-rocketmq-002


###下载解压
cd /opt
#wget http://ftp.jaist.ac.jp/pub/apache/rocketmq/4.2.0/rocketmq-all-4.2.0-bin-release.zip
# wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/rocketmq-all-4.2.0-bin-release.zip
# unzip rocketmq-all-4.2.0-bin-release.zip -d /usr/local/rocketmq

#wget http://mirrors.hust.edu.cn/apache/rocketmq/4.3.0/rocketmq-all-4.3.0-bin-release.zip
wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/rocketmq-all-4.3.0-bin-release.zip
#unzip rocketmq-all-4.3.0-bin-release.zip -d /usr/local/rocketmq
unzip rocketmq-all-4.3.0-bin-release.zip
mv rocketmq-all-4.3.0-bin-release /usr/local/rocketmq

###配置环境变量
#vim /etc/profile
#export ROCKETMQ_HOME=/usr/local/rocketmq
#export PATH=$PATH::$ROCKETMQ_HOME/bin

echo "export ROCKETMQ_HOME=/usr/local/rocketmq" >> /etc/profile
echo "export PATH=$PATH::$ROCKETMQ_HOME/bin" >> /etc/profile
source /etc/profile


###创建存储&日志文件
mkdir -p /usr/local/rocketmq/logs

mkdir -p /usr/local/rocketmq/store
mkdir -p /usr/local/rocketmq/store/commitlog
mkdir -p /usr/local/rocketmq/store/consumequeue
mkdir -p /usr/local/rocketmq/store/inde


###修改日志配置文件
mkdir -p /usr/local/rocketmq/logs
cd /usr/local/rocketmq/conf && sed -i 's#${user.home}#/usr/local/rocketmq#g' *.xml

###修改启动脚本参数
#vim /usr/local/rocketmq/bin/runbroker.sh
#JAVA_OPT="${JAVA_OPT} -server -Xms1g -Xmx1g -Xmn512m"

#vim /usr/local/rocketmq/bin/runserver.sh
#JAVA_OPT="${JAVA_OPT} -server -Xms1g -Xmx1g -Xmn512m -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=320m"

sed -i 's#JAVA_OPT="${JAVA_OPT} -server -Xms8g -Xmx8g -Xmn4g"#JAVA_OPT="${JAVA_OPT} -server -Xms1g -Xmx1g -Xmn512m"#g' /usr/local/rocketmq/bin/runbroker.sh
sed -i 's#JAVA_OPT="${JAVA_OPT} -server -Xms4g -Xmx4g -Xmn2g -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=320m"#JAVA_OPT="${JAVA_OPT} -server -Xms1g -Xmx1g -Xmn512m -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=320m"#g' /usr/local/rocketmq/bin/runserver.sh


###替换配置文件
cd /usr/local/rocketmq/conf/2m-noslave/
mv broker-a.properties broker-a.properties.bak
mv broker-b.properties broker-b.properties.bak


###启动NameServer【两台机器】
cd /usr/local/rocketmq/bin
nohup sh mqnamesrv &


###启动BrokerServer A【192.168.1.11】
cd /usr/local/rocketmq/bin
nohup sh mqbroker -c /usr/local/rocketmq/conf/2m-noslave/broker-a.properties >/dev/null 2>&1 &
netstat -ntlp
jps
tail -f -n 500 /usr/local/rocketmq/logs/rocketmq/logs/broker.log
tail -f -n 500 /usr/local/rocketmq/logs/rocketmq/logs/namesrv.log

###启动BrokerServer B【192.168.1.12】
cd /usr/local/rocketmq/bin
nohup sh mqbroker -c /usr/local/rocketmq/conf/2m-noslave/broker-b.properties >/dev/null 2>&1 &
netstat -ntlp
jps
tail -f -n 500 /usr/local/rocketmq/logs/rocketmqlogs/broker.log
tail -f -n 500 /usr/local/rocketmq/logs/rocketmqlogs/namesrv.log


###是否启动成功
# netstat -ntlp
# jps
# tail -f -n 500 /usr/local/rocketmq/logs/rocketmq/logs/broker.log
# tail -f -n 500 /usr/local/rocketmq/logs/rocketmq/logs/namesrv.log

###查看集群监控状态
#sh /usr/local/rocketmq/bin/mqadmin clusterlist -n localhost:9876

###停止服务
# sh /usr/local/rocketmq/bin/mqshutdown namesrv
# sh /usr/local/rocketmq/bin/mqshutdown broker

###数据清理
# cd /usr/local/rocketmq/bin
# sh mqshutdown broker
# sh mqshutdown namesrv
# --等待停止
# rm -rf /usr/local/rocketmq/store
# mkdir /usr/local/rocketmq/store
# mkdir /usr/local/rocketmq/store/commitlog
# mkdir /usr/local/rocketmq/store/consumequeue
# mkdir /usr/local/rocketmq/store/index
# --按照上面步骤重启NameServer与BrokerServer

###部署RocketMQ Console
#wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/rocketmq-console-ng-1.0.0.jar

##rocketmq-console-ng.bat
#@echo off  
#java -jar rocketmq-console-ng-1.0.0.jar --server.port=12581 --rocketmq.config.namesrvAddr=123.207.70.98:9876;139.199.183.49:9876;    
#@pause
