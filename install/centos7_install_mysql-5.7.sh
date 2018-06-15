#!/bin/bash

#Mysql5.7.7源码编译安装操作步骤
#mysql-5.7.22.tar.gz
#http://dev.mysql.com/downloads/mysql/5.7.html#downloads

# 1.更新系统
yum -y update


# 2.安装依赖包、编译包
yum install -y make gcc-c++ cmake bison-devel ncurses-devel


# 3.下载boost/mysql
cd /usr/local/src
wget https://jaist.dl.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.gz
#wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/boost_1_59_0.tar.gz

wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.22.tar.gz
#wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-boost-5.7.22.tar.gz

#wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/mysql-5.7.22.tar.gz
#wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/mysql-5.7.22.tar.gz

# 4.解压boost
cd /usr/local/src
mkdir –p /usr/local/boost

tar -xvf boost_1_59_0.tar.gz
#tar -xvf boost_1_57_0.tar.gz 

mv boost_1_59_0 /usr/local/boost/boost_1_59_0

# 5.添加用户及用户组
#新建一个msyql组
groupadd mysql

#新建msyql用户禁止登录shell
useradd -r -g mysql mysql

#数据仓库目录
mkdir -p /var/lib/mysql/data

#6.安装mysql
tar -zxvf mysql-5.7.22.tar.gz 

cd mysql-5.7.22

cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DMYSQL_DATADIR=/var/lib/mysql/data/ -DMYSQL_USER=mysql -DEXTRA_CHARSETS=all -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_PARTITION_STORAGE_ENGINE=1 -DENABLED_LOCAL_INFILE=1 -DWITH_BOOST=/usr/local/boost

make

## 如果编译错误如下
##c++: internal compiler error: Killed (program cc1plus)
##Please submit a full bug report,
##with preprocessed source if appropriate.
##See <http://bugzilla.redhat.com/bugzilla> for instructions.
##make[2]: *** [sql/CMakeFiles/sql.dir/item_geofunc.cc.o] Error 4
##make[1]: *** [sql/CMakeFiles/sql.dir/all] Error 2
## make: *** [all] Error 2

## 编译出错后,用2g分区交换，运行下面脚本
# dd if=/dev/zero of=/swapfile bs=1k count=2048000 --获取要增加的2G的SWAP文件块
# mkswap /swapfile     -- 创建SWAP文件
# swapon /swapfile     -- 激活SWAP文件
# swapon -s            -- 查看SWAP信息是否正确
# echo "/var/swapfile swap swap defaults 0 0" >> /etc/fstab     -- 添加到fstab文件中让系统引导时自动启动

##然后需要删除CMakeCache.txt文件
##然后重新cmake 预编译。然后就可以编译通过

##注意, swapfile文件的路径在/var/下
##编译完后, 如果不想要交换分区了, 可以删除:
# swapoff /swapfile
# rm -fr /swapfile

make install

#压缩编译后的mysql
cd /usr/local/
tar zcvf mysql-5.7.22.tar.gz /usr/local/mysql


#第三：启动验证
#1.修改权限
cd /usr/local/mysql
chown -R mysql. .

#复制启动文件
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysql 
 
# 增加执行权限 
chmod 755 /etc/init.d/mysql   ---
#加入自动启动项
#把服务文件放到 /etc/init.d/ 目录下面相当于改为了 rpm 包安装的服务使用方式。
chkconfig --add mysql

exit 1

##下面脚本手动执行

#2.初始化mysql环境
mysqld --initialize --user=mysql --basedir=/usr/local/mysql  --datadir=/var/lib/mysql/data --explicit_defaults_for_timestamp
#显示类似
#[Warning] A temporary password is generated for root@localhost: KoRt*,)&)1o+

#3.登陆
service mysql start
mysql -uroot -p
#Enter password:输入上面的临时密码，有可能会出现如下的错误
#ERROR 1862 (HY000): Your password has expired. To log in you must change it using a client that supports expired passwords.

#解决方法：
#停掉mysql服务
ps -aux | grep mysql
kill -9 xxxxx

mysqld_safe --skip-grant-tables --skip-networking &

mysql -uroot -p
#Enter password:直接回车

use mysql
#-- 5.7.7用authentication_string字段来存储密码，而不是之前的password
update user set authentication_string=password('123456'),password_expired='N' where user='root';

#Query OK, 1 row affected, 1 warning (0.00 sec)
#Rows matched: 1  Changed: 1  Warnings: 1
#再次登陆正常，至此安装完毕