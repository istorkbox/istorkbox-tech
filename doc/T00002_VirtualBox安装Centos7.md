### 安装

-  安装VirtualBox

  版本(5.1.30.18389)

  [官网下载新版](https://www.virtualbox.org/wiki/Downloads)

  [T00002_VirtualBox-5.1.30.18389-Win.exe](https://share.weiyun.com/5ORLEyQ)

-  下载Centos7

  版本(CentOS-7-x86_64-DVD-1708.iso)

 [官网下载新版DVD ISO](https://www.centos.org/download/)
 
 [安装好的镜像](https://share.weiyun.com/5TTFKcH)

-  VirtualBox新建虚拟机

 ![image](https://github.com/istorkbox/istorkbox-tech/raw/master/doc/images/T00002_virtualbox_centos7_install_1.png)

-  VirtualBox安装Centos7

  安装中root设置密码为:`123456`

 ![image](https://github.com/istorkbox/istorkbox-tech/raw/master/doc/images/T00002_virtualbox_centos7_install_2.png)

- Centos7配置IP地址
 > ifcfg-enp0s3为网卡配置信息文件,示例IP地址配置为如`192.168.1.215`
 
 > 注:centos7中不设置NETMASK=255.255.255.0这样的配置)

`vi /etc/sysconfig/network-scripts/ifcfg-enp0s3`

  修改内容如下:

```
ONBOOT=yes
BOOTPROTO=static
IPADDR=192.168.1.215
PREFIX=24
GATEWAY=192.168.1.1
DNS1=202.96.134.133
DNS2=114.114.114.114
```

  完整内容如下:

```
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
#BOOTPROTO=dhcp
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=enp0s3
UUID=f216139c-b9ef-40a8-8645-bcc4d67cfc7f
DEVICE=enp0s3
ONBOOT=yes
BOOTPROTO=static
IPADDR=192.168.1.215
PREFIX=24
GATEWAY=192.168.1.1
DNS1=202.96.134.133
DNS2=114.114.114.114
```




