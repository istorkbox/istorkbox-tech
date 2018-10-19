#!/bin/bash
#rabbitmq-server-3.5.8
#https://blog.csdn.net/hao134838/article/details/71512557?utm_source=copy
#https://www.cnblogs.com/saneri/p/7798251.html

#https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/erlang-19.0.4-1.el7.centos.x86_64.rpm
#https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/rabbitmq-server-3.5.8-1.noarch.rpm
#https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/rabbitmq_delayed_message_exchange-0.0.1.ez

###192.168.1.211 主机的hostname:
#v01-app-rabbitmq01
#vi /etc/hostname 
# hostnamectl set-hostname v01-app-rabbitmq01


###192.168.1.213 主机hostname:
#v01-app-rabbitmq02
#vi /etc/hostname
# hostnamectl set-hostname v01-app-rabbitmq02


###对应主机host地址(二台主机host文件中下面内容保持一致)
#192.168.1.211 rabbit@v01-app-rabbitmq01
#192.168.1.213 v01-app-rabbitmq02
# echo "192.168.1.211 v01-app-rabbitmq01" >> /etc/hosts
# echo "192.168.1.213 v01-app-rabbitmq02" >> /etc/hosts


###永久关闭SELINUX
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/sysconfig/selinux


###第一步：安装Erlang
###因为rabbitMQ是Erlang语言编写的，所以我们首先需要安装Erlang
	#rpm -Uvh https://www.rabbitmq.com/releases/erlang/erlang-19.0.4-1.el7.centos.x86_64.rpm
	rpm -Uvh https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/erlang-19.0.4-1.el7.centos.x86_64.rpm
	
###第二步、安装rabbitMQ-server
	yum -y install wget
	#wget http://www.rabbitmq.com/releases/rabbitmq-server/v3.5.8/rabbitmq-server-3.5.8-1.noarch.rpm
	wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/rabbitmq-server-3.5.8-1.noarch.rpm
	yum -y install rabbitmq-server-3.5.8-1.noarch.rpm

	
###第三步、查看rabbitmq-server是否已经安装好了，能查到说明已经安装完成了。
	rpm -qa|grep rabbitmq
   

###第四步、开启rabbit-server
	#service rabbitmq-server start
	systemctl start rabbitmq-server.service 
  

###第五步、关闭rabbit-server（验证命令）
	#service rabbitmq-server stop
	#service rabbitmq-server start
	
	#CentOS7
	systemctl start rabbitmq-server.service
	systemctl status rabbitmq-server.service

	
###第六步、查看状态
	#rabbitmqctl status
  
###第七步、设置配置文件，并开启用户远程访问
	#cd /etc/rabbitmq 
	#cp /usr/share/doc/rabbitmq-server-3.7.8/rabbitmq.config.example /etc/rabbitmq/  
	#mv rabbitmq.config.example rabbitmq.config 
	#vi /etc/rabbitmq/rabbitmq.config
	##sed -i "s#%% {loopback_users, []},#{loopback_users, []}#g" /etc/rabbitmq/rabbitmq.config
	##将%% {loopback_users, []},修改后-->{loopback_users, []}
 
	# cd /etc/rabbitmq 
	# cp /usr/share/doc/rabbitmq-server-3.5.8/rabbitmq.config.example /etc/rabbitmq/ 
	# echo "[{rabbit, [{loopback_users, []}]}]." >> /etc/rabbitmq/rabbitmq.config
	
###第八步、安装命令维护插件
###这样虽然我们已经将rabbitmq的服务正常启动了，但是我们在物理机的浏览器中输入ip:15672时，并不能连接，因为我们还没有配置维护插件和开启远程连接
		
#web管理插件
#查看插件列表
rabbitmq-plugins list      
rabbitmq-plugins enable rabbitmq_management
 
#日志跟踪插件
#rabbitmq启用trace插件
rabbitmq-plugins enable rabbitmq_tracing
#打开trace的开关
rabbitmqctl trace_on
#打开trace的开关(test为需要日志追踪的vhost)    
#rabbitmqctl trace_on -p test
#关闭trace的开关
#rabbitmqctl trace_off     

#安装rabbitmq_delayed_message_exchange（延时队列）
#默认插件目录:
cd /usr/lib/rabbitmq/lib/rabbitmq_server-3.5.8/plugins
#wget https://dl.bintray.com/rabbitmq/community-plugins/rabbitmq_delayed_message_exchange-0.0.1.ez
wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/rabbitmq_delayed_message_exchange-0.0.1.ez
rabbitmq-plugins enable rabbitmq_delayed_message_exchange
 
###https://www.cnblogs.com/saneri/p/7798251.html
###https://www.cnblogs.com/knowledgesea/p/6535766.html
###普通集群配置
##1.说明：
#Rabbitmq的集群是依附于erlang的集群来工作的,所以必须先构建起erlang的集群镜像。
#Erlang的集群中各节点是经由过程一个magic cookie来实现的,
#这个cookie存放在 $home/.erlang.cookie 中,我的是用rpm安装的,所以.erlang.cookie就放在/var/lib/rabbitmq中 
# find / -name .erlang.cookie


##注意!!!不然集群有问题
#关闭防火墙
#或开放下面端口:
# 4369 5672 25672 25672
# systemctl stop firewalld


## --------------------------------
##(这个在192.168.1.213主机操作)
##2.复制cookie内容 
#erlang.cookie是erlang实现分布式的必要文件，erlang分布式的每个节点上要保持相同的.erlang.cookie文件，
#同时保证文件的权限是400,不然节点之间就无法通信。
#打开文件然后需要先把其中的一台服务器的.erlang.cookie中的内容复制到别的机器上,最好是复制内容,
#因为文件权限不对的话会出现问题,在最后退出保存的时候使用wq!用!来进行强制保存即可.
#也可是直接使用scp传过去,记得文件权限和用户属主属组如
#scp .erlang.cookie root@10.100.2.12:/tmp
# scp /var/lib/rabbitmq/.erlang.cookie root@192.168.1.213:/var/lib/rabbitmq/
# chmod 400 /var/lib/rabbitmq/.erlang.cookie 
## --------------------------------


##3.erlang.cookie复制完成后,逐个重启节点服务:
# systemctl restart rabbitmq-server.service
# systemctl status rabbitmq-server.service


## --------------------------------
##(这个在192.168.1.213主机操作)
##4.添加到集群：
#例如:将rabbit@v01-app-rabbitmq01作为集群主节点，在节点rabbitmq02和节点rabbitmq03上面分别执行如下命令，以加入集群中.
# rabbitmqctl stop_app
# rabbitmqctl reset
# rabbitmqctl join_cluster rabbit@v01-app-rabbitmq01
# rabbitmqctl start_app
## --------------------------------


###台都查看集群状态
# rabbitmqctl cluster_status


###下面步骤,在192.168.1.211主机操作
###5.账号管理
##添加账号：
# rabbitmqctl add_user admin 123456
##添加 权限tag
# rabbitmqctl set_user_tags admin administrator
 
 
###6.删除用户（删除guest用户）
# rabbitmqctl delete_user guest

 
###7.修改用户的密码
##rabbitmqctl  change_password  Username  Newpassword
##[root@v01-app-rabbitmq01 ~]# rabbitmqctl  change_password  admin 0GM1aol4z8GeSZY99
##Changing password for user "admin"


#8.设置权限,添加集群镜像模式配置
# rabbitmqctl set_permissions -p / admin '.*' '.*' '.*'
# rabbitmqctl set_policy -p / mq-all "^" '{"ha-mode":"all","ha-sync-mode":"automatic"}'
 

###9.查看当前用户列表
# rabbitmqctl  list_users

###WEB控制台登录访问
echo "在浏览器中输入"ip:15672"即可出现登录页面，用户名和密码:admin和123456"
echo "至此rabbitmq普通集群模式创建完成"
echo "用户名和密码:admin和123456"
echo "http://192.168.1.211:15672"
		
###-------------------------------------------------------
###补充例子说明		
###添加用户：
# rabbitmqctl add_user root 123456
###为用户设置角色：
# rabbitmqctl set_user_tags root administrator
###添加virtual host：
# rabbitmqctl add_vhost  /test
###为用户设置virtual host：rabbitmqctl  set_permissions  /test  test '.*' '.*' '.*'

###为用户添加访问权限"/"virtual host：rabbitmqctl
# rabbitmqctl set_permissions -p / root '.*' '.*' '.*'
# rabbitmqctl set_permissions -p /test root '.*' '.*' '.*'

###virtual_host管理
##新建virtual_host: 
# rabbitmqctl add_vhost /test
##撤销virtual_host:
# rabbitmqctl delete_vhost /test

###在cluster中任意节点启用策略，策略会自动同步到集群节点

## rabbitmqctl set_policy -p hrsystem ha-allqueue "^" '{"ha-mode":"all"}'
##这行命令在vhost名称为hrsystem创建了一个策略，策略名称为ha-allqueue, 
##策略模式为 all 即复制到所有节点，包含新增节点,
##策略正则表达式为 “^” 表示所有匹配所有队列名称。
# rabbitmqctl set_policy -p / mq-all "^" '{"ha-mode":"all","ha-sync-mode":"automatic"}'
###-------------------------------------------------------