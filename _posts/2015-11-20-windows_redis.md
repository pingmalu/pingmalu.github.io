---
layout: post
title: window下安装redis以及安装PHP-redis插件
---

## PHP redis扩展下载： ##
[http://windows.php.net/downloads/pecl/snaps/redis/2.2.5/](http://windows.php.net/downloads/pecl/snaps/redis/2.2.5/)

[http://windows.php.net/downloads/pecl/releases/redis/2.2.7/](http://windows.php.net/downloads/pecl/releases/redis/2.2.7/)

下载好后，只要把dll文件放入F:\wamp\bin\php\php5.5.12\ext 目录，然后在wamp中点击php插件redis即可


## PHP igbinary扩展下载： ##
http://pecl.php.net/package/igbinary/1.2.1/windows

php.ini添加

> extension=php_igbinary.dll
> 
> extension=php_redis.dll


## windows版redis安装 ##
https://github.com/MSOpenTech/redis/releases

安装windows版本教程：
[http://jingyan.baidu.com/article/f25ef2546119fd482c1b8214.html](http://jingyan.baidu.com/article/f25ef2546119fd482c1b8214.html)


出现错误，添加redis.windows.conf
> maxheap 1024000000

运行

> redia-server.exe redis.windows.conf

Redis在线文档

[http://redisdoc.com/](http://redisdoc.com/)

[http://doc.redisfans.com/](http://doc.redisfans.com/)

[http://www.runoob.com/redis/](http://www.runoob.com/redis/)