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
install_version=nginx
install_ip=`ip addr |grep inet |egrep -v "inet6|127.0.0.1" |awk '{print $2}' |awk -F "/" '{print $1}'`
echo "当前目录为:$install_dir"
echo "当前版本为:$install_version"
echo "当前本机IP:$install_ip"

#安装 libfastcommon、perl依赖，下载libfastcommon-master.zip，上传到服务器的/usr目录下。
yum -y install gcc automake autoconf libtool make 
yum -y install perl make cmake gcc gcc-c++
yum -y install pcre* zlib openssl openssl-devel
 
cd /usr/local/src
#download from tencent cloud
wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/fastdfs-nginx-module_v1.16.zip
unzip fastdfs-nginx-module_v1.16.zip
cd libfastcommon-1.0.36
./make.sh
./make.sh install


#download nginx
if [ ! -f 'nginx-1.15.0.tar.gz' ]; then
    wget http://nginx.org/download/nginx-1.15.0.tar.gz
    #download from tencent cloud
    #wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/nginx-1.15.0.tar.gz
fi

sleep 5s

#解压：
tar zxvf nginx-1.15.0.tar.gz

#进入解压后目录：
cd /usr/local/src/nginx-1.15.0

./configure --prefix=/usr/local/nginx --add-module=/usr/local/src/fastdfs-nginx-module/src

make && make install

cp ../fastdfs-nginx-module-master/src/mod_fastdfs.conf  /etc/fdfs/


#配置mod_fastdfs.conf
cp /usr/local/src/fastdfs-nginx-module/src/mod_fastdfs.conf  /etc/fdfs/

sed -i "s#base_path=/tmp#base_path=/data/fastdfs/storage#g" /etc/fdfs/mod_fastdfs.conf
sed -i "s#tracker_server=tracker:22122#tracker_server=203.195.224.20:22122#g" /etc/fdfs/mod_fastdfs.conf
sed -i "s#url_have_group_name = false#url_have_group_name = true#g" /etc/fdfs/mod_fastdfs.conf
sed -i "s#store_path0=/home/yuqing/fastdfs#store_path0=/data/fastdfs/storage#g" /etc/fdfs/mod_fastdfs.conf

echo "[group1]" >> /etc/fdfs/mod_fastdfs.conf
echo "group_name=group1" >> /etc/fdfs/mod_fastdfs.conf
echo "storage_server_port=23000" >> /etc/fdfs/mod_fastdfs.conf
echo "store_path_count=1" >> /etc/fdfs/mod_fastdfs.conf
echo "store_path0=/data/fastdfs/storage" >> /etc/fdfs/mod_fastdfs.conf

#nginx.conf
cd /usr/local/src/
wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/fastdfs/nginx.conf
cp -rf /usr/local/nginx/conf/nginx.conf /usr/local/nginx/conf/nginx.conf.bak
rm -rf /usr/local/nginx/conf/nginx.conf
cp -rf /usr/local/src/nginx.conf /usr/local/nginx/conf/nginx.conf

#停止防火墙或是把 80 端口加入到的排除列表：
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --reload

#启动nginx,启动完成 shell 是不会有输出的
/usr/local/nginx/sbin/nginx

#检查 Nginx 是否启动并监听了80端口：
netstat -ntulp | grep 80

##检查 Nginx 启用的配置文件是哪个：
# /usr/local/nginx/sbin/nginx -t

##刷新 Nginx 配置后重启：
# /usr/local/nginx/sbin/nginx -s reload

##停止 Nginx：
# /usr/local/nginx/sbin/nginx -s stop

##如果访问不了，或是出现其他信息看下错误立即：
# vim /var/log/nginx/error.log
