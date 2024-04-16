---
layout: post
title: Zookeeper
---

# zookeeper可视化管理工具

## ZooInspector

下载地址：[https://issues.apache.org/jira/secure/attachment/12436620/ZooInspector.zip](https://issues.apache.org/jira/secure/attachment/12436620/ZooInspector.zip)

执行文件路径 ZooInspector\build

启动：

```powershell
java -jar zookeeper-dev-ZooInspector.jar
```

## IDEA Zookeeper管理工具

插件里搜索Zookeeper即可

# zookeeper集群

为了方便演示，我们在windows下建立单机集群

## 1.创建配置文件

在目录 apache-zookeeper-3.6.1-bin\conf 下创建

zoo1.cfg

```
tickTime=2000
initLimit=10
syncLimit=5
dataDir=/zookeeper/data1
clientPort=2181

server.1=localhost:2881:3881
server.2=localhost:2882:3882
server.3=localhost:2883:3883
```

zoo2.cfg

```
tickTime=2000
initLimit=10
syncLimit=5
dataDir=/zookeeper/data2
clientPort=2182

server.1=localhost:2881:3881
server.2=localhost:2882:3882
server.3=localhost:2883:3883
```

zoo3.cfg

```
tickTime=2000
initLimit=10
syncLimit=5
dataDir=/zookeeper/data3
clientPort=2183

server.1=localhost:2881:3881
server.2=localhost:2882:3882
server.3=localhost:2883:3883
```

配置说明

tickTime：基本事件单元，这个时间是作为Zookeeper服务器之间或客户端与服务器之间维持心跳的时间间隔，每隔tickTime时间就会发送一个心跳；最小 的session过期时间为2倍tickTime

initLimit：允许follower连接并同步到Leader的初始化连接时间，以tickTime为单位。当初始化连接时间超过该值，则表示连接失败。

syncLimit：表示Leader与Follower之间发送消息时，请求和应答时间长度。如果follower在设置时间内不能与leader通信，那么此follower将会被丢弃。

dataDir：存储内存中数据库快照的位置，除非另有说明，否则指向数据库更新的事务日志。注意：应该谨慎的选择日志存放的位置，使用专用的日志存储设备能够大大提高系统的性能，如果将日志存储在比较繁忙的存储设备上，那么将会很大程度上影像系统性能。

clientPort：监听客户端连接的端口。

server.A=B:C:D

　　　　A：其中 A 是一个数字，表示这个是服务器的编号；

　　　　B：是这个服务器的 ip 地址；

　　　　C：Leader选举的端口；

　　　　D：Zookeeper服务器之间的通信端口。

## 2.在目录 C:\zookeeper\ 下创建目录 和 文件，分别对应server.id

C:\zookeeper\data1\myid

```
1
```

C:\zookeeper\data2\myid

```
2
```

C:\zookeeper\data3\myid

```
3
```

## 3.修改启动脚本

由于 zkServer.cmd 里默认使用conf/zoo.cfg配置文件，集群启动需要读取不同的配置文件

分别拷贝 zkServer.cmd 到 zkServer1.cmd  zkServer2.cmd  zkServer3.cmd 

把里面 %ZOOCFG% 变量指定对应的配置文件  ../conf/zoo1.cfg ../conf/zoo2.cfg ../conf/zoo3.cfg

启动zookeeper集群.cmd

```
start zkServer1.cmd
start zkServer2.cmd
start zkServer3.cmd
```

4.客户端连接验证

.\zkCli.cmd -server localhost:2181

.\zkCli.cmd -server localhost:2182

.\zkCli.cmd -server localhost:2183

# zookeeper的ACL权限控制

`acl`权限控制，使用 `scheme:id:permission` 来标识，主要涵盖3个方面：

- 权限模式(`scheme`)：授权的策略
- 授权对象(`id`)：授权的对象
- 权限(`permission`)：授予的权限

### 权限模式`scheme`

- 采用何种方式授权

| 方案   | 描述                                                    |
| ------ | ------------------------------------------------------- |
| world  | 只有一个用户：`anyone`，代表登录`zookeeper`所有人(默认) |
| ip     | 对客户端使用IP地址认证                                  |
| auth   | 使用已添加认证的用户认证                                |
| digest | 使用"用户名：密码"方式认证                              |

### 授权对象`id`

- 给谁授予权限
- 授权对象ID是指，权限赋予的实体，例如：IP地址或用户

### 权限`permission`

- 授予什么权限

| 权限   | ACL简写 | 描述                               |
| ------ | ------- | ---------------------------------- |
| create | c       | 可以创建子结点                     |
| delete | d       | 可以删除子结点(仅下一级结点)       |
| read   | r       | 可以读取结点数据以及显示子结点列表 |
| write  | w       | 可以设置结点数据                   |
| admin  | a       | 可以设置结点访问控制权限列表       |

**授权的相关命令**

| 命令    | 使用方式 | 描述         |
| ------- | -------- | ------------ |
| getAcl  | getAcl   | 读取ACL权限  |
| setAcl  | setAcl   | 设置ACL权限  |
| addauth | addauth  | 添加认证用户 |

eg.

```shell
create /zk "zk"                   # 初始化测试用的结点
addauth digest malu:123456        # 添加认证用户
setAcl /zk auth:malu:cdrwa        # 设置认证用户
quit                              # 退出后再./zkCli.sh 进入
get /zk                           # 这个时候就没有权限了，需要再次认证
addauth digest malu:123456        # 认证，密码错了的话 zookeeper 不会报错，但是不能认证
get /zk
```

**多种授权模式**

仅需逗号隔开

```shell
setAcl /zk ip:192.168.1.27:cdrwa,auth:malu:cdrwa,digest:malu:pl570Xd7m2mTrsmMA9zKyO3hCAU=:cdrwa
```

###  ACL超级管理员

- `zookeeper`的权限管理模式有一种叫做`super`，该模式提供一个超管，可以方便的访问任何权限的节点

  假设这个超管是`supper:admin`，需要为超管生产密码的密文

  ```shell
  echo -n super:admin | openssl dgst -binary -sha1 | openssl base64
  ```

- 那么打开`zookeeper`目录下`/bin/zkServer.sh`服务器脚本文件，找到如下一行：

  ```shell
   /nohup # 快速查找，可以看到如下
   nohup "$JAVA" "-Dzookeeper.log.dir=${ZOO_LOG_DIR}" "-Dzookeeper.root.logger=${ZOO_LOG4J_PROP}"
  ```

- 这个就算脚本中启动`zookeeper`的命令，默认只有以上两个配置项，我们需要添加一个超管的配置项

  ```
  "-Dzookeeper.DigestAuthenticationProvider.superDigest=super:xQJmxLMiHGwaqBvst5y6rkB6HQs="
  ```

- 修改后命令变成如下

  ```shell
  nohup "$JAVA" "-Dzookeeper.log.dir=${ZOO_LOG_DIR}" "-Dzookeeper.root.logger=${ZOO_LOG4J_PROP}" "-Dzookeeper.DigestAuthenticationProvider.superDigest=super:xQJmxLMiHGwaqBvst5y6rkB6HQs="
  ```

  ``` shell
  # 重起后，现在随便对任意节点添加权限限制
  setAcl /zk ip:192.168.1.21:cdrwa # 这个ip并非本机
  # 现在当前用户没有权限了
  getAcl /zk
  # 登录超管
  addauth digest super:admin
  # 强行操作节点
  get /hadoop
  ```

  