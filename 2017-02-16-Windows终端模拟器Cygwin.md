---
layout: post
title: Windows终端模拟器Cygwin
---

Cygwin是一个在windows平台上运行的类UNIX模拟环境

官网：[https://cygwin.com/](https://cygwin.com/)

### 安装:

下载地址： [https://cygwin.com/setup-x86.exe](https://cygwin.com/setup-x86.exe)

### 使用国内源:

	http://mirrors.163.com/cygwin/
	或
	http://mirrors.sohu.com/cygwin/

### 安装apt-cyg

apt-cyg是Cygwin环境下的软件安装工具,相当于Ubuntu下的apt-get命令

依赖的工具:wget、tar、gawk、bzip2

这些工具可以使用Cygwin安装setup-x86.exe选择安装

下载地址：[https://github.com/transcode-open/apt-cyg](https://github.com/transcode-open/apt-cyg)

安装：

	wget rawgit.com/transcode-open/apt-cyg/master/apt-cyg
	install apt-cyg /bin

### apt-cyg的使用

设置安装源

	apt-cyg -m http://mirrors.163.com/cygwin

更新源

	apt-cyg update

安装软件：

	apt-cyg install vim

### Cygwin安装pip

依赖工具：python环境、libuuid-devel和binutils

下载地址：[https://bootstrap.pypa.io/get-pip.py](https://bootstrap.pypa.io/get-pip.py)

安装：

	python get-pip.py

