Centos7安装JDK8

- 卸载系统中的OpenJDK

OpenJDK与JDK的区别：http://www.cnblogs.com/sxdcgaq8080/p/7487369.html 

卸载方法：http://www.cnblogs.com/ystq/p/5972608.html

一些开发版的centos会自带jdk，我们一般用自己的jdk，把自带的删除。先看看有没有安装java -version

```
[root@java-test-01 ~]# java -version
openjdk version "1.8.0_101"
OpenJDK Runtime Environment (build 1.8.0_101-b13)
OpenJDK 64-Bit Server VM (build 25.101-b13, mixed mode)
```

查找他们的安装位置

```
[root@java-test-01 ~]# rpm -qa | grep java
java-1.8.0-openjdk-headless-1.8.0.101-3.b13.el7_2.x86_64
tzdata-java-2016f-1.el7.noarch
java-1.8.0-openjdk-1.8.0.101-3.b13.el7_2.x86_64
javapackages-tools-3.4.1-11.el7.noarch
java-1.7.0-openjdk-headless-1.7.0.111-2.6.7.2.el7_2.x86_64
java-1.7.0-openjdk-1.7.0.111-2.6.7.2.el7_2.x86_64
python-javapackages-3.4.1-11.el7.noarch
```

删除全部，noarch文件可以不用删除

```
[root@java-test-01 ~]# rpm -e --nodeps java-1.8.0-openjdk-headless-1.8.0.101-3.b13.el7_2.x86_64
[root@java-test-01 ~]# rpm -e --nodeps java-1.8.0-openjdk-1.8.0.101-3.b13.el7_2.x86_64
[root@java-test-01 ~]# rpm -e --nodeps java-1.7.0-openjdk-headless-1.7.0.111-2.6.7.2.el7_2.x86_64
[root@java-test-01 ~]# rpm -e --nodeps java-1.7.0-openjdk-1.7.0.111-2.6.7.2.el7_2.x86_64
```

检查有没有删除

```
[root@java-test-01 ~]# java -version
-bash: /usr/bin/java: 没有那个文件或目录
```

如果还没有删除，则用yum -y remove去删除他们


- 下载jdk1.8的tar包：

下载地址到oracle官网点击下载后，在浏览器下载上传至Centos7.

下载页：http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html

[jdk-8u171-linux-x64.tar.gz](https://share.weiyun.com/5Qf4cHs)


- 上传完成后解压tar包 

切换到 user/local/src目录下上传tar包 ：
 
`cd /usr/local/src`

`tar -zxvf jdk-8u171-linux-x64.tar.gz`

将解压后的文件夹剪切到usr/local目录下，并改名为jdk8 

`mv jdk1.8.0_171 ../jdk8`

- 配置环境变量 

`vi /etc/profile`

在该文件尾部追加如下代码：

```
    JAVA_HOME=/usr/local/jdk8
    JRE_HOME=/usr/local/jdk8/jre
    CLASS_PATH=.:$JAVA_HOME/lib
    PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH
    export JAVA_HOME JRE_HOME PATH CLASS_PATH 
```

追加完成后更新配置：`source /etc/profile` 

查看是否安装成功：`java -version`

