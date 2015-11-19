---
layout: post
title: GO安装过程
---
官方下载地址：[https://golang.org/dl/](https://golang.org/dl/)

源码安装方法：

      wget -q -O ~/go.tgz https://storage.googleapis.com/golang/go1.5.1.linux-amd64.tar.gz
      tar -C $HOME -xzf ~/go.tgz
      export GOROOT=$HOME/go
      export PATH=$SHIPPABLE_GOPATH/bin:$HOME/go/bin:$PATH
      go version


go编程教程：[https://github.com/astaxie/build-web-application-with-golang/blob/master/zh/preface.md](https://github.com/astaxie/build-web-application-with-golang/blob/master/zh/preface.md)