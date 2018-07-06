#蓝鲸智云社区版V4.1单机部署体验
#https://cloud.tencent.com/developer/labs/lab/10386
#http://bkopen-10032816.file.myqcloud.com/ce4.0/bkce_src-4.0.15.tgz
#http://bkopen-10032816.file.myqcloud.com/ce4.0/install_ce-master-1.1.44.tgz
#31001-安装提示端口被占用

yum -y update

#获取或设置服务器IP
echo "需手动设置-服务器IP地址"
cat $install_dir/Readme
read -p "what's SERVER_IP ?:" SERVER_IP
echo "Servcie IP: $FASTDFS_TRACKER_SERVER_IP"
read -p "Servcie IP is $SERVER_IP yes or no:" isY
if [ "${isY}" != "y" ] && [ "${isY}" != "Y" ] && [ "${isY}" != "yes" ] && [ "${isY}" != "YES" ];then
exit 1
fi


#环境说明
cd /usr/local/src
install_dir=`pwd`
install_version=nginx-1.15.0
install_ip=`ip addr |grep inet |egrep -v "inet6|127.0.0.1" |awk '{print $2}' |awk -F "/" '{print $1}'`
install_mac=`cat /sys/class/net/eth0/address`
echo "当前目录为:$install_dir"
echo "当前版本为:$install_version"
echo "当前本机IP:$install_ip"

##获取本机MAC地址
##运行以下命令，获取IP地址，并拷贝到剪切板
# cat /sys/class/net/eth0/address
##下载证书并上传到/data/目录下
##打开 http://bk.tencent.com/download/#ssl 复制粘贴MAC地址，[生成下载证书]。
##定位到 /data 目录
##将下载的证书文件，拖拽上传到左侧文件树的/data目录下.
if [ -f 'ssl_certificates.tar.gz' ]; then
	cd /data
	echo "服务器mac:$install_mac,浏览器访问下面地址,下载证书后上传"
	echo "http://bk.tencent.com/generate_ssl/generate/?mac_list=$install_mac&&is_beta=false"
	echo "下载的证书文件ssl_certificates.tar.gz后上传到/data目录"
    exit 1
fi


#软件包：bkce_src-x.x.xx.tgz  
#脚本包：install_ce-master-x.x.xx.tgz
#提示：x.x.xxx 为版本号，随着迭代更新不定
cd /data 
if [ -f 'bkce_src-4.0.15.tgz' ]; then
	wget http://bkopen-10032816.file.myqcloud.com/ce4.0/bkce_src-4.0.15.tgz
	wget http://bkopen-10032816.file.myqcloud.com/ce4.0/install_ce-master-1.1.44.tgz
fi


echo "休眠20s等待下载完成"
sleep 20s

#解压部,软件包较大,解压可能需要一点时间!!!
cd /data
tar -xvf install_ce-master-1.1.44.tgz -C /data/
tar -xvf bkce_src-4.0.15.tgz -C /data/

#解压证书文件到 /data/src/cert 目录
tar -xvf /data/ssl_certificates.tar.gz -C /data/src/cert/

#修改管理员默认密码配置(修改为用户:admin密码:123456,)
#vim /data/install/globals.env
sed -i "s#export PAAS_ADMIN_PASS='Ib=Xkm8ZP\*'#export PAAS_ADMIN_PASS='123456'#g" /data/install/globals.env


#启动安装脚本
cd /data/install 
./install_minibk -y

#执行上面指令后，命令行会出现如下提示：
#enter a absolute path [/data/bkce]:
#直接敲回车继续即可（即默认使用/data/bkce目录）
#根据屏幕文字提示，输入yes接受 （若上一步还在运行中，请稍等片刻）


#配置HOSTS访问蓝鲸
#由于没有实际域名分配，
#所以需要配置你本地PC的hosts文件来访问；
echo "打开你本地电脑里的 [hosts文件]"
echo "windows: C:\windows\system32\drivers\etc\hosts"
echo "linux/mac: /etc/hosts"
echo "将下面3组域名配置复制粘贴至底部，并保存！"
echo "$SERVER_IP paas.blueking.com"
echo "$SERVER_IP cmdb.blueking.com"
echo "$SERVER_IP job.blueking.com"
echo ""
echo "打开下面网址并输入用户名和密码，开始你的蓝鲸之旅吧~"
echo "网　址：http://paas.blueking.com"
echo "用户名：admin"
echo "密　码：123456"
