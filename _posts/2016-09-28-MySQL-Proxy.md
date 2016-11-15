---
layout: post
title:  "MySQL-Proxy"
---

很多客户端工具可以直接通过代理访问mysql，但是在代码里面用代理比较麻烦。还好mysql官方为我们提供了mysql-proxy套件，可以用它以透明代理方式访问了。

下载地址：[http://downloads.mysql.com/archives/proxy/](http://downloads.mysql.com/archives/proxy/)

安装过程：

	wget http://downloads.mysql.com/archives/get/file/mysql-proxy-0.8.5-linux-debian6.0-x86-64bit.tar.gz
	tar -zxvf mysql-proxy-0.8.5-linux-debian6.0-x86-64bit.tar.gz
	mkdir /usr/local/mysql-proxy
	cp mysql-proxy-0.8.5-linux-debian6.0-x86-64bit/* /usr/local/mysql-proxy -R
	
编辑配置文件：vim /usr/local/mysql-proxy/mysql-proxy.conf

	[mysql-proxy]
    proxy-address = 0.0.0.0:9300    #监听地址和端口
	admin-address = localhost:4041  #定义内部管理服务器账号，只做代理不用关注
	admin-username = mytest    
	admin-password = 123456
	admin-lua-script = /usr/local/mysql-proxy/lib/mysql-proxy/lua/admin.lua
	proxy-backend-addresses = 192.168.0.56:3306  #实际mysql地址

启动：

	/usr/local/mysql-proxy/bin/mysql-proxy --defaults-file=/usr/local/mysql-proxy/mysql-proxy.conf &