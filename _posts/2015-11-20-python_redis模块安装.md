---
layout: post
title: python_redis模块安装
---

### 使用源码安装 ###

    wget --no-check-certificate https://pypi.python.org/packages/source/r/redis/redis-2.8.0.tar.gz
    tar -zvxf redis-2.8.0.tar.gz
    mv redis-2.8.0 python-redis-2.8.0
    cd python-redis-2.8.0
    python setup.py install

### Ubuntu下安装 ###

    apt-get install python-redis

### CentOS下安装 ###

    yum install python-redis