#!/bin/bash

useradd -s /bin/bash redis

workingdir='/home/redis'

cd /usr/local/src/
if [ -d /usr/local/redis/ ];
then 
  echo "redis install dir has exit,please check"
  exit 1
fi

if [ -d redis-4.0.10 ];
then
  rm -rf redis-4.0.10/
fi

wget http://download.redis.io/releases/redis-4.0.10.tar.gz
#download from tencent cloud
#https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/redis-4.0.10.tar.gz
tar -zxvf redis-4.0.10.tar.gz  
cd redis-4.0.10
make PREFIX=/usr/local/redis install 

if [ $? -ne 0 ];then
 echo "install redis failed!!!"
 exit 1
fi

  echo "install redis success!!!"

cd /usr/local/redis
cp /usr/local/src/redis-4.0.10/redis.conf ./redis.conf.bak
cp /usr/local/src/redis-4.0.10/sentinel.conf ./sentinel.conf.bak
cp /usr/local/src/redis-4.0.10/src/redis-trib.rb ./redis-trib.rb.bak

#-----for cluster ----------------------------
#mkdir cluster
#for i in {7000..7005};\
#do \
#  mkdir -p ./cluster/$i;\
#  sed -e "s/# cluster-config-file nodes-6379.conf/cluster-config-file nodes-$i.conf/g" \
#  -e "s/port 6379/port $i/g" \
#  -e "s/daemonize no/daemonize yes/g" \
#  -e "s/# cluster-enabled yes/cluster-enabled yes/g" \
#  -e "s/# cluster-enabled yes/cluster-enabled yes/g" \
#  -e "s/# cluster-enabled yes/cluster-enabled yes/g" \
#  -e "s/# cluster-node-timeout 15000/cluster-node-timeout 5000/g" \
#  -e "s/appendonly no/appendonly yes/g" \
#  -e "s#dir ./#dir /usr/local/redis/cluster/$i/#g"\
#  -e  "s#logfile \"\"#logfile \"/usr/local/redis/cluster/$i/redis_$i.log\"#g"\
#  -e "s/appendfilename \"appendonly.aof\"/appendfilename \"appendonly_$i.aof\"/g" \
#  -e "s#pidfile /var/run/redis.pid#pidfile /usr/local/redis/cluster/$i/redis_$i.pid#g" redis.conf > ./cluster/$i/redis_$i.conf;\
#done;
#

#-----for normal instance ----------------------------
cd $workingdir

for i in {6381..6383};\
do \
  mkdir -p $workingdir/$i;\
sed \
  -e "s/appendonly no/appendonly yes/g" \
  -e "s#dir ./#dir $workingdir/$i/#g"\
  -e  "s#logfile \"\"#logfile \"$workingdir/$i/redis_$i.log\"#g"\
  -e "s/appendfilename \"appendonly.aof\"/appendfilename \"appendonly_$i.aof\"/g" \
  -e "s#pidfile /var/run/redis_6379.pid#pidfile $workingdir/$i/redis_$i.pid#g" \
  -e "s/dbfilename dump.rdb/dbfilename dump_$1.rdb/g"\
  -e "s/port 6379/port $i/g" \
  -e "s/daemonize no/daemonize yes/g" \
  /usr/local/src/redis-4.0.10/redis.conf > $workingdir/$i/redis_$i.conf
done
#
#  -e "s/# masterauth <master-password>/masterauth $redis_pw/g"\
#  -e "s/# requirepass foobared/requirepass $redis_pw/g"\

  echo "generate redis_config file success!!!"


#-----for sentinel  ----------------------------
workingdir='/home/redis'
#redis_pw=000000
master_name=mymaster
master_ip=127.0.0.1
master_port=6381


cd $workingdir

for i in {26381..26383};\
do \
  mkdir -p $workingdir/$i;\
sed \
  -e "s#dir /tmp#dir $workingdir/$i/#g"\
  -e "s#port 26379#port $i \n\ndaemonize yes \nlogfile \"$workingdir/$i/sentinel_$i.log\" #g" \
  -e "s/sentinel monitor mymaster 127.0.0.1 6379 2/sentinel monitor $master_name $master_ip $master_port 2/g"\
  -e "s/mymaster/$master_name/g"\
  /usr/local/src/redis-4.0.10/sentinel.conf > $workingdir/$i/redis_sentinel_$i.conf
done
#
#  -e "s/# sentinel auth-pass <master-name> <password>/sentinel auth-pass $master_name $redis_pw/g"\

  echo "generate redis_sentinel_config file success!!!"



yum install ruby ruby-devel rubygems rpm-build -y
gem install redis
chown -R redis. /usr/local/redis
chown -R redis. /home/redis

#start redis with redis user account
su - redis -l -c '/usr/local/redis/bin/redis-server /home/redis/6381/redis_6381.conf'
su - redis -l -c '/usr/local/redis/bin/redis-server /home/redis/6382/redis_6382.conf'
su - redis -l -c '/usr/local/redis/bin/redis-server /home/redis/6383/redis_6383.conf'

/usr/local/redis/bin/redis-cli -p 6382 slaveof 127.0.0.1 6381
/usr/local/redis/bin/redis-cli -p 6383 slaveof 127.0.0.1 6381

#start redis_sentinel with redis user account
su - redis -l -c '/usr/local/redis/bin/redis-server /home/redis/26381/redis_sentinel_26381.conf --sentinel'
su - redis -l -c '/usr/local/redis/bin/redis-server /home/redis/26382/redis_sentinel_26382.conf --sentinel'
su - redis -l -c '/usr/local/redis/bin/redis-server /home/redis/26383/redis_sentinel_26383.conf --sentinel'

  echo "finished"

# ./redis-trib.rb create --replicas 1 127.0.0.1:7000 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005


