### 安装配置

- 下载地址

 http://bbs.coc.tencent.com/forum.php

 [T00004_zhiyunlite-1.1.0-201805171745.tar.gz](https://share.weiyun.com/5xuZDi1)

- 干净的标准系统下一键安装方式

 (支持能联网下载依赖包的标准CentOS 7.4或Ubuntu 16.04系统)

 解压安装包执行安装脚本

 `./install.sh`

- 访问地址

 如:部署的IP为192.168.1.215

 默认admin账号的密码在/root/.zhiyunlite_password文件中(已修为12345678)

 `http://192.168.1.215`

- 将密钥分发到对应的被管理机上

 在织云Lite **设备->密钥管理**页面 ，选择相应的密钥，点击**下载公钥**, 之后将下载的公钥文件(如:xxx.pub)的内容追加到被管理机上root用户所在根目录下的`~/.ssh/`文件里

 有几种方法：(假设公钥文件名为default.pub)

 1. 使用ssh-copy-id命令

 `ssh-copy-id -i ~/.ssh/default.pub root@被管理机IP`

 2. 将公钥通过scp等方式拷贝到被管理机上，在被管理机上以root身份执行

 `cat default.pub >> ~/.ssh/authorized_keys`

 提示：如果.ssh目录不存在，需要先创建:

 `mkdir -p ~/.ssh`

 `chmod 0700 ~/.ssh`

### 安装过程

``` shell

[root@localhost /]# cd /opt/www
[root@localhost www]# ll
total 15856
drwxr-xr-x 4 1000 1000     4096 May 17 05:45 zhiyunlite-1.1.0
-rw-r--r-- 1 root root 16229611 May 27 21:57 zhiyunlite-1.1.0-201805171745.tar.gz
[root@localhost www]# 
[root@localhost www]# cd zhiyunlite-1.1.0
[root@localhost zhiyunlite-1.1.0]# ll
total 76
-rwxr-xr-x  1 1000 1000  2173 May 17 03:23 check_install.sh
-rwxr-xr-x  1 1000 1000  1940 May 17 03:23 create_helloworld_package.sh
-rwxr-xr-x  1 1000 1000  2513 May 17 03:23 create_metis_package.sh
-rw-r--r--  1 1000 1000 18692 May 17 03:23 EULA.txt
drwxr-xr-x  6 1000 1000    63 May 17 03:23 example_conf
-rwxr-xr-x  1 1000 1000   994 May 17 03:23 import_ssh_default_key.sh
-rw-r--r--  1 1000 1000   857 May 17 03:23 INSTALL
-rw-r--r--  1 1000 1000  4747 May 17 05:45 install_for_centos_74.txt
-rw-r--r--  1 1000 1000  4363 May 17 05:45 install_for_ubuntu_1604.txt
-rwxr-xr-x  1 1000 1000  7990 May 17 03:23 install.sh
-rw-r--r--  1 1000 1000  2312 May 17 05:45 metis_agent.tar.gz
-rw-r--r--  1 1000 1000  1925 May 17 03:23 README
drwxr-xr-x 12 1000 1000   271 May 17 05:45 src
-rwxr-xr-x  1 1000 1000  1383 May 17 03:23 update_1.0.0-1.1.0.sh
[root@localhost zhiyunlite-1.1.0]# ./install.sh 
add epel repository...
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirrors.aliyun.com
 * extras: mirrors.cn99.com
 * updates: mirrors.aliyun.com
Resolving Dependencies
--> Running transaction check
---> Package epel-release.noarch 0:7-11 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

====================================================================================================================================================
 Package                                 Arch                              Version                          Repository                         Size
====================================================================================================================================================
Installing:
 epel-release                            noarch                            7-11                             extras                             15 k

Transaction Summary
====================================================================================================================================================
Install  1 Package

Total download size: 15 k
Installed size: 24 k
Downloading packages:
epel-release-7-11.noarch.rpm                                                                                                 |  15 kB  00:00:00     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : epel-release-7-11.noarch                                                                                                         1/1 
  Verifying  : epel-release-7-11.noarch                                                                                                         1/1 

Installed:
  epel-release.noarch 0:7-11                                                                                                                        

Complete!
firewall open 80 port
success
success
install nginx
Loaded plugins: fastestmirror
epel/x86_64/metalink                                                                                                         | 6.4 kB  00:00:00     
epel                                                                                                                         | 4.7 kB  00:00:00     
(1/3): epel/x86_64/group_gz                                                                                                  |  88 kB  00:00:00     
(2/3): epel/x86_64/updateinfo                                                                                                | 930 kB  00:00:00     
(3/3): epel/x86_64/primary_db                                                                                                | 6.4 MB  00:00:01     
Loading mirror speeds from cached hostfile
 * base: mirrors.aliyun.com
 * epel: mirrors.ustc.edu.cn
 * extras: mirrors.cn99.com
 * updates: mirrors.aliyun.com
Resolving Dependencies
--> Running transaction check
---> Package nginx.x86_64 1:1.12.2-2.el7 will be installed
--> Processing Dependency: nginx-all-modules = 1:1.12.2-2.el7 for package: 1:nginx-1.12.2-2.el7.x86_64
--> Processing Dependency: nginx-filesystem = 1:1.12.2-2.el7 for package: 1:nginx-1.12.2-2.el7.x86_64
--> Processing Dependency: nginx-filesystem for package: 1:nginx-1.12.2-2.el7.x86_64
--> Processing Dependency: libprofiler.so.0()(64bit) for package: 1:nginx-1.12.2-2.el7.x86_64
--> Running transaction check
---> Package gperftools-libs.x86_64 0:2.6.1-1.el7 will be installed
---> Package nginx-all-modules.noarch 1:1.12.2-2.el7 will be installed
--> Processing Dependency: nginx-mod-http-geoip = 1:1.12.2-2.el7 for package: 1:nginx-all-modules-1.12.2-2.el7.noarch
--> Processing Dependency: nginx-mod-http-image-filter = 1:1.12.2-2.el7 for package: 1:nginx-all-modules-1.12.2-2.el7.noarch
--> Processing Dependency: nginx-mod-http-perl = 1:1.12.2-2.el7 for package: 1:nginx-all-modules-1.12.2-2.el7.noarch
--> Processing Dependency: nginx-mod-http-xslt-filter = 1:1.12.2-2.el7 for package: 1:nginx-all-modules-1.12.2-2.el7.noarch
--> Processing Dependency: nginx-mod-mail = 1:1.12.2-2.el7 for package: 1:nginx-all-modules-1.12.2-2.el7.noarch
--> Processing Dependency: nginx-mod-stream = 1:1.12.2-2.el7 for package: 1:nginx-all-modules-1.12.2-2.el7.noarch
---> Package nginx-filesystem.noarch 1:1.12.2-2.el7 will be installed
--> Running transaction check
---> Package nginx-mod-http-geoip.x86_64 1:1.12.2-2.el7 will be installed
---> Package nginx-mod-http-image-filter.x86_64 1:1.12.2-2.el7 will be installed
--> Processing Dependency: gd for package: 1:nginx-mod-http-image-filter-1.12.2-2.el7.x86_64
--> Processing Dependency: libgd.so.2()(64bit) for package: 1:nginx-mod-http-image-filter-1.12.2-2.el7.x86_64
---> Package nginx-mod-http-perl.x86_64 1:1.12.2-2.el7 will be installed
---> Package nginx-mod-http-xslt-filter.x86_64 1:1.12.2-2.el7 will be installed
--> Processing Dependency: libxslt.so.1(LIBXML2_1.0.11)(64bit) for package: 1:nginx-mod-http-xslt-filter-1.12.2-2.el7.x86_64
--> Processing Dependency: libxslt.so.1(LIBXML2_1.0.18)(64bit) for package: 1:nginx-mod-http-xslt-filter-1.12.2-2.el7.x86_64
--> Processing Dependency: libexslt.so.0()(64bit) for package: 1:nginx-mod-http-xslt-filter-1.12.2-2.el7.x86_64
--> Processing Dependency: libxslt.so.1()(64bit) for package: 1:nginx-mod-http-xslt-filter-1.12.2-2.el7.x86_64
---> Package nginx-mod-mail.x86_64 1:1.12.2-2.el7 will be installed
---> Package nginx-mod-stream.x86_64 1:1.12.2-2.el7 will be installed
--> Running transaction check
---> Package gd.x86_64 0:2.0.35-26.el7 will be installed
--> Processing Dependency: libpng15.so.15(PNG15_0)(64bit) for package: gd-2.0.35-26.el7.x86_64
--> Processing Dependency: libjpeg.so.62(LIBJPEG_6.2)(64bit) for package: gd-2.0.35-26.el7.x86_64
--> Processing Dependency: libpng15.so.15()(64bit) for package: gd-2.0.35-26.el7.x86_64
--> Processing Dependency: libjpeg.so.62()(64bit) for package: gd-2.0.35-26.el7.x86_64
--> Processing Dependency: libfontconfig.so.1()(64bit) for package: gd-2.0.35-26.el7.x86_64
--> Processing Dependency: libXpm.so.4()(64bit) for package: gd-2.0.35-26.el7.x86_64
--> Processing Dependency: libX11.so.6()(64bit) for package: gd-2.0.35-26.el7.x86_64
---> Package libxslt.x86_64 0:1.1.28-5.el7 will be installed
--> Running transaction check
---> Package fontconfig.x86_64 0:2.10.95-11.el7 will be installed
--> Processing Dependency: fontpackages-filesystem for package: fontconfig-2.10.95-11.el7.x86_64
--> Processing Dependency: font(:lang=en) for package: fontconfig-2.10.95-11.el7.x86_64
---> Package libX11.x86_64 0:1.6.5-1.el7 will be installed
--> Processing Dependency: libX11-common >= 1.6.5-1.el7 for package: libX11-1.6.5-1.el7.x86_64
--> Processing Dependency: libxcb.so.1()(64bit) for package: libX11-1.6.5-1.el7.x86_64
---> Package libXpm.x86_64 0:3.5.12-1.el7 will be installed
---> Package libjpeg-turbo.x86_64 0:1.2.90-5.el7 will be installed
---> Package libpng.x86_64 2:1.5.13-7.el7_2 will be installed
--> Running transaction check
---> Package fontpackages-filesystem.noarch 0:1.44-8.el7 will be installed
---> Package libX11-common.noarch 0:1.6.5-1.el7 will be installed
---> Package libxcb.x86_64 0:1.12-1.el7 will be installed
--> Processing Dependency: libXau.so.6()(64bit) for package: libxcb-1.12-1.el7.x86_64
---> Package lyx-fonts.noarch 0:2.2.3-1.el7 will be installed
--> Running transaction check
---> Package libXau.x86_64 0:1.0.8-2.1.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

====================================================================================================================================================
 Package                                          Arch                        Version                               Repository                 Size
====================================================================================================================================================
Installing:
 nginx                                            x86_64                      1:1.12.2-2.el7                        epel                      530 k
Installing for dependencies:
 fontconfig                                       x86_64                      2.10.95-11.el7                        base                      229 k
 fontpackages-filesystem                          noarch                      1.44-8.el7                            base                      9.9 k
 gd                                               x86_64                      2.0.35-26.el7                         base                      146 k
 gperftools-libs                                  x86_64                      2.6.1-1.el7                           base                      272 k
 libX11                                           x86_64                      1.6.5-1.el7                           base                      606 k
 libX11-common                                    noarch                      1.6.5-1.el7                           base                      164 k
 libXau                                           x86_64                      1.0.8-2.1.el7                         base                       29 k
 libXpm                                           x86_64                      3.5.12-1.el7                          base                       55 k
 libjpeg-turbo                                    x86_64                      1.2.90-5.el7                          base                      134 k
 libpng                                           x86_64                      2:1.5.13-7.el7_2                      base                      213 k
 libxcb                                           x86_64                      1.12-1.el7                            base                      211 k
 libxslt                                          x86_64                      1.1.28-5.el7                          base                      242 k
 lyx-fonts                                        noarch                      2.2.3-1.el7                           epel                      159 k
 nginx-all-modules                                noarch                      1:1.12.2-2.el7                        epel                       16 k
 nginx-filesystem                                 noarch                      1:1.12.2-2.el7                        epel                       17 k
 nginx-mod-http-geoip                             x86_64                      1:1.12.2-2.el7                        epel                       23 k
 nginx-mod-http-image-filter                      x86_64                      1:1.12.2-2.el7                        epel                       26 k
 nginx-mod-http-perl                              x86_64                      1:1.12.2-2.el7                        epel                       36 k
 nginx-mod-http-xslt-filter                       x86_64                      1:1.12.2-2.el7                        epel                       26 k
 nginx-mod-mail                                   x86_64                      1:1.12.2-2.el7                        epel                       54 k
 nginx-mod-stream                                 x86_64                      1:1.12.2-2.el7                        epel                       76 k

Transaction Summary
====================================================================================================================================================
Install  1 Package (+21 Dependent packages)

Total download size: 3.2 M
Installed size: 9.6 M
Downloading packages:
(1/22): fontpackages-filesystem-1.44-8.el7.noarch.rpm                                                                        | 9.9 kB  00:00:00     
(2/22): fontconfig-2.10.95-11.el7.x86_64.rpm                                                                                 | 229 kB  00:00:00     
(3/22): gd-2.0.35-26.el7.x86_64.rpm                                                                                          | 146 kB  00:00:00     
(4/22): libX11-1.6.5-1.el7.x86_64.rpm                                                                                        | 606 kB  00:00:00     
(5/22): libXau-1.0.8-2.1.el7.x86_64.rpm                                                                                      |  29 kB  00:00:00     
(6/22): gperftools-libs-2.6.1-1.el7.x86_64.rpm                                                                               | 272 kB  00:00:00     
(7/22): libX11-common-1.6.5-1.el7.noarch.rpm                                                                                 | 164 kB  00:00:00     
(8/22): libXpm-3.5.12-1.el7.x86_64.rpm                                                                                       |  55 kB  00:00:00     
(9/22): libjpeg-turbo-1.2.90-5.el7.x86_64.rpm                                                                                | 134 kB  00:00:00     
(10/22): libxslt-1.1.28-5.el7.x86_64.rpm                                                                                     | 242 kB  00:00:00     
(11/22): libxcb-1.12-1.el7.x86_64.rpm                                                                                        | 211 kB  00:00:00     
warning: /var/cache/yum/x86_64/7/epel/packages/lyx-fonts-2.2.3-1.el7.noarch.rpm: Header V3 RSA/SHA256 Signature, key ID 352c64e5: NOKEY
Public key for lyx-fonts-2.2.3-1.el7.noarch.rpm is not installed
(12/22): lyx-fonts-2.2.3-1.el7.noarch.rpm                                                                                    | 159 kB  00:00:00     
(13/22): libpng-1.5.13-7.el7_2.x86_64.rpm                                                                                    | 213 kB  00:00:01     
(14/22): nginx-1.12.2-2.el7.x86_64.rpm                                                                                       | 530 kB  00:00:00     
(15/22): nginx-all-modules-1.12.2-2.el7.noarch.rpm                                                                           |  16 kB  00:00:00     
(16/22): nginx-filesystem-1.12.2-2.el7.noarch.rpm                                                                            |  17 kB  00:00:00     
(17/22): nginx-mod-http-geoip-1.12.2-2.el7.x86_64.rpm                                                                        |  23 kB  00:00:00     
(18/22): nginx-mod-http-image-filter-1.12.2-2.el7.x86_64.rpm                                                                 |  26 kB  00:00:00     
(19/22): nginx-mod-http-perl-1.12.2-2.el7.x86_64.rpm                                                                         |  36 kB  00:00:00     
(20/22): nginx-mod-http-xslt-filter-1.12.2-2.el7.x86_64.rpm                                                                  |  26 kB  00:00:00     
(21/22): nginx-mod-mail-1.12.2-2.el7.x86_64.rpm                                                                              |  54 kB  00:00:00     
(22/22): nginx-mod-stream-1.12.2-2.el7.x86_64.rpm                                                                            |  76 kB  00:00:00     
----------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                               977 kB/s | 3.2 MB  00:00:03     
Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
Importing GPG key 0x352C64E5:
 Userid     : "Fedora EPEL (7) <epel@fedoraproject.org>"
 Fingerprint: 91e9 7d7c 4a5e 96f1 7f3e 888f 6a2f aea2 352c 64e5
 Package    : epel-release-7-11.noarch (@extras)
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : fontpackages-filesystem-1.44-8.el7.noarch                                                                                       1/22 
  Installing : lyx-fonts-2.2.3-1.el7.noarch                                                                                                    2/22 
  Installing : fontconfig-2.10.95-11.el7.x86_64                                                                                                3/22 
  Installing : gperftools-libs-2.6.1-1.el7.x86_64                                                                                              4/22 
  Installing : libXau-1.0.8-2.1.el7.x86_64                                                                                                     5/22 
  Installing : libxcb-1.12-1.el7.x86_64                                                                                                        6/22 
  Installing : libX11-common-1.6.5-1.el7.noarch                                                                                                7/22 
  Installing : libX11-1.6.5-1.el7.x86_64                                                                                                       8/22 
  Installing : libXpm-3.5.12-1.el7.x86_64                                                                                                      9/22 
  Installing : libxslt-1.1.28-5.el7.x86_64                                                                                                    10/22 
  Installing : 1:nginx-filesystem-1.12.2-2.el7.noarch                                                                                         11/22 
  Installing : 2:libpng-1.5.13-7.el7_2.x86_64                                                                                                 12/22 
  Installing : libjpeg-turbo-1.2.90-5.el7.x86_64                                                                                              13/22 
  Installing : gd-2.0.35-26.el7.x86_64                                                                                                        14/22 
  Installing : 1:nginx-mod-http-xslt-filter-1.12.2-2.el7.x86_64                                                                               15/22 
  Installing : 1:nginx-mod-http-geoip-1.12.2-2.el7.x86_64                                                                                     16/22 
  Installing : 1:nginx-mod-stream-1.12.2-2.el7.x86_64                                                                                         17/22 
  Installing : 1:nginx-mod-mail-1.12.2-2.el7.x86_64                                                                                           18/22 
  Installing : 1:nginx-mod-http-perl-1.12.2-2.el7.x86_64                                                                                      19/22 
  Installing : 1:nginx-1.12.2-2.el7.x86_64                                                                                                    20/22 
  Installing : 1:nginx-mod-http-image-filter-1.12.2-2.el7.x86_64                                                                              21/22 
  Installing : 1:nginx-all-modules-1.12.2-2.el7.noarch                                                                                        22/22 
  Verifying  : libX11-1.6.5-1.el7.x86_64                                                                                                       1/22 
  Verifying  : lyx-fonts-2.2.3-1.el7.noarch                                                                                                    2/22 
  Verifying  : 1:nginx-mod-http-xslt-filter-1.12.2-2.el7.x86_64                                                                                3/22 
  Verifying  : libjpeg-turbo-1.2.90-5.el7.x86_64                                                                                               4/22 
  Verifying  : 1:nginx-mod-http-geoip-1.12.2-2.el7.x86_64                                                                                      5/22 
  Verifying  : 1:nginx-1.12.2-2.el7.x86_64                                                                                                     6/22 
  Verifying  : libxcb-1.12-1.el7.x86_64                                                                                                        7/22 
  Verifying  : 2:libpng-1.5.13-7.el7_2.x86_64                                                                                                  8/22 
  Verifying  : fontpackages-filesystem-1.44-8.el7.noarch                                                                                       9/22 
  Verifying  : 1:nginx-mod-stream-1.12.2-2.el7.x86_64                                                                                         10/22 
  Verifying  : 1:nginx-all-modules-1.12.2-2.el7.noarch                                                                                        11/22 
  Verifying  : libXpm-3.5.12-1.el7.x86_64                                                                                                     12/22 
  Verifying  : 1:nginx-filesystem-1.12.2-2.el7.noarch                                                                                         13/22 
  Verifying  : libxslt-1.1.28-5.el7.x86_64                                                                                                    14/22 
  Verifying  : 1:nginx-mod-mail-1.12.2-2.el7.x86_64                                                                                           15/22 
  Verifying  : gd-2.0.35-26.el7.x86_64                                                                                                        16/22 
  Verifying  : libX11-common-1.6.5-1.el7.noarch                                                                                               17/22 
  Verifying  : libXau-1.0.8-2.1.el7.x86_64                                                                                                    18/22 
  Verifying  : fontconfig-2.10.95-11.el7.x86_64                                                                                               19/22 
  Verifying  : gperftools-libs-2.6.1-1.el7.x86_64                                                                                             20/22 
  Verifying  : 1:nginx-mod-http-perl-1.12.2-2.el7.x86_64                                                                                      21/22 
  Verifying  : 1:nginx-mod-http-image-filter-1.12.2-2.el7.x86_64                                                                              22/22 

Installed:
  nginx.x86_64 1:1.12.2-2.el7                                                                                                                       

Dependency Installed:
  fontconfig.x86_64 0:2.10.95-11.el7                 fontpackages-filesystem.noarch 0:1.44-8.el7         gd.x86_64 0:2.0.35-26.el7                  
  gperftools-libs.x86_64 0:2.6.1-1.el7               libX11.x86_64 0:1.6.5-1.el7                         libX11-common.noarch 0:1.6.5-1.el7         
  libXau.x86_64 0:1.0.8-2.1.el7                      libXpm.x86_64 0:3.5.12-1.el7                        libjpeg-turbo.x86_64 0:1.2.90-5.el7        
  libpng.x86_64 2:1.5.13-7.el7_2                     libxcb.x86_64 0:1.12-1.el7                          libxslt.x86_64 0:1.1.28-5.el7              
  lyx-fonts.noarch 0:2.2.3-1.el7                     nginx-all-modules.noarch 1:1.12.2-2.el7             nginx-filesystem.noarch 1:1.12.2-2.el7     
  nginx-mod-http-geoip.x86_64 1:1.12.2-2.el7         nginx-mod-http-image-filter.x86_64 1:1.12.2-2.el7   nginx-mod-http-perl.x86_64 1:1.12.2-2.el7  
  nginx-mod-http-xslt-filter.x86_64 1:1.12.2-2.el7   nginx-mod-mail.x86_64 1:1.12.2-2.el7                nginx-mod-stream.x86_64 1:1.12.2-2.el7     

Complete!
insall php
Retrieving https://rpms.remirepo.net/enterprise/remi-release-7.rpm
warning: /var/tmp/rpm-tmp.eoxd6o: Header V4 DSA/SHA1 Signature, key ID 00f97f56: NOKEY
Preparing...                          ################################# [100%]
Updating / installing...
   1:remi-release-7.4-2.el7.remi      ################################# [100%]
Loaded plugins: fastestmirror
remi-php71                                                                                                                   | 2.9 kB  00:00:00     
remi-safe                                                                                                                    | 2.9 kB  00:00:00     
(1/2): remi-php71/primary_db                                                                                                 | 218 kB  00:00:00     
(2/2): remi-safe/primary_db                                                                                                  | 1.2 MB  00:00:00     
Loading mirror speeds from cached hostfile
 * base: mirrors.aliyun.com
 * epel: mirrors.tuna.tsinghua.edu.cn
 * extras: mirrors.cn99.com
 * remi-php71: mirrors.tuna.tsinghua.edu.cn
 * remi-safe: mirrors.tuna.tsinghua.edu.cn
 * updates: mirrors.aliyun.com
Package php-mysql is obsoleted by php-mysqlnd, trying to install php-mysqlnd-7.1.18-1.el7.remi.x86_64 instead
Resolving Dependencies
--> Running transaction check
---> Package php-cli.x86_64 0:7.1.18-1.el7.remi will be installed
--> Processing Dependency: php-common(x86-64) = 7.1.18-1.el7.remi for package: php-cli-7.1.18-1.el7.remi.x86_64
---> Package php-fpm.x86_64 0:7.1.18-1.el7.remi will be installed
---> Package php-mbstring.x86_64 0:7.1.18-1.el7.remi will be installed
---> Package php-mysqlnd.x86_64 0:7.1.18-1.el7.remi will be installed
---> Package php-pdo.x86_64 0:7.1.18-1.el7.remi will be installed
--> Running transaction check
---> Package php-common.x86_64 0:7.1.18-1.el7.remi will be installed
--> Processing Dependency: php-json(x86-64) = 7.1.18-1.el7.remi for package: php-common-7.1.18-1.el7.remi.x86_64
--> Running transaction check
---> Package php-json.x86_64 0:7.1.18-1.el7.remi will be installed
--> Finished Dependency Resolution

Dependencies Resolved

====================================================================================================================================================
 Package                             Arch                          Version                                  Repository                         Size
====================================================================================================================================================
Installing:
 php-cli                             x86_64                        7.1.18-1.el7.remi                        remi-php71                        4.6 M
 php-fpm                             x86_64                        7.1.18-1.el7.remi                        remi-php71                        1.6 M
 php-mbstring                        x86_64                        7.1.18-1.el7.remi                        remi-php71                        577 k
 php-mysqlnd                         x86_64                        7.1.18-1.el7.remi                        remi-php71                        229 k
 php-pdo                             x86_64                        7.1.18-1.el7.remi                        remi-php71                        123 k
Installing for dependencies:
 php-common                          x86_64                        7.1.18-1.el7.remi                        remi-php71                        1.0 M
 php-json                            x86_64                        7.1.18-1.el7.remi                        remi-php71                         60 k

Transaction Summary
====================================================================================================================================================
Install  5 Packages (+2 Dependent packages)

Total download size: 8.1 M
Installed size: 31 M
Downloading packages:
warning: /var/cache/yum/x86_64/7/remi-php71/packages/php-common-7.1.18-1.el7.remi.x86_64.rpm: Header V4 DSA/SHA1 Signature, key ID 00f97f56: NOKEYA 
Public key for php-common-7.1.18-1.el7.remi.x86_64.rpm is not installed
(1/7): php-common-7.1.18-1.el7.remi.x86_64.rpm                                                                               | 1.0 MB  00:00:00     
(2/7): php-cli-7.1.18-1.el7.remi.x86_64.rpm                                                                                  | 4.6 MB  00:00:01     
(3/7): php-fpm-7.1.18-1.el7.remi.x86_64.rpm                                                                                  | 1.6 MB  00:00:00     
(4/7): php-json-7.1.18-1.el7.remi.x86_64.rpm                                                                                 |  60 kB  00:00:00     
(5/7): php-mbstring-7.1.18-1.el7.remi.x86_64.rpm                                                                             | 577 kB  00:00:00     
(6/7): php-mysqlnd-7.1.18-1.el7.remi.x86_64.rpm                                                                              | 229 kB  00:00:00     
(7/7): php-pdo-7.1.18-1.el7.remi.x86_64.rpm                                                                                  | 123 kB  00:00:00     
----------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                               5.2 MB/s | 8.1 MB  00:00:01     
Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-remi
Importing GPG key 0x00F97F56:
 Userid     : "Remi Collet <RPMS@FamilleCollet.com>"
 Fingerprint: 1ee0 4cce 88a4 ae4a a29a 5df5 004e 6f47 00f9 7f56
 Package    : remi-release-7.4-2.el7.remi.noarch (installed)
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-remi
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
Warning: RPMDB altered outside of yum.
  Installing : php-common-7.1.18-1.el7.remi.x86_64                                                                                              1/7 
  Installing : php-json-7.1.18-1.el7.remi.x86_64                                                                                                2/7 
  Installing : php-pdo-7.1.18-1.el7.remi.x86_64                                                                                                 3/7 
  Installing : php-mysqlnd-7.1.18-1.el7.remi.x86_64                                                                                             4/7 
  Installing : php-mbstring-7.1.18-1.el7.remi.x86_64                                                                                            5/7 
  Installing : php-cli-7.1.18-1.el7.remi.x86_64                                                                                                 6/7 
  Installing : php-fpm-7.1.18-1.el7.remi.x86_64                                                                                                 7/7 
  Verifying  : php-json-7.1.18-1.el7.remi.x86_64                                                                                                1/7 
  Verifying  : php-mysqlnd-7.1.18-1.el7.remi.x86_64                                                                                             2/7 
  Verifying  : php-mbstring-7.1.18-1.el7.remi.x86_64                                                                                            3/7 
  Verifying  : php-pdo-7.1.18-1.el7.remi.x86_64                                                                                                 4/7 
  Verifying  : php-cli-7.1.18-1.el7.remi.x86_64                                                                                                 5/7 
  Verifying  : php-common-7.1.18-1.el7.remi.x86_64                                                                                              6/7 
  Verifying  : php-fpm-7.1.18-1.el7.remi.x86_64                                                                                                 7/7 

Installed:
  php-cli.x86_64 0:7.1.18-1.el7.remi                php-fpm.x86_64 0:7.1.18-1.el7.remi            php-mbstring.x86_64 0:7.1.18-1.el7.remi           
  php-mysqlnd.x86_64 0:7.1.18-1.el7.remi            php-pdo.x86_64 0:7.1.18-1.el7.remi           

Dependency Installed:
  php-common.x86_64 0:7.1.18-1.el7.remi                                     php-json.x86_64 0:7.1.18-1.el7.remi                                    

Complete!
install git
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirrors.aliyun.com
 * epel: mirrors.ustc.edu.cn
 * extras: mirrors.cn99.com
 * remi-safe: mirrors.tuna.tsinghua.edu.cn
 * updates: mirrors.aliyun.com
Resolving Dependencies
--> Running transaction check
---> Package git.x86_64 0:1.8.3.1-13.el7 will be installed
--> Processing Dependency: perl-Git = 1.8.3.1-13.el7 for package: git-1.8.3.1-13.el7.x86_64
--> Processing Dependency: rsync for package: git-1.8.3.1-13.el7.x86_64
--> Processing Dependency: perl(Term::ReadKey) for package: git-1.8.3.1-13.el7.x86_64
--> Processing Dependency: perl(Git) for package: git-1.8.3.1-13.el7.x86_64
--> Processing Dependency: perl(Error) for package: git-1.8.3.1-13.el7.x86_64
--> Processing Dependency: libgnome-keyring.so.0()(64bit) for package: git-1.8.3.1-13.el7.x86_64
---> Package python2-click.noarch 0:6.7-6.el7 will be installed
--> Running transaction check
---> Package libgnome-keyring.x86_64 0:3.12.0-1.el7 will be installed
---> Package perl-Error.noarch 1:0.17020-2.el7 will be installed
---> Package perl-Git.noarch 0:1.8.3.1-13.el7 will be installed
---> Package perl-TermReadKey.x86_64 0:2.30-20.el7 will be installed
---> Package rsync.x86_64 0:3.1.2-4.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

====================================================================================================================================================
 Package                                  Arch                           Version                                 Repository                    Size
====================================================================================================================================================
Installing:
 git                                      x86_64                         1.8.3.1-13.el7                          base                         4.4 M
 python2-click                            noarch                         6.7-6.el7                               epel                         126 k
Installing for dependencies:
 libgnome-keyring                         x86_64                         3.12.0-1.el7                            base                         109 k
 perl-Error                               noarch                         1:0.17020-2.el7                         base                          32 k
 perl-Git                                 noarch                         1.8.3.1-13.el7                          base                          54 k
 perl-TermReadKey                         x86_64                         2.30-20.el7                             base                          31 k
 rsync                                    x86_64                         3.1.2-4.el7                             base                         403 k

Transaction Summary
====================================================================================================================================================
Install  2 Packages (+5 Dependent packages)

Total download size: 5.1 M
Installed size: 24 M
Downloading packages:
(1/7): perl-Error-0.17020-2.el7.noarch.rpm                                                                                   |  32 kB  00:00:00     
(2/7): perl-TermReadKey-2.30-20.el7.x86_64.rpm                                                                               |  31 kB  00:00:00     
(3/7): perl-Git-1.8.3.1-13.el7.noarch.rpm                                                                                    |  54 kB  00:00:00     
(4/7): libgnome-keyring-3.12.0-1.el7.x86_64.rpm                                                                              | 109 kB  00:00:00     
(5/7): rsync-3.1.2-4.el7.x86_64.rpm                                                                                          | 403 kB  00:00:00     
(6/7): python2-click-6.7-6.el7.noarch.rpm                                                                                    | 126 kB  00:00:00     
(7/7): git-1.8.3.1-13.el7.x86_64.rpm                                                                                         | 4.4 MB  00:00:01     
----------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                               4.2 MB/s | 5.1 MB  00:00:01     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : 1:perl-Error-0.17020-2.el7.noarch                                                                                                1/7 
  Installing : rsync-3.1.2-4.el7.x86_64                                                                                                         2/7 
  Installing : perl-TermReadKey-2.30-20.el7.x86_64                                                                                              3/7 
  Installing : libgnome-keyring-3.12.0-1.el7.x86_64                                                                                             4/7 
  Installing : perl-Git-1.8.3.1-13.el7.noarch                                                                                                   5/7 
  Installing : git-1.8.3.1-13.el7.x86_64                                                                                                        6/7 
  Installing : python2-click-6.7-6.el7.noarch                                                                                                   7/7 
  Verifying  : python2-click-6.7-6.el7.noarch                                                                                                   1/7 
  Verifying  : libgnome-keyring-3.12.0-1.el7.x86_64                                                                                             2/7 
  Verifying  : perl-TermReadKey-2.30-20.el7.x86_64                                                                                              3/7 
  Verifying  : 1:perl-Error-0.17020-2.el7.noarch                                                                                                4/7 
  Verifying  : perl-Git-1.8.3.1-13.el7.noarch                                                                                                   5/7 
  Verifying  : rsync-3.1.2-4.el7.x86_64                                                                                                         6/7 
  Verifying  : git-1.8.3.1-13.el7.x86_64                                                                                                        7/7 

Installed:
  git.x86_64 0:1.8.3.1-13.el7                                            python2-click.noarch 0:6.7-6.el7                                           

Dependency Installed:
  libgnome-keyring.x86_64 0:3.12.0-1.el7 perl-Error.noarch 1:0.17020-2.el7 perl-Git.noarch 0:1.8.3.1-13.el7 perl-TermReadKey.x86_64 0:2.30-20.el7
  rsync.x86_64 0:3.1.2-4.el7            

Complete!
install redis
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirrors.aliyun.com
 * epel: mirrors.ustc.edu.cn
 * extras: mirrors.cn99.com
 * remi-safe: mirrors.tuna.tsinghua.edu.cn
 * updates: mirrors.aliyun.com
Resolving Dependencies
--> Running transaction check
---> Package redis.x86_64 0:3.2.10-2.el7 will be installed
--> Processing Dependency: libjemalloc.so.1()(64bit) for package: redis-3.2.10-2.el7.x86_64
--> Running transaction check
---> Package jemalloc.x86_64 0:3.6.0-1.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

====================================================================================================================================================
 Package                            Arch                             Version                                   Repository                      Size
====================================================================================================================================================
Installing:
 redis                              x86_64                           3.2.10-2.el7                              epel                           545 k
Installing for dependencies:
 jemalloc                           x86_64                           3.6.0-1.el7                               epel                           105 k

Transaction Summary
====================================================================================================================================================
Install  1 Package (+1 Dependent package)

Total download size: 650 k
Installed size: 1.7 M
Downloading packages:
(1/2): jemalloc-3.6.0-1.el7.x86_64.rpm                                                                                       | 105 kB  00:00:01     
(2/2): redis-3.2.10-2.el7.x86_64.rpm                                                                                         | 545 kB  00:00:00     
----------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                               306 kB/s | 650 kB  00:00:02     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : jemalloc-3.6.0-1.el7.x86_64                                                                                                      1/2 
  Installing : redis-3.2.10-2.el7.x86_64                                                                                                        2/2 
  Verifying  : redis-3.2.10-2.el7.x86_64                                                                                                        1/2 
  Verifying  : jemalloc-3.6.0-1.el7.x86_64                                                                                                      2/2 

Installed:
  redis.x86_64 0:3.2.10-2.el7                                                                                                                       

Dependency Installed:
  jemalloc.x86_64 0:3.6.0-1.el7                                                                                                                     

Complete!
install supervisor
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirrors.aliyun.com
 * epel: mirrors.ustc.edu.cn
 * extras: mirrors.cn99.com
 * remi-safe: mirrors.tuna.tsinghua.edu.cn
 * updates: mirrors.aliyun.com
Resolving Dependencies
--> Running transaction check
---> Package supervisor.noarch 0:3.1.4-1.el7 will be installed
--> Processing Dependency: python-meld3 >= 0.6.5 for package: supervisor-3.1.4-1.el7.noarch
--> Processing Dependency: python-setuptools for package: supervisor-3.1.4-1.el7.noarch
--> Running transaction check
---> Package python-meld3.x86_64 0:0.6.10-1.el7 will be installed
---> Package python-setuptools.noarch 0:0.9.8-7.el7 will be installed
--> Processing Dependency: python-backports-ssl_match_hostname for package: python-setuptools-0.9.8-7.el7.noarch
--> Running transaction check
---> Package python-backports-ssl_match_hostname.noarch 0:3.5.0.1-1.el7 will be installed
--> Processing Dependency: python-ipaddress for package: python-backports-ssl_match_hostname-3.5.0.1-1.el7.noarch
--> Processing Dependency: python-backports for package: python-backports-ssl_match_hostname-3.5.0.1-1.el7.noarch
--> Running transaction check
---> Package python-backports.x86_64 0:1.0-8.el7 will be installed
---> Package python-ipaddress.noarch 0:1.0.16-2.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

====================================================================================================================================================
 Package                                                Arch                      Version                             Repository               Size
====================================================================================================================================================
Installing:
 supervisor                                             noarch                    3.1.4-1.el7                         epel                    446 k
Installing for dependencies:
 python-backports                                       x86_64                    1.0-8.el7                           base                    5.8 k
 python-backports-ssl_match_hostname                    noarch                    3.5.0.1-1.el7                       base                     13 k
 python-ipaddress                                       noarch                    1.0.16-2.el7                        base                     34 k
 python-meld3                                           x86_64                    0.6.10-1.el7                        epel                     73 k
 python-setuptools                                      noarch                    0.9.8-7.el7                         base                    397 k

Transaction Summary
====================================================================================================================================================
Install  1 Package (+5 Dependent packages)

Total download size: 968 k
Installed size: 4.7 M
Downloading packages:
(1/6): python-backports-1.0-8.el7.x86_64.rpm                                                                                 | 5.8 kB  00:00:00     
(2/6): python-backports-ssl_match_hostname-3.5.0.1-1.el7.noarch.rpm                                                          |  13 kB  00:00:00     
(3/6): python-ipaddress-1.0.16-2.el7.noarch.rpm                                                                              |  34 kB  00:00:00     
(4/6): python-setuptools-0.9.8-7.el7.noarch.rpm                                                                              | 397 kB  00:00:00     
(5/6): python-meld3-0.6.10-1.el7.x86_64.rpm                                                                                  |  73 kB  00:00:00     
(6/6): supervisor-3.1.4-1.el7.noarch.rpm                                                                                     | 446 kB  00:00:00     
----------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                               689 kB/s | 968 kB  00:00:01     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : python-meld3-0.6.10-1.el7.x86_64                                                                                                 1/6 
  Installing : python-ipaddress-1.0.16-2.el7.noarch                                                                                             2/6 
  Installing : python-backports-1.0-8.el7.x86_64                                                                                                3/6 
  Installing : python-backports-ssl_match_hostname-3.5.0.1-1.el7.noarch                                                                         4/6 
  Installing : python-setuptools-0.9.8-7.el7.noarch                                                                                             5/6 
  Installing : supervisor-3.1.4-1.el7.noarch                                                                                                    6/6 
  Verifying  : python-backports-ssl_match_hostname-3.5.0.1-1.el7.noarch                                                                         1/6 
  Verifying  : supervisor-3.1.4-1.el7.noarch                                                                                                    2/6 
  Verifying  : python-backports-1.0-8.el7.x86_64                                                                                                3/6 
  Verifying  : python-ipaddress-1.0.16-2.el7.noarch                                                                                             4/6 
  Verifying  : python-meld3-0.6.10-1.el7.x86_64                                                                                                 5/6 
  Verifying  : python-setuptools-0.9.8-7.el7.noarch                                                                                             6/6 

Installed:
  supervisor.noarch 0:3.1.4-1.el7                                                                                                                   

Dependency Installed:
  python-backports.x86_64 0:1.0-8.el7     python-backports-ssl_match_hostname.noarch 0:3.5.0.1-1.el7     python-ipaddress.noarch 0:1.0.16-2.el7    
  python-meld3.x86_64 0:0.6.10-1.el7      python-setuptools.noarch 0:0.9.8-7.el7                        

Complete!
deploy src to /var/www/zhiyunlite
configure nginx
Created symlink from /etc/systemd/system/multi-user.target.wants/nginx.service to /usr/lib/systemd/system/nginx.service.
configure /etc/php.ini
configure /etc/php-fpm.d/www.conf
restart php-fpm
Created symlink from /etc/systemd/system/multi-user.target.wants/php-fpm.service to /usr/lib/systemd/system/php-fpm.service.
restart redis
Created symlink from /etc/systemd/system/multi-user.target.wants/redis.service to /usr/lib/systemd/system/redis.service.
create package repository directory /data/zhiyun/pkg
configure zhiyunlite env
configure package job service
Created symlink from /etc/systemd/system/multi-user.target.wants/supervisord.service to /usr/lib/systemd/system/supervisord.service.
initialize package database
Migration table created successfully.
Migrating: 2018_03_31_182859_create_user_table
Migrated:  2018_03_31_182859_create_user_table
Migrating: 2018_03_31_191820_create_cmdb_table
Migrated:  2018_03_31_191820_create_cmdb_table
Migrating: 2018_03_31_191907_create_eventlog_table
Migrated:  2018_03_31_191907_create_eventlog_table
Migrating: 2018_03_31_191917_create_package_table
Migrated:  2018_03_31_191917_create_package_table
Migrating: 2018_03_31_191935_create_packageinstance_table
Migrated:  2018_03_31_191935_create_packageinstance_table
Migrating: 2018_03_31_191948_create_packagerecentaccess_table
Migrated:  2018_03_31_191948_create_packagerecentaccess_table
Migrating: 2018_03_31_191959_create_packagetask_table
Migrated:  2018_03_31_191959_create_packagetask_table
Migrating: 2018_03_31_192019_create_packagetaskdetail_table
Migrated:  2018_03_31_192019_create_packagetaskdetail_table
Migrating: 2018_03_31_192029_create_packageversion_table
Migrated:  2018_03_31_192029_create_packageversion_table
Migrating: 2018_03_31_192223_create_commandtask_table
Migrated:  2018_03_31_192223_create_commandtask_table
Migrating: 2018_04_27_180433_add_system_to_commandtask
Migrated:  2018_04_27_180433_add_system_to_commandtask
Migrating: 2018_05_07_161649_create_commandrecentused_table
Migrated:  2018_05_07_161649_create_commandrecentused_table
Migrating: 2018_05_08_104300_create_metis_series_table
Migrated:  2018_05_08_104300_create_metis_series_table
Migrating: 2018_05_09_152610_create_sshkey_table
Migrated:  2018_05_09_152610_create_sshkey_table
Migrating: 2018_05_09_152832_add_sshkey_to_cmdb
Migrated:  2018_05_09_152832_add_sshkey_to_cmdb
Seeding: UserTableSeeder
configuring zhiyunlite env, init APP_KEY and API_TOKEN...
create helloworld package via api...
创建helloworld包...
{"code":0,"message":"","data":{"id":1}}
上传hellworld.sh文件...
{"code":0,"message":"","data":true}
提交版本...
{"code":0,"message":"","data":{"id":1}}
完成！
create metis package via api...
准备Metis agent包配置...
创建包...
{"code":0,"message":"","data":{"id":2}}
上传文件...
{"code":0,"message":"","data":true}
提交版本...
{"code":0,"message":"","data":{"id":2}}
完成！
generate ssh key
Generating public/private rsa key pair.
Your identification has been saved in /var/www/zhiyunlite/storage/key/id_rsa.
Your public key has been saved in /var/www/zhiyunlite/storage/key/id_rsa.pub.
The key fingerprint is:
SHA256:cr4lERqkOeQdQteSai0GxVLA2phlqA7t4CMGabkIfTw root@localhost.localdomain
The key's randomart image is:
+---[RSA 4096]----+
| o.** +o         |
|. *o.Bo..        |
|.@.+=oo..        |
|@o+ E..o .       |
|Oo.+ oo S        |
|o*.    + .       |
|o .     o .      |
|         +       |
|        .        |
+----[SHA256]-----+
织云Lite安装完成！
默认admin账号的密码在/root/.zhiyunlite_password文件中

你需要将ssh公钥/var/www/zhiyunlite/storage/key/id_rsa.pub分发到被管理机,配置SSH免密登录
SSH KEY生成和配置请参考 http://bbs.coc.tencent.com/forum.php?mod=viewthread&tid=36&extra=page%3D1
被管理机上需要安装curl以保证织云正常运作


```