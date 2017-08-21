---
layout: post
title: mysql-python安装过程
---

### 快速安装

	apt-get update
	apt-get install -y libffi-dev python-dev
	apt-get install -y libmysqlclient-dev
	apt-get install -y libmysqld-dev
	pip install mysql-python

### 导入模块：

	>>> import MySQLdb


# 在Windows下安装 MySQL-python 1.2.5

安装步骤如下：

1.安装 Microsoft Visual C++ Compiler Package for Python 2.7  [下载链接](https://www.microsoft.com/en-us/download/details.aspx?id=44266)

2.安装 MySQL Connector C 6.0.2  [下载链接](https://dev.mysql.com/downloads/connector/c/6.0.html)

3.下载 MySQL-python 1.2.5 源码包  [下载链接](https://pypi.python.org/pypi/MySQL-python/1.2.5)

4.解压源码包后，修改 site.cfg 文件。

实际上，如果你是在32 位系统上部署，那么通过pip install 安装MySQL-python 1.2.5 只需进行上面的依赖包安装即可。
但在 64 位环境中，就会提示“Cannot open include file: 'config-win.h'” 的错误。
原因就是 site.cfg 中写的 MySQL Connector C 为32 位版本。

原来的 site.cfg 文件内容如下：

	# http://stackoverflow.com/questions/1972259/mysql-python-install-problem-using-virtualenv-windows-pip
	# Windows connector libs for MySQL. You need a 32-bit connector for your 32-bit Python build.
	connector = C:\Program Files (x86)\MySQL\MySQL Connector C 6.0.2

修改为：

	connector = C:\Program Files\MySQL\MySQL Connector C 6.0.2

5.运行 python setup.py install 即可安装完成。


不想那么麻烦可以直接安装这个 [MySQL-python-1.2.3.win-amd64-py2.7.exe](http://www.codegood.com/download/11/) 

参考：http://www.codegood.com/archives/129