---
layout: post
title: PHP安装mongoDB扩展
---

### 快速安装

	pecl install mongo

### 源码安装

去这个网站下载最新版本 [http://pecl.php.net/package/mongo](http://pecl.php.net/package/mongo)

	wget http://pecl.php.net/get/mongo-1.6.13.tgz -P /root/
    tar -zxvf /root/mongo-1.6.13.tgz -C /root/
    cd /root/mongo-1.6.13/
    phpize
    ./configure
    make install

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

#### PHP mongoDB常用查询

{% highlight php %}
<?php
//字段字串为
$querys = array（"name"=>"malu"）；
//数值等于多少
$querys = array（"number"=>7）；
//数值大于多少
$querys = array（"number"=>array（'$gt' => 5））；
//数值大于等于多少
$querys = array（"number"=>array（'$gte' => 2））；
//数值小于多少
$querys = array（"number"=>array（'$lt' => 5））；
//数值小于等于多少
$querys = array（"number"=>array（'$lte' => 2））；
//数值介于多少
$querys = array（"number"=>array（'$gt' => 1，'$lt' => 9））；
//数值不等于某值
$querys = array（"number"=>array（'$ne' => 9））；
//使用js下查询条件
$js ="function（）{
return this.number == 2 && this.name == 'shian'；
}";
$querys = array（'$where'=>$js）；
//字段等于哪些值
$querys = array（"number"=>array（'$in' => array（1,2,9）））；
//字段不等于哪些值
$querys = array（"number"=>array（'$nin' => array（1,2,9）））；
//使用正则查询
$querys = array（"name"=>  new MongoRegex("/.*".$name.".*/i")）；
//或
$querys = array（'$or' => array（array（'number'=>2），array（'number'=>9）））；
?>
{% endhighlight %}
