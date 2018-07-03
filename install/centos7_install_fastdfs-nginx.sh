#分布式文件系统FastDFS
#https://www.jianshu.com/p/1c71ae024e5e
#https://blog.csdn.net/xyang81/article/details/52837974
#FastDFS-Storage安装（存储服务器）-Nginx


##注意事项
#当前FastDFS-Storage和Nginx的http默认端口是8888
#8888端口是FastDFS-Storage与Nginx对应,下面两个文件:
# /etc/fdfs/storage.conf的http.server_port=8888
# /usr/local/nginx/conf/nginx.conf的listen 8888;
##如果要修改为80, 上面两个要一起修改

yum -y update

#获取或设置FastDFS的Tracker服务器IP
echo "需手动设置-跟踪服务器IP地址"
cat $install_dir/Readme
read -p "what's FASTDFS_TRACKER_SERVER_IP ?:" FASTDFS_TRACKER_SERVER_IP
echo "FastDFS Tracker Servcie IP: $FASTDFS_TRACKER_SERVER_IP"
read -p "FastDFS Tracker Servcie IP is $FASTDFS_TRACKER_SERVER_IP yes or no:" isY
if [ "${isY}" != "y" ] && [ "${isY}" != "Y" ] && [ "${isY}" != "yes" ] && [ "${isY}" != "YES" ];then
exit 1
fi


#环境说明
cd /usr/local/src
install_dir=`pwd`
install_version=nginx-1.15.0
install_ip=`ip addr |grep inet |egrep -v "inet6|127.0.0.1" |awk '{print $2}' |awk -F "/" '{print $1}'`
echo "当前目录为:$install_dir"
echo "当前版本为:$install_version"
echo "当前本机IP:$install_ip"


#安装依赖
yum -y install gcc gcc-c++ automake autoconf libtool make cmake
yum -y install perl pcre* zlib openssl openssl-devel pcre pcre-devel


cd /usr/local/src
wget https://jaist.dl.sourceforge.net/project/fastdfs/FastDFS%20Nginx%20Module%20Source%20Code/fastdfs-nginx-module_v1.16.tar.gz
#download from tencent cloud
# wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/fastdfs-nginx-module_v1.16.tar.gz


## 腾讯云上传的重新打包的文件已经修复./fastdfs-nginx-module/src/config,便于nginx编译不报错
## CORE_INCS="$CORE_INCS /usr/local/include/fastdfs /usr/local/include/fastcommon/" 修改为 CORE_INCS="$CORE_INCS /usr/include/fastdfs /usr/include/fastcommon/"
# wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/fastdfs-nginx-module_v1.16.zip
if [ -f 'fastdfs-nginx-module_v1.16.zip' ]; then
	unzip fastdfs-nginx-module_v1.16.zip
else
	tar -zxvf fastdfs-nginx-module_v1.16.tar.gz
	#如果是网上下载的原始文件,修改fastdfs-nginx-module的config 配置文件
	sed -i "s#CORE_INCS=\"\$CORE_INCS /usr/local/include/fastdfs /usr/local/include/fastcommon/\"#CORE_INCS=\"\$CORE_INCS /usr/include/fastdfs /usr/include/fastcommon/\"#g" /usr/local/src/fastdfs-nginx-module/src/config
fi


#download nginx
if [ ! -f 'nginx-1.15.0.tar.gz' ]; then
    wget http://nginx.org/download/nginx-1.15.0.tar.gz
    #download from tencent cloud
    #wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/nginx-1.15.0.tar.gz
fi

sleep 5s


#解压编译
tar -zxvf nginx-1.15.0.tar.gz
cd /usr/local/src/nginx-1.15.0
./configure --prefix=/usr/local/nginx --add-module=/usr/local/src/fastdfs-nginx-module/src
make && make install


#配置 mod_fastdfs.conf
cp /usr/local/src/fastdfs-nginx-module/src/mod_fastdfs.conf  /etc/fdfs/

#sed -i "s#base_path=/tmp#base_path=/data/fastdfs/storage#g" /etc/fdfs/mod_fastdfs.conf
sed -i "s#connect_timeout=2#connect_timeout=10#g" /etc/fdfs/mod_fastdfs.conf
sed -i "s#tracker_server=tracker:22122#tracker_server=$FASTDFS_TRACKER_SERVER_IP:22122#g" /etc/fdfs/mod_fastdfs.conf
sed -i "s#url_have_group_name = false#url_have_group_name = true#g" /etc/fdfs/mod_fastdfs.conf
sed -i "s#store_path0=/home/yuqing/fastdfs#store_path0=/data/fastdfs/storage#g" /etc/fdfs/mod_fastdfs.conf


#复制FastDFS的部分配置文件到/etc/fdfs 目录
cp -rf /usr/local/fastdfs/conf/http.conf /etc/fdfs/http.conf
cp -rf /usr/local/fastdfs/conf/mime.types /etc/fdfs/mime.types


#在/fastdfs/storage 文件存储目录下创建软连接,将其链接到实际存放数据的目录
ln -s /data/fastdfs/storage/data/ /data/fastdfs/storage/data/M00


#配置nginx.conf
cd /usr/local/src/
wget https://github.com/istorkbox/istorkbox-tech/raw/master/install/fastdfs/nginx.conf
#wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/fastdfs/nginx.conf
cp -rf /usr/local/nginx/conf/nginx.conf /usr/local/nginx/conf/nginx.conf.bak
rm -rf /usr/local/nginx/conf/nginx.conf
cp -rf /usr/local/src/nginx.conf /usr/local/nginx/conf/nginx.conf


#停止防火墙或是把 80 端口加入到的排除列表：
firewall-cmd --zone=public --add-port=8888/tcp --permanent
firewall-cmd --reload


#启动nginx,启动完成 shell 是不会有输出的
/usr/local/nginx/sbin/nginx


#检查 Nginx 是否启动并监听了80端口：
netstat -ntulp | grep 8888

curl http://$install_ip:8888
echo "访问的地址http://$install_ip:8888";


##检查 Nginx 启用的配置文件是哪个：
# /usr/local/nginx/sbin/nginx -t

##刷新 Nginx 配置后重启：
# /usr/local/nginx/sbin/nginx -s reload

##停止 Nginx：
# /usr/local/nginx/sbin/nginx -s stop

##如果访问不了，或是出现其他信息看下错误立即：
# vim /var/log/nginx/error.log
