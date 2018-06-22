#分布式文件系统FastDFS
#https://www.jianshu.com/p/1c71ae024e5e
#FastDFS-Tracker安装（跟踪服务器）

cd /usr/local/src
install_dir=`pwd`
install_version=fastdfs-5.11
install_ip=`ip addr |grep inet |egrep -v "inet6|127.0.0.1" |awk '{print $2}' |awk -F "/" '{print $1}'`
echo "当前目录为:$install_dir"
echo "当前版本为:$install_version"
echo "本机ip为:$install_ip"

#安装 libfastcommon、perl依赖，下载libfastcommon-master.zip，上传到服务器的/usr目录下。
yum -y install perl gcc
cd /usr/local/src
wget -c https://github.com/happyfish100/libfastcommon/archive/V1.0.36.tar.gz -O libfastcommon-1.0.36.tar.gz
tar -zxvf libfastcommon-1.0.36.tar.gz
cd libfastcommon-1.0.36
./make.sh
./make.sh install

#编译安装fastdfs
cd /usr/local/src
wget -c https://github.com/happyfish100/fastdfs/archive/V5.11.tar.gz -O fastdfs-5.11.tar.gz
tar -zxvf fastdfs-5.11.tar.gz
mv fastdfs-5.11 /usr/local/fastdfs
cd /usr/local/fastdfs
./make.sh
./make.sh install

#fastDFS命令目录：/usr/bin
#fastDFS配置文件目录:/etc/fdfs
#创建fastdfs数据目录
mkdir -pv /data/fastdfs/tracker

#配置tracker
#修改tracker.conf中的 base_path=/data/fastdfs/tracker，即刚才配置的数据文件目录
cp -f /etc/fdfs/tracker.conf.sample /etc/fdfs/tracker.conf
#vi  etc/fdfs/tracker.conf
sed -i "s#base_path=/home/yuqing/fastdfs#base_path=/data/fastdfs/tracker#g" /etc/fdfs/tracker.conf

#启动FASTDFS
cd /usr/bin
/usr/bin/fdfs_trackerd /etc/fdfs/tracker.conf restart

#验证，默认端口是22122
#tcp        0      0 0.0.0.0:22122           0.0.0.0:*               LISTEN      31046/fdfs_trackerd
netstat -antp|grep fdfs_trackerd

echo "FastDFS-Tracker停止:killall fdfs_trackerd"

echo "对于FastDFS-Storage安装时,需手动输入tracker的IP为(即:FASTDFS_TRACKER_SERVER_IP): $install_ip"

##停止
#直接kill即可让server进程正常退出或可以使用killall命令 
# killall fdfs_trackerd 
#使用FastDFS自带的stop.sh脚本
# /usr/bin/stop.sh /usr/local/bin/fdfs_trackerd /etc/fdfs/tracker.conf