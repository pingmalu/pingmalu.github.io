---
layout: post
title: 新浪SEC安装docker环境
---

以下是安装记录

    yum -y install http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
    
    yum install docker-io
    
    yum upgrade device-mapper-libs 
    
    sudo groupadd docker
    
    sudo usermod -a -G docker $USER 
    
    service docker start
    
    chkconfig docker on
    
    docker -d
    
    docker images
    
    sudo docker info