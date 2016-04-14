---
layout: post
title: python_gevent模块安装
---

### 通过pip安装，先确保python-dev已安装：

	apt-get install python-dev
	pip install gevent

正常情况greenlet也会一同安装：

	gevent (1.1.1)
	greenlet (0.4.9)

### 如果遇到安装不上的情况，可以尝试安装旧版本：

	pip install gevent==0.13.8


### 当然也可以下载源码安装：

	wget http://pypi.python.org/packages/source/g/gevent/gevent-0.13.8.tar.gz

解压后，要先运行下其中的：

	python fetch_libevent.py

然后：

	python setup.py build
	python setup.py install