#!/bin/bash
#jdk-8u171-linux-x64.tar.gz
#https://cloud.tencent.com/developer/labs/lab/10045

#1.下载安装 git
#卸载git
yum -y remove git

#安装依赖库和编译工具
yum -y install curl-devel expat-devel gettext-devel openssl-devel zlib-devel
yum -y install gcc perl-ExtUtils-MakeMaker

#下载 git
#安装包放在/usr/local/src目录里
cd /usr/local/src
wget https://www.kernel.org/pub/software/scm/git/git-2.17.1.tar.gz
# download from tencent cloud
#wget https://istorkbox-1256921291.cos.ap-guangzhou.myqcloud.com/git-2.17.1.tar.gz

#解压和编译
#解压下载的源码包
tar -zvxf git-2.17.1.tar.gz

#解压后进入git-2.17.1文件夹
cd /usr/local/src/git-2.17.1

#执行编译
make all prefix=/usr/local/git

#编译完成后,安装到/usr/local/git目录下
make install prefix=/usr/local/git

#2.配置环境变量
#将git目录加入PATH
#将原来的 PATH 指向目录修改为现在的目录
echo 'export PATH=$PATH:/usr/local/git/bin' >> /etc/bashrc

#生效环境变量
source /etc/bashrc

#此时我们能查看 git 版本号，说明我们已经安装成功了。
git --version


#3.创建 git 账号密码
#创建 git 账号
#为我们刚刚搭建好的 git 创建一个账号
#@#useradd -m istorkbox

#然后为这个账号设置密码[默认123456]
#@#echo '控制台输入创建密码后，输入您自定义的密码，并二次确认。'
#@#passwd istorkbox

#4.初始化 git 仓库并配置用户权限
#创建 git 仓库并初始化
#我们创建 /data/repositories 目录用于存放 git 仓库
#@#mkdir -p /data/repositories

#创建好后，初始化这个仓库
#@#cd /data/repositories/ && git init --bare test.git

#配置用户权限
#给 git 仓库目录设置用户和用户组并设置权限

#@#chown -R istorkbox:istorkbox /data/repositories
#@#chmod 755 /data/repositories

#编辑 /etc/passwd 文件，将最后一行关于 istorkbox 的登录 shell 配置改为 git-shell 的目录[?]如下
#如果按照刚才的步骤执行, 这个位置应该是 /usr/local/git/bin/git-shell, 否则请通过 which git-shell 命令查看位置
#安全目的, 限制 git 账号的 ssh 连接只能是登录 git-shell
#@#istorkbox:x:1001:1002::/home/istorkbox:/bin/bash
#修改为
#@#istorkbox:x:500:500::/home/istorkbox:/usr/local/git/bin/git-shell

#使用搭建好的 Git 服务
#克隆 test repo 到本地
#@#cd ~ && git clone istorkbox@localhost:/data/repositories/test.git