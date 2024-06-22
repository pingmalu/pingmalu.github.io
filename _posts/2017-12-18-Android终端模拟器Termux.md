---
layout: post
title: Android终端模拟器Termux
---

Termux是一个Android终端模拟器和Linux环境应用程序，可直接使用，无需root或设置。


官网：[https://termux.com/](https://termux.com/)

国内用户去这里下载：[https://f-droid.org/packages/com.termux/](https://f-droid.org/packages/com.termux/)

termux清华大学开源软件镜像站[https://mirrors.tuna.tsinghua.edu.cn/help/termux/](https://mirrors.tuna.tsinghua.edu.cn/help/termux/)

# SSH启动连接

启动：

	sshd

连接(默认监听端口8022)：

	ssh ip -p 8022

# 安装pandas

``` shell
pkg i tur-repo
pkg update
pkg i python-pandas
```

# 安装wakeonlan


	pip install wakeonlan

### 内部存储和外部存储（sd卡）访问

参考官方文档：[https://termux.com/storage.html](https://termux.com/storage.html)

先把**termux-setup-storage**安装好

再往$HOME目录建立storage文件夹

	mkdir storage 

然后执行（需要在手机终端下执行，远程ssh执行无效）

	termux-setup-storage

比如建好后：

	bash-4.4$ ls ~/storage/
	dcim        downloads   external-1  movies      music       pictures    shared

external-1即是外部sd卡目录


### 调用摄像头等设备

参考文档:[https://wiki.termux.com/wiki/Termux:API](https://wiki.termux.com/wiki/Termux:API)

先去安装：termux.api   [https://f-droid.org/packages/com.termux.api/](https://f-droid.org/packages/com.termux.api/)

然后执行：

	 pkg install termux-api

拍照:

	termux-camera-photo 1.jpg

### 开机启动

参考文档：[https://wiki.termux.com/wiki/Termux:Boot](https://wiki.termux.com/wiki/Termux:Boot)

先安装：termux.boot [https://f-droid.org/packages/com.termux.boot/](https://f-droid.org/packages/com.termux.boot/)

执行一下termux.boot让它能开机启动，然后建立目录 ~/.termux/boot/

比如要启动sshd和python脚本, 在该目录下建立启动文件~/.termux/boot/start-boot：

	termux-wake-lock
	sshd
	python2 xxx.py
	/data/data/com.termux/files/home/Mammoth_x/Bash/Mammoth_x_pyinstaller/Mammoth_x



### Python环境相关

默认安装pip3，在pip list会出现警告，需要在$HOME目录建立文件
	
	bash-4.4$ cat ~/.pip/pip.conf 
	[global]
	format=legacy

有些库会依赖clang编译，需要把clang安装上

	apt install clang


### PyInstaller安装问题

PyInstaller在arm平台下打包编译会有问题，原因是默认会加载Linux-64bit引导程序

我们只需在arm下重新编译bootloader，然后替换掉Linux-64bit里的run文件：

PyInstaller源码下载：[https://github.com/pyinstaller/pyinstaller/releases](https://github.com/pyinstaller/pyinstaller/releases)

操作过程：

1.解压源码

2.进入目录 PyInstaller-3.3/bootloader

3.执行（注意python版本，如果是python3那用 python3 ./waf distclean all）

	python2 ./waf distclean all

正常情况下编译结束会在build/release/ 目录下有个run文件

	bash-4.4$ file build/release/run 
	build/release/run: ELF 64-bit LSB shared object, ARM aarch64, version 1 (SYSV), dynamically linked, interpreter /system/bin/linker64, stripped

如果报错：

> ../../src/pyi_launch.c:32:14: fatal error: 'langinfo.h' file not found

那先把对应行号注释调吧，目前用下来暂时没啥影响。(貌似是python2下才会出现)

4.然后把PyInstaller-3.3/PyInstaller/bootloader/Linux-64bit-aarch/ 目录下的文件copy至/data/data/com.termux/files/usr/lib/python2.7/site-packages/PyInstaller/bootloader/Linux-64bit/


注：PyInstaller-3.3.1 修复了引导问题，但是langinfo.h的问题还是可以通过上述办法解决。


## 报错    psutil/_psutil_common.c:9:10: fatal error: 'Python.h' file not found 处理办法

	// 注意是安装对应python-dev，比如Python2
	apt install python2-dev

## 报错   python2.7/Python.h:47:10: fatal error: 'crypt.h' file not found  解决办法

	// 缺少crypt库导致
	pkg install libcrypt-dev

## 如果pyinstaller是Python3的，想给Python2也安装，那么只要去源码目录用Python2重新安装即可

	python2 setup.py install

## hashhack完整包

	apt install python2 python2-dev clang libcrypt-dev 
	pip2 install psutil socketIO_client



## 报错   [25709] INTERNAL ERROR: cannot create temporary directory!

	//默认会去根目录 /tmp 下建立临时文件，我们只需指定零时文件目录即可
	export TMPDIR="/data/data/com.termux/files/usr/tmp"




# 使用触摸键盘

使用Ctrl键是使用终端的必要条件 - 但大多数触摸键盘都不包含一个。为此，Termux使用音量减小按钮来模拟Ctrl键。例如，在触摸键盘上按下音量减小键+ L将发送与在硬件键盘上按Ctrl + L相同的输入。

使用Ctrl键和键的结果取决于使用哪个程序，但是对于许多命令行工具，以下快捷键可用：

Ctrl + A→移动光标到行首
Ctrl + C→中止（发送SIGINT到）当前进程
Ctrl + D→注销终端会话
Ctrl + E→移动光标到行尾
Ctrl + K→从光标删除到行尾
Ctrl + L→清除终端
Ctrl + Z→挂起（发送SIGTSTP到）当前进程
音量增加键也是产生特定输入的特殊键：

音量提高+ E→退出键
音量增加+ T→Tab键
音量增加+ 1→F1（和音量增加+ 2→F2等）
音量增加+ 0→F10
音量增加+ B→Alt + B，使用readline时返回一个单词
音量增加+ F→Alt + F，使用readline时转发一个单词
音量增加+ X→Alt + X
音量增加+ W→向上箭头键
音量增加+ A→左箭头键
音量增加+ S→向下箭头键
音量增加+ D→向右箭头键
音量增加+ L→| （管道字符）
音量加+ H→〜（代字符）
音量增加+ U→_（下划线）
音量提高+ P→上一页
音量增加+ N→下一页
音量增加。→Ctrl + \（SIGQUIT）
音量增加+ V→显示音量控制
音量增加+ Q→显示额外的按键视图

# 额外的按键视图

termux也有一个额外的按键视图。它允许您使用ESC，CTRL，ALT，TAB， - ，/和|键扩展当前的键盘。要启用额外的按键视图，您必须长按左抽屉菜单中的键盘按钮。您也可以按音量增加+ Q。

# 文本输入视图

终端模拟器通常不支持自动更正，预测和滑动输入等触摸键盘的高级功能。为了解决这个问题，Termux有一个文本输入视图。输入的文本将被粘贴到终端。由于是原生Android文本输入视图，因此所有触摸键盘功能都可以使用。要访问文本输入视图，您必须将额外的按键视图向左滑动。


# 使用硬件键盘

将Termux与硬件（如蓝牙）键盘结合使用时，可以使用以下快捷键：Ctrl + Alt：

'C'→创建新的会话
'R'→重命名当前会话
向下箭头（或“N”）→下一个会话
向上箭头（或“P”）→上一个会话
右箭头→打开抽屉
左箭头→关闭抽屉
'F'→切换全屏
'M'→显示菜单
'U'→选择URL
'V'→粘贴
+/-→调整文字大小
1-9→进入编号会话


# 搭建MQTT服务器

安装 mosquitto

	apt install mosquitto

增加用户test，设置密码

	mosquitto_passwd -c /data/data/com.termux/files/usr/etc/mosquitto/passwd test

编辑配置文件 /data/data/com.termux/files/usr/etc/mosquitto/mosquitto.conf

修改监听端口

	listener 1234

启动

	mosquitto -c /data/data/com.termux/files/usr/etc/mosquitto/mosquitto.conf


# 异常

通过BCompare中sftp的ansi编码模式方式上传中文文件，导致乱码且删不掉文件的解决办法：

将文件移动到同级的上层目录，例如

	mv 文件夹名 ../上层目录/文件夹名

