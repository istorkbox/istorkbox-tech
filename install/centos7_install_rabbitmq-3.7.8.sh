#!/bin/bash
#rabbitmq-server-3.7.8-1.el7.noarch.rpm
#https://blog.csdn.net/hao134838/article/details/71512557?utm_source=copy
#https://www.cnblogs.com/uptothesky/p/6094357.html
#http://blog.csdn.net/zyz511919766/article/details/42292655
#TencentCloud
#https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/erlang-21.1-1.el7.centos.x86_64.rpm
#https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/rabbitmq-server-3.7.8-1.el7.noarch.rpm
123.207.70.98
###安装Erlang和rabbitmq
	#rpm -Uvh https://dl.bintray.com/rabbitmq/rpm/erlang/21/el/7/x86_64/erlang-21.1-1.el7.centos.x86_64.rpm
	rpm -Uvh https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/erlang-21.1-1.el7.centos.x86_64.rpm
	
	#wget https://dl.bintray.com/rabbitmq/rpm/rabbitmq-server/v3.7.x/el/7/noarch/rabbitmq-server-3.7.8-1.el7.noarch.rpm
	wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/rabbitmq-server-3.7.8-1.el7.noarch.rpm
	yum -y install rabbitmq-server-3.7.8-1.el7.noarch.rpm

##查看rabbitmq-server是否已经安装好了，能查到说明已经安装完成了。
	rpm -qa|grep rabbitmq

###完成后启动服务：
	service rabbitmq-server start
	#service rabbitmq-server stop

###可以查看服务状态：
	service rabbitmq-server status
	
###开放5672端口：
	firewall-cmd --zone=public --add-port=5672/tcp --permanent
	firewall-cmd --reload 	
	
###设置配置文件，并开启用户远程访问
	#cd /etc/rabbitmq 
	#cp /usr/share/doc/rabbitmq-server-3.7.8/rabbitmq.config.example /etc/rabbitmq/  
	#mv rabbitmq.config.example rabbitmq.config 
	#vi /etc/rabbitmq/rabbitmq.config
	##sed -i "s#%% {loopback_users, []},#{loopback_users, []}#g" /etc/rabbitmq/rabbitmq.config
	##将%% {loopback_users, []},修改后-->{loopback_users, []}
 
	cd /etc/rabbitmq 
	cp /usr/share/doc/rabbitmq-server-3.7.8/rabbitmq.config.example /etc/rabbitmq/ 
	echo "[{rabbit, [{loopback_users, []}]}]." >> /etc/rabbitmq/rabbitmq.config
  
###重启rabbit-server服务
   service rabbitmq-server restart

###删除日志文件
	rm -rf /var/log/rabbitmq/rabbit@VM_60_255_centos.log
	service rabbitmq-server stop
	service rabbitmq-server start

###开启管理UI：
	rabbitmq-plugins enable rabbitmq_management
	firewall-cmd --zone=public --add-port=15672/tcp --permanent
	firewall-cmd --reload
  
###登录访问
	echo "在浏览器中输入ip:15672即可出现登录页面，用户名和密码都是guest"

###权限配置
##创建用户
	rabbitmqctl add_user  admin  123456

##赋予角色
	rabbitmqctl set_user_tags admin administrator

#查看用户
	rabbitmqctl list_users

#参考文档
	echo "权限配置参考 http://blog.csdn.net/zyz511919766/article/details/42292655"
