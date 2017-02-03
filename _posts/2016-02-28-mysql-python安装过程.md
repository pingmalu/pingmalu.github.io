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