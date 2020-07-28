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