#!/bin/bash
#nginx-1.15.0.tar.gz
#http://nginx.org
#http://nginx.org/download
#https://github.com/hhhcommon/Linux-Tutorial/blob/master/markdown-file/Nginx-Install-And-Settings.md

#安装依赖包
##开始安装：
#安装依赖包：
yum install -y gcc gcc-c++ pcre pcre-devel zlib zlib-devel openssl openssl-devel curl

#预设几个文件夹，方便等下安装的时候有些文件可以进行存放：
mkdir -p /usr/local/nginx /var/log/nginx /var/temp/nginx /var/lock/nginx

#下载源码包：
#安装包放在/usr/local/src目录里
cd /usr/local/src

if [ ! -f 'nginx-1.15.0.tar.gz' ]; then
    wget http://nginx.org/download/nginx-1.15.0.tar.gz
    #download from tencent cloud
    #wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/nginx-1.15.0.tar.gz
fi

sleep 5s

#解压：
tar zxvf nginx-1.15.0.tar.gz

#进入解压后目录：
cd nginx-1.15.0

#编译配置：
./configure \
--prefix=/usr/local/nginx \
--pid-path=/var/local/nginx/nginx.pid \
--lock-path=/var/lock/nginx/nginx.lock \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--with-http_gzip_static_module \
--http-client-body-temp-path=/var/temp/nginx/client \
--http-proxy-temp-path=/var/temp/nginx/proxy \
--http-fastcgi-temp-path=/var/temp/nginx/fastcgi \
--http-uwsgi-temp-path=/var/temp/nginx/uwsgi \
--with-http_ssl_module \
--http-scgi-temp-path=/var/temp/nginx/scgi

#编译：
make

#安装：
make install

#先检查是否在 /usr/local 目录下生成了 Nginx 等相关文件：cd /usr/local/nginx;ll，正常的效果应该是显示这样的：
#drwxr-xr-x 2 root root 4096 Jun 19 17:32 conf
#drwxr-xr-x 2 root root 4096 Jun 19 17:32 html
#drwxr-xr-x 2 root root 4096 Jun 19 17:32 sbin
cd /usr/local/nginx
ll

#停止防火墙或是把 80 端口加入到的排除列表：
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --reload


#启动nginx,启动完成 shell 是不会有输出的
/usr/local/nginx/sbin/nginx

#检查 时候有 Nginx 进程,正常是显示 3 个结果出来
#root      5571  0.0  0.1  45928  1128 ?        Ss   17:35   0:00 nginx: master process /usr/local/nginx/sbin/nginx
#nobody    5572  0.0  0.1  48468  1976 ?        S    17:35   0:00 nginx: worker process
#root      5577  0.0  0.0 112704   964 pts/1    R+   17:35   0:00 grep --color=auto nginx
ps aux | grep nginx


#检查 Nginx 是否启动并监听了 80 端口：
netstat -ntulp | grep 80

#访问本机IP(如本机IP是:139.199.200.208),如果能看到：
#Welcome to nginx!，即可表示安装成功
curl 139.199.200.208


##检查 Nginx 启用的配置文件是哪个：
# /usr/local/nginx/sbin/nginx -t

##刷新 Nginx 配置后重启：
# /usr/local/nginx/sbin/nginx -s reload

##停止 Nginx：
# /usr/local/nginx/sbin/nginx -s stop

##如果访问不了，或是出现其他信息看下错误立即：
# vim /var/log/nginx/error.log

