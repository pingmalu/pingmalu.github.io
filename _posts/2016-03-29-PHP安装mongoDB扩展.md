---
layout: post
title: PHP安装mongoDB扩展
---

### 快速安装

	pecl install mongo

### pecl安装

    wget http://pear.php.net/go-pear.phar
    php go-pear.phar    //选1然后默认安装

#### 如果遇到: sh: 1: phpize: not found

    apt-get install php5-dev

### 安装完需要把模块写入php.ini配置文件

	extension=mongo.so

### 然后重启apache

	service apache2 restart

### 模糊查询测试

{% highlight php %}
<?php
   // 连接到mongodb
   $m = new MongoClient("xxx.malu.me:123456");
   // 选择一个数据库
   $db = $m->mydb;
   // 选择一个表
   $collection = $db->user;
   $name = 'python';
   $query = array('title' => new MongoRegex("/.*".$name.".*/i"));
   $cursor = $collection->find($query);
   // 迭代显示文档标题
   // var_dump($cursor);
   foreach ($cursor as $document) {
      echo $document["title"] . "\n";
   }
?>
{% endhighlight %}
