#!/bin/bash
#rabbitmq-server-3.5.8
#https://blog.csdn.net/hao134838/article/details/71512557?utm_source=copy
#https://www.cnblogs.com/saneri/p/7798251.html

#https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/erlang-19.0.4-1.el7.centos.x86_64.rpm
#https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/rabbitmq-server-3.5.8-1.noarch.rpm
#https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/rabbitmq_delayed_message_exchange-0.0.1.ez

###第一步：安装Erlang
###因为rabbitMQ是Erlang语言编写的，所以我们首先需要安装Erlang
	#rpm -Uvh https://www.rabbitmq.com/releases/erlang/erlang-19.0.4-1.el7.centos.x86_64.rpm
	rpm -Uvh https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/erlang-19.0.4-1.el7.centos.x86_64.rpm
	
###第二步、安装rabbitMQ-server		
	#wget http://www.rabbitmq.com/releases/rabbitmq-server/v3.5.8/rabbitmq-server-3.5.8-1.noarch.rpm
	wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/rabbitmq-server-3.5.8-1.noarch.rpm
	yum -y install rabbitmq-server-3.5.8-1.noarch.rpm

	
###第三步、查看rabbitmq-server是否已经安装好了，能查到说明已经安装完成了。
	rpm -qa|grep rabbitmq
   

###第四步、开启rabbit-server
	service rabbitmq-server start 
  
###第五步、关闭rabbit-server（验证命令）
	service rabbitmq-server stop
	service rabbitmq-server start

###第六步、查看状态
	rabbitmqctl status
  
###第七步、设置配置文件，并开启用户远程访问
	#cd /etc/rabbitmq 
	#cp /usr/share/doc/rabbitmq-server-3.7.8/rabbitmq.config.example /etc/rabbitmq/  
	#mv rabbitmq.config.example rabbitmq.config 
	#vi /etc/rabbitmq/rabbitmq.config
	##sed -i "s#%% {loopback_users, []},#{loopback_users, []}#g" /etc/rabbitmq/rabbitmq.config
	##将%% {loopback_users, []},修改后-->{loopback_users, []}
 
	cd /etc/rabbitmq 
	cp /usr/share/doc/rabbitmq-server-3.5.8/rabbitmq.config.example /etc/rabbitmq/ 
	echo "[{rabbit, [{loopback_users, []}]}]." >> /etc/rabbitmq/rabbitmq.config
	
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
rabbitmqctl trace_on -p test
#关闭trace的开关
rabbitmqctl trace_off     

#安装rabbitmq_delayed_message_exchange（延时队列）
#默认插件目录:
cd /usr/lib/rabbitmq/lib/rabbitmq_server-3.5.8/plugins
#wget https://dl.bintray.com/rabbitmq/community-plugins/rabbitmq_delayed_message_exchange-0.0.1.ez
wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/rabbitmq_delayed_message_exchange-0.0.1.ez
rabbitmq-plugins enable rabbitmq_delayed_message_exchange

#The following plugins have been enabled:
#rabbitmq_delayed_message_exchange
#Applying plugin configuration to v01-app-rabbit@localhost... started 1 plugin.
 

###权限配置
##创建用户
	rabbitmqctl add_user  admin  123456

##赋予角色
	rabbitmqctl set_user_tags admin administrator

#查看用户
	rabbitmqctl list_users
  
###第八步、重启rabbit-server服务
   service rabbitmq-server restart

###第九步、登录访问
	echo "在浏览器中输入ip:15672即可出现登录页面，用户名和密码都是guest"

###https://www.cnblogs.com/saneri/p/7798251.html
###https://www.cnblogs.com/knowledgesea/p/6535766.html
###普通集群配置
##1.说明：
#Rabbitmq的集群是依附于erlang的集群来工作的,所以必须先构建起erlang的集群镜像。
#Erlang的集群中各节点是经由过程一个magic cookie来实现的,
#这个cookie存放在 $home/.erlang.cookie 中,我的是用rpm安装的,所以.erlang.cookie就放在/var/lib/rabbitmq中 
#find / -name .erlang.cookie

##2.复制cookie内容 
#erlang.cookie是erlang实现分布式的必要文件，erlang分布式的每个节点上要保持相同的.erlang.cookie文件，
#同时保证文件的权限是400,不然节点之间就无法通信。
#打开文件然后需要先把其中的一台服务器的.erlang.cookie中的内容复制到别的机器上,最好是复制内容,
#因为文件权限不对的话会出现问题,在最后退出保存的时候使用wq!用!来进行强制保存即可.
#也可是直接使用scp传过去,记得文件权限和用户属主属组如scp .erlang.cookie root@10.100.2.12:/tmp

##3.erlang.cookie复制完成后,逐个重启节点服务:
#systemctl restart rabbitmq-server.service
#systemctl status rabbitmq-server.service

##4.添加到集群：

#例如:将rabbit@v01-app-rabbitmq01作为集群主节点，在节点rabbitmq02和节点rabbitmq03上面分别执行如下命令，以加入集群中.

#rabbitmqctl stop_app
#rabbitmqctl reset
#rabbitmqctl join_cluster rabbit@139.199.164.56
#rabbitmqctl start_app

###台都查看集群状态
#rabbitmqctl cluster_status

###5.账号管理
##添加账号：
#rabbitmqctl add_user admin admin
##添加 权限tag
#rabbitmqctl set_user_tags admin administrator
 
###6.删除用户（删除guest用户）
#rabbitmqctl delete_user guest
##Deleting user "guest"
 
###7.修改用户的密码
#rabbitmqctl  change_password  Username  Newpassword
 
##[root@v01-app-rabbitmq01 ~]# rabbitmqctl  change_password  admin 0GM1aol4z8GeSZY99
##Changing password for user "admin"
 
###8.查看当前用户列表
#rabbitmqctl  list_users
##Listing users
##admin   [administrator]

###7.访问WEB地址：10.100.2.10:15672
##至此rabbitmq普通集群模式创建完成. 
 