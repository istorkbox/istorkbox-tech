#分布式文件系统FastDFS
#https://www.jianshu.com/p/1c71ae024e5e
#FastDFS-Storage安装（存储服务器）

#获取或设置FastDFS的Tracker服务器IP
echo "需手动设置-跟踪服务器IP地址"
cat $install_dir/Readme
read -p "what's FASTDFS_TRACKER_SERVER_IP ?:" FASTDFS_TRACKER_SERVER_IP
echo "FastDFS Tracker Servcie IP: $FASTDFS_TRACKER_SERVER_IP"
read -p "FastDFS Tracker Servcie IP is $FASTDFS_TRACKER_SERVER_IP yes or no:" isY
if [ "${isY}" != "y" ] && [ "${isY}" != "Y" ] && [ "${isY}" != "yes" ] && [ "${isY}" != "YES" ];then
exit 1
fi

cd /usr/local/src
install_dir=`pwd`
install_version=fastdfs-5.11
install_ip=`ip addr |grep inet |egrep -v "inet6|127.0.0.1" |awk '{print $2}' |awk -F "/" '{print $1}'`
echo "当前目录为:$install_dir"
echo "当前版本为:$install_version"
echo "当前本机IP:$install_ip"

#安装 libfastcommon、perl依赖，下载libfastcommon-master.zip，上传到服务器的/usr目录下。
yum -y install gcc automake autoconf libtool make 
yum -y install perl make cmake gcc gcc-c++
cd /usr/local/src
wget -c https://github.com/happyfish100/libfastcommon/archive/V1.0.36.tar.gz -O libfastcommon-1.0.36.tar.gz
# download from tencent cloud
#wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/libfastcommon-1.0.36.tar.gz
tar -zxvf libfastcommon-1.0.36.tar.gz
cd libfastcommon-1.0.36
./make.sh
./make.sh install

#编译安装fastdfs
cd /usr/local/src
wget -c https://github.com/happyfish100/fastdfs/archive/V5.11.tar.gz -O fastdfs-5.11.tar.gz
# download from tencent cloud
#wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/fastdfs-5.11.tar.gz
tar -zxvf fastdfs-5.11.tar.gz
mv fastdfs-5.11 /usr/local/fastdfs
cd /usr/local/fastdfs
./make.sh
./make.sh install

#fastDFS命令目录：/usr/bin
#fastDFS配置文件目录:/etc/fdfs
#创建fastdfs数据目录
mkdir -pv /data/fastdfs/storage

#配置tracker
#修改tracker.conf中的 base_path=/data/fastdfs/tracker，即刚才配置的数据文件目录
cp -f /etc/fdfs/storage.conf.sample /etc/fdfs/storage.conf
#vi  etc/fdfs/storage.conf
sed -i "s#base_path=/home/yuqing/fastdfs#base_path=/data/fastdfs/storage#g" /etc/fdfs/storage.conf
sed -i "s#store_path0=/home/yuqing/fastdfs#store_path0=/data/fastdfs/storage#g" /etc/fdfs/storage.conf
sed -i "s#tracker_server=192.168.209.121:22122#tracker_server=$FASTDFS_TRACKER_SERVER_IP:22122#g" /etc/fdfs/storage.conf

#启动FASTDFS
cd /usr/bin
/usr/bin/fdfs_storaged /etc/fdfs/storage.conf restart

#验证
#root     15959     1  0 11:46 ?        00:00:00 /usr/bin/fdfs_storaged /etc/fdfs/storage.conf restart
ps -ef|grep fdfs_storaged

echo "FastDFS-Storage停止:killall fdfs_storaged"

echo "FastDFS-Storage服务器IP:$install_ip"

##停止
#直接kill即可让server进程正常退出或可以使用killall命令 
# killall fdfs_storaged 
#使用FastDFS自带的stop.sh脚本
# /usr/bin/stop.sh /usr/bin/fdfs_storaged /etc/fdfs/storage.conf