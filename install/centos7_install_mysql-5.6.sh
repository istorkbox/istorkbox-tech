#!/bin/bash

#Mysql5.6源码编译安装
#mysql-5.6.40.tar.gz
#https://github.com/hhhcommon/Linux-Tutorial/blob/master/markdown-file/Mysql-Install-And-Settings.md
#http://www.zhimengzhe.com/bianchengjiaocheng/qitabiancheng/284820.html
#http://dev.mysql.com/downloads/mysql/5.6.html#downloads

#安装依赖包、编译包
yum install -y make gcc-c++ cmake bison-devel ncurses-devel

#下载文件
cd /usr/local/src

#wget http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.40.tar.gz
wget https://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.40.tar.gz

#解压和进入解压目录
tar zxvf mysql-5.6.40.tar.gz
cd mysql-5.6.40

#生成安装目录
mkdir -p /var/lib/mysql/data/

#生成配置（使用 InnoDB）
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DMYSQL_DATADIR=/var/lib/mysql/data/ -DMYSQL_UNIX_ADDR=/tmp/mysql.sock -DDEFAULT_CHARSET=utf8mb4 -DDEFAULT_COLLATION=utf8mb4_unicode_ci -DWITH_EXTRA_CHARSETS:STRING=utf8mb4 -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DENABLED_LOCAL_INFILE=1

#编译,这个过程比较漫长,一般都在30分钟左右,具体还得看机子配置，如果最后结果有error,建议删除整个 mysql目录后重新解压一个出来继续处理 
make

#安装
make install

##zip file use in other machine
# cd /local/usr/
# tar zcvf mysql-5.6.40.tar.gz *

#配置开机启动：
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysql
chmod +x /etc/init.d/mysql
chkconfig --add mysql
chkconfig mysql on

#复制一份配置文件： 
yes|cp -f /usr/local/mysql/support-files/my-default.cnf /etc/my.cnf

#添加组和用户及安装目录权限
#添加组
groupadd mysql
#创建用户mysql并加入到mysql组，不允许mysql用户直接登录系统
useradd -g mysql mysql -s /bin/false
#设置MySQL数据库目录权限
chown -R mysql:mysql /var/lib/mysql/data

#初始化数据库：
#解决FATAL ERROR: please install the following Perl modules before executing /usr/local/mysql/scripts/mysql_install_db:
yum install -y perl-Module-Install.noarch
/usr/local/mysql/scripts/mysql_install_db --basedir=/usr/local/mysql --datadir=/var/lib/mysql/data --skip-name-resolve --user=mysql

#开放防火墙端口：
iptables -I INPUT -p tcp -m tcp --dport 3306 -j ACCEPT
service iptables save
service iptables restart

#禁用selinux
#编辑配置文件：vim /etc/selinux/config
#把SELINUX=enforcing改为SELINUX=disabled
sed -e "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config

#常用命令软连接，才可以在终端直接使用：mysql 和 mysqladmin 命令
ln -s /usr/local/mysql/bin/mysql /usr/bin
ln -s /usr/program/mysql/bin/mysqladmin /usr/bin
ln -s /usr/local/mysql/bin/mysqldump /usr/bin
ln -s /usr/local/mysql/bin/mysqlslap /usr/bin

#MySQL配置
cd /usr/local/src
wget https://github.com/istorkbox/istorkbox-tech/raw/master/install/mysql-5.6/mysql-5.6.40-my.cnf
#download from tencent cloud
#wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/mysql-5.6/mysql-5.6.40-my.cnf
yes|cp -f mysql-5.6.40-my.cnf /etc/my.cnf

#启动 Mysql 服务器
service mysql start

#查看是否已经启动
ps aux | grep mysql


##登录连接
##默认安装情况下，root 的密码是空，所以为了方便我们可以设置一个密码，假设我设置为：123456

##终端下执行：
#mysql -uroot

##现在进入了 mysql 命令行管理界面，输入：
#SET PASSWORD = PASSWORD('123456');FLUSH PRIVILEGES;

##quit退出再执行,输入密码：123456
#quit
#mysql -uroot -p


##连接报错："Host '192.168.1.133' is not allowed to connect to this MySQL server"
##不允许除了 localhost 之外去连接，解决办法，进入 MySQL 命令行，输入下面内容：
#GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION;