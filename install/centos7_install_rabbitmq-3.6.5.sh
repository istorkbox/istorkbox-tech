#!/bin/bash
#rabbitmq-server-3.6.5
#https://blog.csdn.net/hao134838/article/details/71512557?utm_source=copy

###第一步：安装Erlang
###因为rabbitMQ是Erlang语言编写的，所以我们首先需要安装Erlang
	rpm -Uvh https://www.rabbitmq.com/releases/erlang/erlang-19.0.4-1.el7.centos.x86_64.rpm
	
###第二步、安装rabbitMQ-server
	rpm -Uvh http://www.rabbitmq.com/releases/rabbitmq-server/v3.5.6/rabbitmq-server-3.5.6-1.noarch.rpm

	
	rpm -Uvh https://dl.bintray.com/rabbitmq/rpm/erlang/21/el/7/x86_64/erlang-21.1-1.el7.centos.x86_64.rpm
	wget https://dl.bintray.com/rabbitmq/rpm/rabbitmq-server/v3.7.x/el/7/noarch/rabbitmq-server-3.7.8-1.el7.noarch.rpm
	yum install rabbitmq-server-3.7.8-1.el7.noarch.rpm
	
###第三步、查看rabbitmq-server是否已经安装好了，能查到说明已经安装完成了。
	rpm -qa|grep rabbitmq
   

###第四步、开启rabbit-server
	service rabbitmq-server start 
  
###第五步、关闭rabbit-server（验证命令）
	service rabbitmq-server stop
	service rabbitmq-server start

###第六步、查看状态
	rabbitmqctl status

###第七步、安装命令维护插件
###这样虽然我们已经将rabbitmq的服务正常启动了，但是我们在物理机的浏览器中输入ip:15672时，并不能连接，因为我们还没有配置维护插件和开启远程连接
	rabbitmq-plugins enable rabbitmq_management 
  
###第八步、设置配置文件，并开启用户远程访问
	cd /etc/rabbitmq 
	cp /usr/share/doc/rabbitmq-server-3.5.6/rabbitmq.config.example /etc/rabbitmq/  
	mv rabbitmq.config.example rabbitmq.config 
	vi /etc/rabbitmq/rabbitmq.config
	#sed -i "s#%% {loopback_users, []},#{loopback_users, []}#g" /etc/rabbitmq/rabbitmq.config
	#将 %% {loopback_users, []}, 修改后--> {loopback_users, []}
 
  
###第八步、重启rabbit-server服务
   service rabbitmq-server restart

###第九步、登录访问
	echo "在浏览器中输入ip:15672即可出现登录页面，用户名和密码都是guest"
 