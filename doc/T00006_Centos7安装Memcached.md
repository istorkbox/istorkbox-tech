### yum安装

`yum -y install memcached` 

### 查看

```
memcached -h 
```

### 设置

```
vi /etc/sysconfig/memcached 
```

```
PORT=”11211″ //端口 -p
USER="memcached" //用户 -u
MAXCONN="1024" //最大连接数 -c  
CACHESIZE="64" //占用的内存 -m
OPTIONS="" // 其他选项参数 
```

下面是常用参数说明：

```
-d 选项是启动一个守护进程
-m 是分配给 memcached 使用的内存数量，单位是 MB
-u 是运行 memcached 的用户，建议不要使用 root
-l 是监听的服务器 IP 地址，如果是本机使用，可以设为 127.0.0.1
-p 是设置 memcached 监听的端口
-c 选项是最大运行的并发连接数，默认是 1024
-P 是设置保存 memcached 的 pid 文件
```
 
### 启动、停止、重启、运行状态、开机启动 

```
#systemctl start memcached 
#systemctl stop memcached 
#systemctl restart memcached 
#systemctl status memcached 
#systemctl enable memcached 
```
 
### 安装PHP-memcached扩展

```
yum -y install php-pecl-memcached
```
 
### 查看memcached整体信息

```
#memcached-tool 127.0.0.1:11211 stats
```

### 测试memcached服务

- 检查端口是否打开

使用 netstat 命令检查 11211 端口是否打开

`sudo netstat -anp | grep 11211`


- 安装telnet服务

检查是否安装 telnet-server和xinetd

```
rpm -qa telnet-server
rpm -qa xinetd
```

如果没有安装过就安装 查找yum

```
yum list |grep telnet
yum list |grep xinetd
```

执行安装语句

```
yum -y install telnet-server.x86_64
yum -y install telnet.x86_64
yum -y install xinetd.x86_64
```

设置开机自启：
 
```
systemctl enable xinetd.service
systemctl enable telnet.socket

开启service：

```
systemctl start telnet.socket
systemctl start xinetd
```

- 使用 telnet 检查服务运行是否正常
1、 运行 telnet 命令

`telnet 127.0.0.1 11211`

返回如下信息：

```
Trying 127.0.0.1...
Connected to 127.0.0.1.
Escape character is '^]'.
```

2、 使用 set 命令设置键 testKey 的值

set 命令的格式为:

```
set key flags expiration_time bytes
value

key 是键名
flags 是整型标记位，一般为0
expiration_time 是超时时间，以秒为单位，设为0表示没有超时时间
bytes 是要设的值的字节数
value 是要设的值，从第二行开始
```

输入以下内容可以将键 testKey 的值设置为整型 1234

```
set testKey 0 0 4
1234
```

并回车，服务端返回 STORED，表示存储成功

3、 使用 get 命令获取刚才设置的 testKey 的值
get 命令的格式为：

```
get key

key 为要获取值的键名
```

输入

`get testKey`

并回车，服务端返回之前设置的1234，表示 memcached 服务运行正常

4、 退出 telnet 会话
输入

`quit`

并回车，关闭当前连接
