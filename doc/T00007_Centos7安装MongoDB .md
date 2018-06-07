Centos7下mongodb安装和配置

- 下载安装包

`curl -O http://downloads.mongodb.org/linux/mongodb-linux-x86_64-3.6.5.tgz`

- 解压

`tar -zxvf mongodb-linux-x86_64-3.6.5.tgz`


- 移动到指定位置

`mv  mongodb-linux-x86_64-3.6.5/ /usr/local/mongodb`

- 在/usr/local/mongodb下创建文件夹

```
cd /usr/local/mongodb
mkdir -p data/db
mkdir  logs
```

- 在/usr/local/mongodb/bin下新建配置

```
cd /usr/local/mongodb/bin
vi mongodb.conf
```

配置如下:

```
dbpath = /usr/local/mongodb/data/db #数据文件存放目录
logpath = /usr/local/mongodb/logs/mongodb.log #日志文件存放目录
port = 27017 #端口
fork = true #以守护程序的方式启用，即在后台运行
auth=true
bind_ip=0.0.0.0
```


- 环境变量配置

```
vi /etc/profile 

export MONGODB_HOME=/usr/local/mongodb
export PATH=$PATH:$MONGODB_HOME/bin
```

保存后，重启系统配置

`source /etc/profile`

- 启动

```
cd /usr/local/mongodb/bin

mongod -f mongodb.conf 或 ./mongod -f mongodb.conf
```

- 关闭

`mongod -f ./mongodb.conf --shutdown` 或 `./mongod -f ./mongodb.conf --shutdown`

```
开启端口

firewall-cmd --zone=public --add-port=27017/tcp --permanent

查看端口

firewall-cmd --permanent --query-port=27017/tcp

重启防火墙

firewall-cmd --reload
```

- 创建用户

 进入mongodb的shell模式： 
 `/usr/local/mongodb/bin/mongo` 

 创建用户管理员：
 ```
   use admin
   db.createUser({user:"root",pwd:"123456",roles:["userAdminAnyDatabase"]})
   db.auth('root','123456')
 ```
 
 以用户管理员身份登录，并切换数据库，创建数据库用户：
 ``` 
   切换到test数据库
   use demo
   创建用户名、密码、角色
   db.createUser({user:"root",pwd:"123456",roles:[{role:"readWrite",db:"demo"}]})
   db.createUser({
	user: "root",
	pwd: "123456",
	roles: [
		{ role: "readWrite", db: "demo" }
		]
	})
   验证mongodb数据库权限。
   use demo
   db.auth('root','123456')
 ```   

 查看数据库列表： 
 `show dbs` 
 
 查看当前db版本： 
 `db.version()`   
 
   
- mongodb数据库可视化工具

https://robomongo.org/download

安装后直接使用 

- MongoDB3.0用户创建(参考文章)

在安装MongoDB之后，先关闭auth认证，进入查看数据库，只有一个local库，admin库是不存在的：

```
root@zhoujinyi:/usr/local/mongo4# mongo --port=27020
MongoDB shell version: 3.0.4
connecting to: 127.0.0.1:27020/test
2015-06-29T09:31:08.673-0400 I CONTROL  [initandlisten] 
> show dbs;
local  0.078GB
```

现在需要创建一个帐号，该账号需要有grant权限，即：账号管理的授权权限。注意一点，帐号是跟着库走的，所以在指定库里授权，必须也在指定库里验证(auth)。


```

> use admin
switched to db admin
> db.createUser(
   {
     user: "dba",
     pwd: "dba",
     roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
   }
 )
Successfully added user: {
    "user" : "dba",
    "roles" : [
        {
            "role" : "userAdminAnyDatabase",
            "db" : "admin"
        }
    ]
}

```

上面加粗的就是执行的命令：

user：用户名

pwd：密码

roles：指定用户的角色，可以用一个空数组给新用户设定空角色；在roles字段,可以指定内置角色和用户定义的角色。[role里的角色](https://docs.mongodb.com/manual/reference/built-in-roles/#built-in-roles)可以选：


```

  Built-In Roles（内置角色）：
    1. 数据库用户角色：read、readWrite;
    2. 数据库管理角色：dbAdmin、dbOwner、userAdmin；
    3. 集群管理角色：clusterAdmin、clusterManager、clusterMonitor、hostManager；
    4. 备份恢复角色：backup、restore；
    5. 所有数据库角色：readAnyDatabase、readWriteAnyDatabase、userAdminAnyDatabase、dbAdminAnyDatabase
    6. 超级用户角色：root  
    // 这里还有几个角色间接或直接提供了系统超级用户的访问（dbOwner 、userAdmin、userAdminAnyDatabase）
    7. 内部角色：__system

```

具体角色： 


```

Read：允许用户读取指定数据库
readWrite：允许用户读写指定数据库
dbAdmin：允许用户在指定数据库中执行管理函数，如索引创建、删除，查看统计或访问system.profile
userAdmin：允许用户向system.users集合写入，可以找指定数据库里创建、删除和管理用户
clusterAdmin：只在admin数据库中可用，赋予用户所有分片和复制集相关函数的管理权限。
readAnyDatabase：只在admin数据库中可用，赋予用户所有数据库的读权限
readWriteAnyDatabase：只在admin数据库中可用，赋予用户所有数据库的读写权限
userAdminAnyDatabase：只在admin数据库中可用，赋予用户所有数据库的userAdmin权限
dbAdminAnyDatabase：只在admin数据库中可用，赋予用户所有数据库的dbAdmin权限。
root：只在admin数据库中可用。超级账号，超级权限

```

刚建立了 userAdminAnyDatabase 角色，用来管理用户，可以通过这个角色来创建、删除用户。验证：需要开启auth参数。


```

root@zhoujinyi:/usr/local/mongo4# mongo --port=27020
MongoDB shell version: 3.0.4
connecting to: 127.0.0.1:27020/test
> show dbs;    ####没有验证，导致没权限。
2015-06-29T10:02:16.634-0400 E QUERY    Error: listDatabases failed:{
    "ok" : 0,
    "errmsg" : "not authorized on admin to execute command { listDatabases: 1.0 }",
    "code" : 13
}
    at Error (<anonymous>)
    at Mongo.getDBs (src/mongo/shell/mongo.js:47:15)
    at shellHelper.show (src/mongo/shell/utils.js:630:33)
    at shellHelper (src/mongo/shell/utils.js:524:36)
    at (shellhelp2):1:1 at src/mongo/shell/mongo.js:47
> use admin        #验证，因为在admin下面添加的帐号，所以要到admin下面验证。
switched to db admin
> db.auth('dba','dba')
1
> show dbs;
admin  0.078GB
local  0.078GB
> use test        #在test库里创建帐号
switched to db test
> db.createUser(
     {
       user: "zjyr",
       pwd: "zjyr",
       roles: [
          { role: "read", db: "test" }    #只读帐号
       ]
     }
 )
Successfully added user: {
    "user" : "zjyr",
    "roles" : [
        {
            "role" : "read",
            "db" : "test"
        }
    ]
}
> db.createUser(
     {
       user: "zjy",
       pwd: "zjy",
       roles: [
          { role: "readWrite", db: "test" }   #读写帐号
       ]
     }
 )
Successfully added user: {
    "user" : "zjy",
    "roles" : [
        {
            "role" : "readWrite",                #读写账号
            "db" : "test"
        }
    ]
}
> show users;                                    #查看当前库下的用户
{
    "_id" : "test.zjyr",
    "user" : "zjyr",
    "db" : "test",
    "roles" : [
        {
            "role" : "read",
            "db" : "test"
        }
    ]
}
{
    "_id" : "test.zjy",
    "user" : "zjy",
    "db" : "test",
    "roles" : [
        {
            "role" : "readWrite",
            "db" : "test"
        }
    ]
}

```

上面创建了2个帐号，现在验证下：验证前提需要一个集合


```

> db.abc.insert({"a":1,"b":2})              #插入失败，没有权限，userAdminAnyDatabase 权限只是针对用户管理的，对其他是没有权限的。
WriteResult({
    "writeError" : {
        "code" : 13,
        "errmsg" : "not authorized on test to execute command { insert: \"abc\", documents: [ { _id: ObjectId('55915185d629831d887ce2cb'), a: 1.0, b: 2.0 } ], ordered: true }"
    }
})
> 
bye
root@zhoujinyi:/usr/local/mongo4# mongo --port=27020
MongoDB shell version: 3.0.4
connecting to: 127.0.0.1:27020/test
> use test
switched to db test
> db.auth('zjy','zjy')       #用创建的readWrite帐号进行写入
1
> db.abc.insert({"a":1,"b":2})
WriteResult({ "nInserted" : 1 })
> db.abc.insert({"a":11,"b":22})
WriteResult({ "nInserted" : 1 })
> db.abc.insert({"a":111,"b":222})
WriteResult({ "nInserted" : 1 })
> db.abc.find()
{ "_id" : ObjectId("559151a1b78649ebd8316853"), "a" : 1, "b" : 2 }
{ "_id" : ObjectId("559151cab78649ebd8316854"), "a" : 11, "b" : 22 }
{ "_id" : ObjectId("559151ceb78649ebd8316855"), "a" : 111, "b" : 222 }
> db.auth('zjyr','zjyr')       #切换到只有read权限的帐号
1
> db.abc.insert({"a":1111,"b":2222})  #不能写入
WriteResult({
    "writeError" : {
        "code" : 13,
        "errmsg" : "not authorized on test to execute command { insert: \"abc\", documents: [ { _id: ObjectId('559151ebb78649ebd8316856'), a: 1111.0, b: 2222.0 } ], ordered: true }"
    }
})
> db.abc.find()        #可以查看
{ "_id" : ObjectId("559151a1b78649ebd8316853"), "a" : 1, "b" : 2 }
{ "_id" : ObjectId("559151cab78649ebd8316854"), "a" : 11, "b" : 22 }
{ "_id" : ObjectId("559151ceb78649ebd8316855"), "a" : 111, "b" : 222 }

```

有没有一个超级权限？不仅可以授权，而且也可以对集合进行任意操作？答案是肯定的，只是不建议使用。那就是role角色设置成root。


```

> db.auth('dba','dba')
1
> db.createUser(
  {
    user: "zhoujinyi",
    pwd: "zhoujinyi",
    roles: [
       { role: "root", db: "admin" }      #超级root帐号
    ]
  }
 )
Successfully added user: {
    "user" : "zhoujinyi",
    "roles" : [
        {
            "role" : "root",
            "db" : "admin"
        }
    ]
}
> 
> show users;              #查看当前库下的用户
{
    "_id" : "admin.dba",
    "user" : "dba",
    "db" : "admin",
    "roles" : [
        {
            "role" : "userAdminAnyDatabase",
            "db" : "admin"
        }
    ]
}
{
    "_id" : "admin.zhoujinyi",
    "user" : "zhoujinyi",
    "db" : "admin",
    "roles" : [
        {
            "role" : "root",
            "db" : "admin"
        }
    ]
}
> use admin
switched to db admin
> db.auth('zhoujinyi','zhoujinyi')
1
> use test
switched to db test
> db.abc.insert({"a":1,"b":2})
WriteResult({ "nInserted" : 1 })
> db.abc.insert({"a":1111,"b":2222})          #权限都有
WriteResult({ "nInserted" : 1 })
> db.abc.find()
{ "_id" : ObjectId("5591539bb78649ebd8316857"), "a" : 1, "b" : 2 }
{ "_id" : ObjectId("559153a0b78649ebd8316858"), "a" : 1111, "b" : 2222 }
> db.abc.remove({})
WriteResult({ "nRemoved" : 2 })

```

因为帐号都是在当前需要授权的数据库下授权的，那要是不在当前数据库下会怎么样？


```

> db
admin
> db.createUser(
  {
    user: "dxy",
    pwd: "dxy",
    roles: [
       { role: "readWrite", db: "test" },     #在当前库下创建其他库的帐号，在admin库下创建test、abc库的帐号
       { role: "readWrite", db: "abc" }         
    ]
  }
 )
Successfully added user: {
    "user" : "dxy",
    "roles" : [
        {
            "role" : "readWrite",
            "db" : "test"
        },
        {
            "role" : "readWrite",
            "db" : "abc"
        }
    ]
}
> 
> show users;
{
    "_id" : "admin.dba",
    "user" : "dba",
    "db" : "admin",
    "roles" : [
        {
            "role" : "userAdminAnyDatabase",
            "db" : "admin"
        }
    ]
}
{
    "_id" : "admin.zhoujinyi",
    "user" : "zhoujinyi",
    "db" : "admin",
    "roles" : [
        {
            "role" : "root",
            "db" : "admin"
        }
    ]
}
{
    "_id" : "admin.dxy",
    "user" : "dxy",
    "db" : "admin",
    "roles" : [
        {
            "role" : "readWrite",
            "db" : "test"
        },
        {
            "role" : "readWrite",
            "db" : "abc"
        }
    ]
}
> use test
switched to db test
> db.auth('dxy','dxy')          #在admin下创建的帐号，不能直接在其他库验证，
Error: 18 Authentication failed.
0
> use admin
switched to db admin            #只能在帐号创建库下认证，再去其他库进行操作。
> db.auth('dxy','dxy')
1
> use test
switched to db test
> db.abc.insert({"a":1111,"b":2222})
WriteResult({ "nInserted" : 1 })
> use abc
switched to db abc
> db.abc.insert({"a":1111,"b":2222})
WriteResult({ "nInserted" : 1 })

```

上面更加进一步说明数据库帐号是跟着数据库来走的，哪里创建哪里认证。

创建了这么多帐号，怎么查看所有帐号？


```

>  use admin
switched to db admin
> db.auth('dba','dba')
1
> db.system.users.find().pretty()
{
    "_id" : "admin.dba",
    "user" : "dba",
    "db" : "admin",
    "credentials" : {
        "SCRAM-SHA-1" : {
            "iterationCount" : 10000,
            "salt" : "KfDUzCOIUo7WVjFr64ZOcQ==",
            "storedKey" : "t4sPsKG2dXnZztVYj5EgdUzT9sc=",
            "serverKey" : "2vCGiq9NIc1zKqeEL6VvO4rP26A="
        }
    },
    "roles" : [
        {
            "role" : "userAdminAnyDatabase",
            "db" : "admin"
        }
    ]
}
{
    "_id" : "test.zjyr",
    "user" : "zjyr",
    "db" : "test",
    "credentials" : {
        "SCRAM-SHA-1" : {
            "iterationCount" : 10000,
            "salt" : "h1gOW3J7wzJuTqgmmQgJKQ==",
            "storedKey" : "7lkoANdxM2py0qiDBzFaZYPp1cM=",
            "serverKey" : "Qyu6IRNyaKLUvqJ2CAa/tQYY36c="
        }
    },
    "roles" : [
        {
            "role" : "read",
            "db" : "test"
        }
    ]
}
{
    "_id" : "test.zjy",
    "user" : "zjy",
    "db" : "test",
    "credentials" : {
        "SCRAM-SHA-1" : {
            "iterationCount" : 10000,
            "salt" : "afwaKuTYPWwbDBduQ4Hm7g==",
            "storedKey" : "ebb2LYLn4hiOVlZqgrAKBdStfn8=",
            "serverKey" : "LG2qWwuuV+FNMmr9lWs+Rb3DIhQ="
        }
    },
    "roles" : [
        {
            "role" : "readWrite",
            "db" : "test"
        }
    ]
}
{
    "_id" : "admin.zhoujinyi",
    "user" : "zhoujinyi",
    "db" : "admin",
    "credentials" : {
        "SCRAM-SHA-1" : {
            "iterationCount" : 10000,
            "salt" : "pE2cSOYtBOYevk8tqrwbSQ==",
            "storedKey" : "TwMxdnlB5Eiaqg4tNh9ByNuUp9A=",
            "serverKey" : "Mofr9ohVlFfR6/md4LMRkOhXouc="
        }
    },
    "roles" : [
        {
            "role" : "root",
            "db" : "admin"
        }
    ]
}
{
    "_id" : "admin.dxy",
    "user" : "dxy",
    "db" : "admin",
    "credentials" : {
        "SCRAM-SHA-1" : {
            "iterationCount" : 10000,
            "salt" : "XD6smcWX4tdg/ZJPoLxxRg==",
            "storedKey" : "F4uiayykHDp/r9krAKZjdr+gqjM=",
            "serverKey" : "Kf51IU9J3RIrB8CFn5Z5hEKMSkw="
        }
    },
    "roles" : [
        {
            "role" : "readWrite",
            "db" : "test"
        },
        {
            "role" : "readWrite",
            "db" : "abc"
        }
    ]
}
> db.system.users.find().count()

```

备份还原使用那个角色的帐号？之前创建的帐号zjy:test库读写权限；zjyr:test库读权限


```

root@zhoujinyi:~# mongodump --port=27020 -uzjyr -pzjyr --db=test -o backup   #只要读权限就可以备份
2015-06-29T11:20:04.864-0400    writing test.abc to backup/test/abc.bson
2015-06-29T11:20:04.865-0400    writing test.abc metadata to backup/test/abc.metadata.json
2015-06-29T11:20:04.866-0400    done dumping test.abc
2015-06-29T11:20:04.867-0400    writing test.system.indexes to backup/test/system.indexes.bson


root@zhoujinyi:~# mongorestore --port=27020 -uzjy -pzjy --db=test backup/test/  #读写权限可以进行还原
2015-06-29T11:20:26.607-0400    building a list of collections to restore from backup/test/ dir
2015-06-29T11:20:26.609-0400    reading metadata file from backup/test/abc.metadata.json
2015-06-29T11:20:26.609-0400    restoring test.abc from file backup/test/abc.bson
2015-06-29T11:20:26.611-0400    error: E11000 duplicate key error index: test.abc.$_id_ dup key: { : ObjectId('559154efb78649ebd831685a') }
2015-06-29T11:20:26.611-0400    restoring indexes for collection test.abc from metadata
2015-06-29T11:20:26.612-0400    finished restoring test.abc
2015-06-29T11:20:26.612-0400    done

```


参考引用

> [MongoDB3.0用户创建](https://www.cnblogs.com/zhoujinyi/p/4610050.html)

> [centos7下mongodb安装和配置](https://blog.csdn.net/rzrenyu/article/details/79472508)