---
layout: post
title: PHP安装mongoDB扩展
---

# windows环境下安装

### windows下安装php_mongodb扩展  (注意! php_mongo扩展官方已经废弃，建议使用php_mongodb)

下载32位TS版本：http://pecl.php.net/package/mongodb

把dll文件放入ext目录，然后去php.ini开启插件 

	extension=php_mongodb.dll

如果是XAMPP建议升级到最新版本，老版本插件可能无法安装

### 解决报错 MongoDB\Driver\Exception\InvalidArgumentException' with message 'Integer overflow detected on your platform

	这个问题发生在php_mongodb.dll 32位 1.4版本的扩展上，官方已经针对该问题做出修复办法。
	我们只需安装1.5以上版本该插件即可解决。



### windows下安装php_mongo扩展

下载32位TS版本：http://pecl.php.net/package/mongo

把dll文件放入ext目录，然后去php.ini开启插件

# linux环境下安装

安装pecl以及依赖包：

	apt install php-pear php5-dev libpcre3 libpcre3-dev 

	pecl install mongodb

安装完需要把模块写入php.ini配置文件

	extension=mongodb.so

顺带说下PDO Driver for PostgreSQL安装：

	apt intall php5-pgsql

### 源码安装

去这个网站下载最新版本 [http://pecl.php.net/package/mongo](http://pecl.php.net/package/mongo)

	wget http://pecl.php.net/get/mongo-1.6.16.tgz -P /root/
    tar -zxvf /root/mongo-1.6.16.tgz -C /root/
    cd /root/mongo-1.6.16/
    phpize
    ./configure
    make install

### pecl安装

    wget http://pear.php.net/go-pear.phar
    php go-pear.phar    //选1然后默认安装

#### 如果遇到: sh: 1: phpize: not found

    apt-get install php5-dev

### 如果遇到： configure: error: Cannot find OpenSSL's libraries

	apt-get install libcurl4-openssl-dev

### 安装完需要把模块写入php.ini配置文件

	extension=mongo.so

### 然后重启apache

	service apache2 restart

