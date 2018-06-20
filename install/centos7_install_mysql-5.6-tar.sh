#!/bin/bash

#数据库登录用户名和密码:root/123456
#Mysql5.6 Compressed TAR Archive压缩文件安装
#mysql-5.6.40-linux-glibc2.12-x86_64.tar.gz
#https://github.com/hhhcommon/Linux-Tutorial/blob/master/markdown-file/Mysql-Install-And-Settings.md
#http://www.zhimengzhe.com/bianchengjiaocheng/qitabiancheng/284820.html
#http://dev.mysql.com/downloads/mysql/5.6.html#downloads

#安装依赖包、编译包
yum install -y make gcc-c++ cmake bison-devel ncurses-devel

#下载文件
cd /usr/local/src


if [ ! -f 'mysql-5.6.40.tar.gz' ]; then
	# download file from https://dev.mysql.com/downloads/mysql/5.6.html#downloads
    #sudo wget https://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.40-linux-glibc2.12-x86_64.tar.gz
    # download file from tencent clund
    sudo wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/mysql-5.6/mysql-5.6.40.tar.gz
fi

if [ -f 'mysql-5.6.40.tar.gz' ]; then
	#解压和进入解压目录
	tar zxvf mysql-5.6.40.tar.gz
	
	#移动目录
	mv mysql-5.6.40 /usr/local/mysql
else
	#解压和进入解压目录
	tar zxvf mysql-5.6.40-linux-glibc2.12-x86_64.tar.gz
	
	#移动目录
	mv mysql-5.6.40-linux-glibc2.12-x86_64 /usr/local/mysql
fi

#生成安装目录
mkdir -p /var/lib/mysql/data/

##zip file use in other machine
# cd /local/usr/
#tar zcvf mysql-5.6.40.tar.gz *

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
wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/mysql-5.6/mysql-5.6.40-my.cnf
yes|cp -f mysql-5.6.40-my.cnf /etc/my.cnf

#启动 Mysql 服务器
service mysql start

#查看是否已经启动
ps aux | grep mysql

#通过脚本修改密码
mysql -uroot -e "  
tee /tmp/temp.log  
SET PASSWORD = PASSWORD('123456');
FLUSH PRIVILEGES; 
notee  
quit"  

mysql -uroot -p123456 -e "  
tee /tmp/temp.log  
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION;
FLUSH PRIVILEGES; 
notee  
quit"  


##+------------------+----------+--------------+------------------+-------------------+
##|                                    MySQL修改密码                                  |
##+------------------+----------+--------------+------------------+-------------------+
##登录连接
##默认安装情况下，root 的密码是空，所以为了方便我们可以设置一个密码，假设我设置为：123456

##终端下执行：
#mysql -uroot

##现在进入了 mysql 命令行管理界面，输入：
#SET PASSWORD = PASSWORD('123456');FLUSH PRIVILEGES;

##quit退出再执行,输入密码：123456
#quit
#mysql -uroot -p123456
#quit

##连接报错："Host '192.168.1.133' is not allowed to connect to this MySQL server"
##不允许除了 localhost 之外去连接，解决办法，进入 MySQL 命令行，输入下面内容：
#GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION;


##+------------------+----------+--------------+------------------+-------------------+
##|                                    MySQL主从复制                                  |
##+------------------+----------+--------------+------------------+-------------------+
##假设有两台服务器，一台做主，一台做从
##MySQL 主信息：
##	IP：139.199.185.34
##	端口：3306
##MySQL 从信息：
##	IP：119.29.201.195
##	端口：3306
##注意点
##	主 DB server 和从 DB server 数据库的版本一致
##	主 DB server 和从 DB server 数据库数据一致
##	主 DB server 开启二进制日志，主DB server 和从 DB server 的 server-id 都必须唯一
##优先操作：
##	把主库的数据库复制到从库并导入

##主库机子操作

##创建一个目录
# mkdir -p /var/lib/mysql/data/mysql-bin

# vi /etc/my.cnf
##添加一行：
# log-bin = /var/lib/mysql/data/mysql-bin

##指定同步的数据库，如果不指定则同步全部数据库，其中test数据库名(这里用默认test数据库)：
# binlog-do-db=test


##主库关掉慢查询记录，用 SQL 语句查看当前是否开启：SHOW VARIABLES LIKE '%slow_query_log%';，
##如果显示 OFF 则表示关闭，ON 表示开启
##重启主库 MySQL 服务
# service msyql restart

##进入 MySQL 命令行状态，执行 SQL 语句查询状态：SHOW MASTER STATUS;
##在显示的结果中，我们需要记录下 File 和 Position 值，等下从库配置有用。
# mysql -uroot -p123456
# SHOW MASTER STATUS;

##+------------------+----------+--------------+------------------+-------------------+
##| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
##+------------------+----------+--------------+------------------+-------------------+
##| mysql-bin.000002 |      120 |              |                  |                   |
##+------------------+----------+--------------+------------------+-------------------+


##设置授权用户 slave01 使用 123456 密码登录主库，这里 @ 后的 IP 为从库机子的 IP 地址，
##如果从库的机子有多个，我们需要多个这个 SQL 语句。
# grant replication slave on *.* to 'slave01'@'119.29.201.195' identified by '123456';
# flush privileges;


##从库机子操作

##修改配置文件：
# vi /etc/my.cnf，
##把 server-id 改为跟主库不一样


##在进入 MySQL 的命令行状态下，输入下面 SQL：
##mysql-bin.000002 >>>这个值复制刚刚让你记录的值
##120 >>>这个值复制刚刚让你记录的值

# CHANGE MASTER TO
# master_host='139.199.185.34',
# master_user='slave01',
# master_password='123456',
# master_port=3306,
# master_log_file='mysql-bin.000002',
# master_log_pos=120;
 
##执行该 SQL 语句，启动 slave 同步：
# START SLAVE;

##执行该 SQL 语句，查看从库机子同步状态：
# SHOW SLAVE STATUS;

##在查看结果中必须下面两个值都是 Yes 才表示配置成功：
## Slave_SQL_Running:Yes
## Slave_IO_Running:Yes
##如果Slave_IO_Running不是 Yes 也不是 No，而是 Connecting，那就表示从机连不上主库，需要你进一步排查连接问题。

##如果你的 Slave_IO_Running 是 No，一般如果你是在虚拟机上测试的话，从库的虚拟机是从主库的虚拟机上复制过来的，
##那一般都会这样的，因为两台的 MySQL 的 UUID 值一样。你可以检查从库下的错误日志：cat /var/lib/mysql/data/mysql-error.log

##mysql> SHOW SLAVE STATUS;
##+----------------+----------------+-------------+-------------+---------------+------------------+---------------------+------------------------+---------------+-----------------------+------------------+-------------------+-----------------+---------------------+--------------------+------------------------+-------------------------+-----------------------------+------------+------------+--------------+---------------------+-----------------+-----------------+----------------+---------------+--------------------+--------------------+--------------------+-----------------+-------------------+----------------+-----------------------+-------------------------------+---------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------+----------------+-----------------------------+------------------+-------------+---------------------------------+-----------+---------------------+-----------------------------------------------------------------------------+--------------------+-------------+-------------------------+--------------------------+----------------+--------------------+--------------------+-------------------+---------------+
##| Slave_IO_State | Master_Host    | Master_User | Master_Port | Connect_Retry | Master_Log_File  | Read_Master_Log_Pos | Relay_Log_File         | Relay_Log_Pos | Relay_Master_Log_File | Slave_IO_Running | Slave_SQL_Running | Replicate_Do_DB | Replicate_Ignore_DB | Replicate_Do_Table | Replicate_Ignore_Table | Replicate_Wild_Do_Table | Replicate_Wild_Ignore_Table | Last_Errno | Last_Error | Skip_Counter | Exec_Master_Log_Pos | Relay_Log_Space | Until_Condition | Until_Log_File | Until_Log_Pos | Master_SSL_Allowed | Master_SSL_CA_File | Master_SSL_CA_Path | Master_SSL_Cert | Master_SSL_Cipher | Master_SSL_Key | Seconds_Behind_Master | Master_SSL_Verify_Server_Cert | Last_IO_Errno | Last_IO_Error                                                                                                                                                                                                                                                                                    | Last_SQL_Errno | Last_SQL_Error | Replicate_Ignore_Server_Ids | Master_Server_Id | Master_UUID | Master_Info_File                | SQL_Delay | SQL_Remaining_Delay | Slave_SQL_Running_State                                                     | Master_Retry_Count | Master_Bind | Last_IO_Error_Timestamp | Last_SQL_Error_Timestamp | Master_SSL_Crl | Master_SSL_Crlpath | Retrieved_Gtid_Set | Executed_Gtid_Set | Auto_Position |
##+----------------+----------------+-------------+-------------+---------------+------------------+---------------------+------------------------+---------------+-----------------------+------------------+-------------------+-----------------+---------------------+--------------------+------------------------+-------------------------+-----------------------------+------------+------------+--------------+---------------------+-----------------+-----------------+----------------+---------------+--------------------+--------------------+--------------------+-----------------+-------------------+----------------+-----------------------+-------------------------------+---------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------+----------------+-----------------------------+------------------+-------------+---------------------------------+-----------+---------------------+-----------------------------------------------------------------------------+--------------------+-------------+-------------------------+--------------------------+----------------+--------------------+--------------------+-------------------+---------------+
##|                | 139.199.185.34 | slave01     |        3306 |            60 | mysql-bin.000002 |                 120 | mysql-relay-bin.000001 |             4 | mysql-bin.000002      | No               | Yes               |                 |                     |                    |                        |                         |                             |          0 |            |            0 |                 120 |             120 | None            |                |             0 | No                 |                    |                    |                 |                   |                |                  NULL | No                            |          1593 | Fatal error: The slave I/O thread stops because master and slave have equal MySQL server ids; these ids must be different for replication to work (or the --replicate-same-server-id option must be used on slave but this does not always make sense; please check the manual before using it). |              0 |                |                             |           100866 |             | /var/lib/mysql/data/master.info |         0 |                NULL | Slave has read all relay log; waiting for the slave I/O thread to update it |              86400 |             | 180619 12:03:23         |                          |                |                    |                    |                   |             0 |
##+----------------+----------------+-------------+-------------+---------------+------------------+---------------------+------------------------+---------------+-----------------------+------------------+-------------------+-----------------+---------------------+--------------------+------------------------+-------------------------+-----------------------------+------------+------------+--------------+---------------------+-----------------+-----------------+----------------+---------------+--------------------+--------------------+--------------------+-----------------+-------------------+----------------+-----------------------+-------------------------------+---------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------+----------------+-----------------------------+------------------+-------------+---------------------------------+-----------+---------------------+-----------------------------------------------------------------------------+--------------------+-------------+-------------------------+--------------------------+----------------+--------------------+--------------------+-------------------+---------------+

##Last_IO_Error列显示
##Fatal error: The slave I/O thread stops because master and slave have equal MySQL server ids; these ids must be different for replication to work (or the --replicate-same-server-id option must be used on slave but this does not always make sense; please check the manual before using it).


##如果里面提示 uuid 错误，你可以编辑从库的这个配置文件：vim /var/lib/mysql/data/auto.cnf
##把配置文件中的：server-uuid 值随便改一下，保证和主库是不一样即可
## vi /var/lib/mysql/data/auto.cnf
##如:"server-uuid=970fe0c1-7371-11e8-8e50-525400debfd3"修改为"server-uuid=970fe0c1-7371-11e8-8e50-525400debfd4"

# service mysql stop
# sed -e "s/server-uuid=970fe0c1-7371-11e8-8e50-525400debfd3/server-uuid=970fe0c1-7371-11e8-8e50-525400debfd4/g" /var/lib/mysql/data/auto.cnf
# service mysql start
# mysql -uroot -p123456
# START SLAVE;
# SHOW SLAVE STATUS;

##mysql> SHOW SLAVE STATUS;
##+----------------------------------+----------------+-------------+-------------+---------------+------------------+---------------------+------------------------+---------------+-----------------------+------------------+-------------------+-----------------+---------------------+--------------------+------------------------+-------------------------+-----------------------------+------------+------------+--------------+---------------------+-----------------+-----------------+----------------+---------------+--------------------+--------------------+--------------------+-----------------+-------------------+----------------+-----------------------+-------------------------------+---------------+---------------+----------------+----------------+-----------------------------+------------------+--------------------------------------+---------------------------------+-----------+---------------------+-----------------------------------------------------------------------------+--------------------+-------------+-------------------------+--------------------------+----------------+--------------------+--------------------+-------------------+---------------+
##| Slave_IO_State                   | Master_Host    | Master_User | Master_Port | Connect_Retry | Master_Log_File  | Read_Master_Log_Pos | Relay_Log_File         | Relay_Log_Pos | Relay_Master_Log_File | Slave_IO_Running | Slave_SQL_Running | Replicate_Do_DB | Replicate_Ignore_DB | Replicate_Do_Table | Replicate_Ignore_Table | Replicate_Wild_Do_Table | Replicate_Wild_Ignore_Table | Last_Errno | Last_Error | Skip_Counter | Exec_Master_Log_Pos | Relay_Log_Space | Until_Condition | Until_Log_File | Until_Log_Pos | Master_SSL_Allowed | Master_SSL_CA_File | Master_SSL_CA_Path | Master_SSL_Cert | Master_SSL_Cipher | Master_SSL_Key | Seconds_Behind_Master | Master_SSL_Verify_Server_Cert | Last_IO_Errno | Last_IO_Error | Last_SQL_Errno | Last_SQL_Error | Replicate_Ignore_Server_Ids | Master_Server_Id | Master_UUID                          | Master_Info_File                | SQL_Delay | SQL_Remaining_Delay | Slave_SQL_Running_State                                                     | Master_Retry_Count | Master_Bind | Last_IO_Error_Timestamp | Last_SQL_Error_Timestamp | Master_SSL_Crl | Master_SSL_Crlpath | Retrieved_Gtid_Set | Executed_Gtid_Set | Auto_Position |
##+----------------------------------+----------------+-------------+-------------+---------------+------------------+---------------------+------------------------+---------------+-----------------------+------------------+-------------------+-----------------+---------------------+--------------------+------------------------+-------------------------+-----------------------------+------------+------------+--------------+---------------------+-----------------+-----------------+----------------+---------------+--------------------+--------------------+--------------------+-----------------+-------------------+----------------+-----------------------+-------------------------------+---------------+---------------+----------------+----------------+-----------------------------+------------------+--------------------------------------+---------------------------------+-----------+---------------------+-----------------------------------------------------------------------------+--------------------+-------------+-------------------------+--------------------------+----------------+--------------------+--------------------+-------------------+---------------+
##| Waiting for master to send event | 139.199.185.34 | slave01     |        3306 |            60 | mysql-bin.000002 |                 413 | mysql-relay-bin.000003 |           576 | mysql-bin.000002      | Yes              | Yes               |                 |                     |                    |                        |                         |                             |          0 |            |            0 |                 413 |             749 | None            |                |             0 | No                 |                    |                    |                 |                   |                |                     0 | No                            |             0 |               |              0 |                |                             |           100866 | 977c2781-7365-11e8-8e02-525400199a8a | /var/lib/mysql/data/master.info |         0 |                NULL | Slave has read all relay log; waiting for the slave I/O thread to update it |              86400 |             |                         |                          |                |                    |                    |                   |             0 |
##+----------------------------------+----------------+-------------+-------------+---------------+------------------+---------------------+------------------------+---------------+-----------------------+------------------+-------------------+-----------------+---------------------+--------------------+------------------------+-------------------------+-----------------------------+------------+------------+--------------+---------------------+-----------------+-----------------+----------------+---------------+--------------------+--------------------+--------------------+-----------------+-------------------+----------------+-----------------------+-------------------------------+---------------+---------------+----------------+----------------+-----------------------------+------------------+--------------------------------------+---------------------------------+-----------+---------------------+-----------------------------------------------------------------------------+--------------------+-------------+-------------------------+--------------------------+----------------+--------------------+--------------------+-------------------+---------------+
