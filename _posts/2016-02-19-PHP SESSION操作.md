---
layout: post
title: PHP SESSION操作
---

### 通常取SESSION_ID操作

	session_start();
	$_SESSION['name'] = "malu";
	
	echo session_id();
	echo $_SESSION['name'];

### 服务端关闭设置cookie，用URL传递SESSION_ID

	ini_set("session.use_trans_sid",1);
	ini_set("session.use_cookies",0);
	ini_set("session.use_only_cookies",0);

	echo '<a href=?'.session_name().'='.session_id().'>传递SESSION</a>';

### 设置SESSION作用域 (注作用域与当前域名一致，否则导致SESSION无法使用)

	ini_set("session.cookie_domain",'malu.me');

### 使用Redis保存SESSION

{% highlight php %}
<?php
class SessionManager{
  private $redis;
  private $sessionSavePath;
  private $sessionName;
  private $sessionExpireTime = 30;
  public function __construct(){
    $this->redis = new Redis();
    $this->redis->connect('127.0.0.1',6379);  //连接redis
    $retval = session_set_save_handler(
      array($this,"open"),
      array($this,"close"),
      array($this,"read"),
      array($this,"write"),
      array($this,"destory"),
      array($this,"gc")
    );
      session_start();
  }
    
    public function open($path,$name){
      return true;
    }
    public function close(){
      return true;
    }
    public function read($id){
      $value = $this->redis->get($id);
      if($value){
        return $value;
      }else{
        return "";
      }
    }
    public function write($id,$data){
      if($this->redis->set($id,$data)){
        $this->redis->expire($id,$this->sessionExpireTime); 
         //设置过期时间
        return true;
      }
      return false;
    }
    public function destory($id){
      if($this->redis->delete($id)){
        return true;
      }
      return false;
    }
    public function gc($maxlifetime){
      return true;
    }
    //析构函数
    public function __destruct(){
      session_write_close();
    }
      
} 


$re = new SessionManager();
$_SESSION['name'] = "malu";
echo session_id();
echo $_SESSION['name'];
{% endhighlight %}