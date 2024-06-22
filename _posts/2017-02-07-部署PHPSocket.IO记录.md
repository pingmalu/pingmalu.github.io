---
layout: post
title: 部署PHPSocket.IO记录
---

Github地址：[https://github.com/walkor/phpsocket.io](https://github.com/walkor/phpsocket.io)

### 方法一：

下载代码后使用composer安装依赖:

	> composer install
	Loading composer repositories with package information
	Updating dependencies (including require-dev)
	  - Installing workerman/workerman (v3.3.7)
	    Downloading: 100%
	
	  - Installing workerman/channel (v1.0.3)
	    Downloading: 100%
	
	workerman/workerman suggests installing ext-event (For better performance.)
	Writing lock file
	Generating autoload files


### 方法二：

编辑项目composer.json文件，添加：

    "require": {
        "workerman/workerman" : ">=3.1.8",
        "workerman/channel" : ">=1.0.0",
        "workerman/phpsocket.io" : ">=1.1.1"
    }

然后更新composer：

	> composer update

注：国内用户建议修改composer源：

> 打开命令行窗口（windows用户）或控制台（Linux、Mac 用户）并执行如下命令：
> 
> composer config -g repo.packagist composer https://packagist.phpcomposer.com


### 一个非常简单的聊天服务端示例

	<?php
	require_once __DIR__ . '/vendor/autoload.php';
	use PHPSocketIO\SocketIO;
	
	// listen port 2021 for socket.io client
	$io = new SocketIO(2021);
	$io->on('connection', function($socket)use($io){
	  $socket->on('chat message', function($msg)use($io){
	    $io->emit('chat message from server', $msg);
	  });
	});

### 客户端

	<script src='//cdn.bootcss.com/socket.io/1.3.7/socket.io.js'></script>
	<script>
	// 连接服务端
	var socket = io('http://127.0.0.1:2021');
	// 触发服务端的chat message事件
	socket.emit('chat message', '这个是消息内容...');
	// 服务端通过emit('chat message from server', $msg)触发客户端的chat message from server事件
	socket.on('chat message from server', function(msg){
		console.log('get message:' + msg + ' from server');
	});
	</script>

# 运行

Start

	php server.php start for debug mode
	
	php server.php start -d for daemon mode

Stop

	php server.php stop

Status

	php server.php status


# ERROR：

### 运行时报错：PHP Fatal error:  Call to undefined function Workerman\Lib\pcntl_signal() in ...

解决办法：

	由于walkman依赖PHP的pcntl多进程扩展，所以需要先安装该扩展：
	
	# 进入PHP源码包扩展目录,如果不存在则去官网下载,下载对应版本提取出来 http://php.net/releases/
	cd /data/soft/php/php-5.6.3/ext/pcntl
	/usr/bin/phpize
	./configure --with-php-config=/usr/local/php/bin/php-config
	make
	make install
	
	# 增加pcntl.so 到 php.ini文件中
	vim /usr/local/php/etc/php.ini
	extension = pcntl.so
	
	# 重启php-fpm
	/etc/init.d/php-fpm restart

	另外一种安装的方法
	centos
	1、命令行运行yum install php-cli php-process git php-devel php-pear libevent-devel
	2、命令行运行pecl install channel://pecl.php.net/libevent-0.1.0
	3、命令行运行echo extension=libevent.so > /etc/php.d/libevent.ini
	
	debian/ubuntu
	1、命令行运行apt-get update && apt-get install php5-cli git php-pear php5-dev libevent-dev
	2、命令行运行pecl install channel://pecl.php.net/libevent-0.1.0
	3、命令行运行echo extension=libevent.so > /etc/php5/cli/conf.d/libevent.ini


验证model加载情况：

	> php -m |grep pcntl
	pcntl


### 客户端IE9以下无法发送中文问题

解决办法：

发送时对消息使用encodeURIComponent编码，接收端使用decodeURIComponent解码


### 本地与线上调试通讯，在IE9以下无法收发

因为在跨域的时候，IE9以下优先用的不是jsonp，而是xhr-polling（XDomainRequest），因为XDomainRequest跨域请求localhost会拒绝访问