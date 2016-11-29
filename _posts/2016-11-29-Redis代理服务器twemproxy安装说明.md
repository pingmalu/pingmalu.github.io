---
layout: post
title:  "Redis代理服务器twemproxy安装说明"
---

twemproxy是一个twitter开源的一个redis和memcache代理服务器。也叫nutcracker

源码：[https://github.com/twitter/twemproxy](https://github.com/twitter/twemproxy)


1.安装过程：

	apt-get update
	apt-get install autoconf automake libtool
	wget https://github.com/twitter/twemproxy/archive/v0.4.1.zip
	unzip v0.4.1.zip
	cd twemproxy-0.4.1/
	chmod 777 ./travis.sh
	./travis.sh

查看帮助：

	$ nutcracker --help
	This is nutcracker-0.4.1
	
	Usage: nutcracker [-?hVdDt] [-v verbosity level] [-o output file]
	                  [-c conf file] [-s stats port] [-a stats addr]
	                  [-i stats interval] [-p pid file] [-m mbuf size]
	
	Options:
	  -h, --help             : this help
	  -V, --version          : show version and exit
	  -t, --test-conf        : test configuration for syntax errors and exit
	  -d, --daemonize        : run as a daemon
	  -D, --describe-stats   : print stats description and exit
	  -v, --verbose=N        : set logging level (default: 5, min: 0, max: 11)
	  -o, --output=S         : set logging file (default: stderr)
	  -c, --conf-file=S      : set configuration file (default: conf/nutcracker.yml)
	  -s, --stats-port=N     : set stats monitoring port (default: 22222)
	  -a, --stats-addr=S     : set stats monitoring ip (default: 0.0.0.0)
	  -i, --stats-interval=N : set stats aggregation interval in msec (default: 30000 msec)
	  -p, --pid-file=S       : set pid file (default: off)
	  -m, --mbuf-size=N      : set size of mbuf chunk in bytes (default: 16384 bytes)


2.配置文件：

	vim conf/nutcracker.yml

	alpha:
	  listen: 0.0.0.0:27017
	  hash: fnv1a_64
	  distribution: ketama
	  auto_eject_hosts: true
	  redis: true
	  server_retry_timeout: 2000
	  server_failure_limit: 1
	  redis_auth: 5cKBak4iBLY1
	  servers:
	   - 10.10.11.31:6379:1

redis_auth为后端redis的认证密钥

listen: 0.0.0.0:27017 监听本地所有的27017端口


3.在当前目录下启动：

	nutcracker -d -c conf/nutcracker.yml

4.客户端连接测试：

	redis-cli -p 27017 -a 5cKBak4iBLY1
	127.0.0.1:27017> set a abl
	OK
	127.0.0.1:27017> get a
	"abl"

注意：

    对于redis的系统命令是不支持的，也就导致了有些客户端工具连接不上。
