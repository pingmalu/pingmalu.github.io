---
layout: post
title: tesseract使用记录
---

### 快速安装过程

	apt-get install -y tesseract-ocr tesseract-ocr-chi-sim

其中tesseract-ocr-chi-sim是中文包

### 查看帮助

	[ root@1037b128a7a2:~ ]$ tesseract   
	Usage:
	  tesseract imagename|stdin outputbase|stdout [options...] [configfile...]
	
	OCR options:
	  --tessdata-dir /path	specify location of tessdata path
	  -l lang[+lang]	specify language(s) used for OCR
	  -c configvar=value	set value for control parameter.
				Multiple -c arguments are allowed.
	  -psm pagesegmode	specify page segmentation mode.
	These options must occur before any configfile.
	
	pagesegmode values are:
	  0 = Orientation and script detection (OSD) only.
	  1 = Automatic page segmentation with OSD.
	  2 = Automatic page segmentation, but no OSD, or OCR
	  3 = Fully automatic page segmentation, but no OSD. (Default)
	  4 = Assume a single column of text of variable sizes.
	  5 = Assume a single uniform block of vertically aligned text.
	  6 = Assume a single uniform block of text.
	  7 = Treat the image as a single text line.
	  8 = Treat the image as a single word.
	  9 = Treat the image as a single word in a circle.
	  10 = Treat the image as a single character.
	
	Single options:
	  -v --version: version info  //查看版本
	  --list-langs: list available languages for tesseract engine. Can be used with --tessdata-dir. //显示存在的语言包
	  --print-parameters: print tesseract parameters to the stdout. //打印参数

### 使用示例

	# tesseract c.png out -l chi_sim
	Tesseract Open Source OCR Engine v3.03 with Leptonica
	# cat out.txt
    1加9等于几

设置字符白名单(只有大小写字母)：

	# tesseract c.png out -psm 7 -c tessedit_char_whitelist='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'

设置字符黑名单(不含数字)：

	# tesseract c.png out -psm 7 -c tessedit_char_blacklist='0123456789'

-psm 7 表示告诉tesseract c.png图片是一行文本,这个参数可以减少识别错误率(默认为 3)

设置配置文件：

	# vim /usr/share/tesseract-ocr/tessdata/configs/digits
	改成
	tessedit_char_whitelist ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
	# tesseract c.png out -psm 10 digits


# 训练字符集

tesseract默认的识别率并不是很高，但是他强大之处在于可训练。

通过训练，识别率能提高不少。

### 首先安装jTessBoxEditor

去这里下载：https://sourceforge.net/projects/vietocr/files/jTessBoxEditor/

下载后解压到一个目录，然后配置环境变量：

	变量名：TESSDATA_PREFIX
	变量值：D:\02_SOFT\jTessBoxEditor\tesseract-ocr\tessdata

然后给系统变量添加：

	变量名：Path
	变量值：D:\02_SOFT\jTessBoxEditor\tesseract-ocr

### 二值化备选图像

去除图片背景杂色，二值化图像

### 生成tif

用jTessBoxEditor工具->Tools->Merge TIFF 把多张图像合并成tif文件

tif命名规范：

	[lang].[fontname].exp[num].tif

其中lang为语言名称，fontname为字体名称，num为序号，可以随便定义。

### 然后用脚本生成box文件

下面是我写的自动处理脚本（运行在windows环境）：

1.自动生成box文件.bat

{% highlight bat %}

for /f %%i in ('dir /b /o:d *.tif') do (
        echo %%i
        set filen=%%~nxi
    )

if exist %filen% goto aaa
    echo tif file not found
    pause
    exit
:aaa

for /f "tokens=1,2,3,4 delims=. " %%a in ('echo %filen%') do (
    set fontname=%%b
    set ifname=%%a
    echo %%a
    echo %%b
    echo %%c
    echo %%d
    )

set fname=%ifname%.%fontname%.exp0

tesseract %fname%.tif %fname% batch.nochop makebox

{% endhighlight %}

生成box文件里：后面的四个数字分别是这个字符的左、下、右、上四个边框的坐标值，坐标以图片左下角为坐标原点0，0


### 对自动识别结果进行修正

1.2.接下来需要手动打开jTessBoxEditor.jar工具-打开tif文件，对识别结果进行修正。

### 然后生成最终文件

2.生成最终文件.bat

{% highlight bat %}

for /f %%i in ('dir /b /o:d *.tif') do (
        echo %%i
        set filen=%%~nxi
    )

if exist %filen% goto aaa
    echo TIF file not found
    pause
    exit
:aaa

for /f "tokens=1,2,3,4 delims=. " %%a in ('echo %filen%') do (
    set fontname=%%b
    set ifname=%%a
    echo %%a
    echo %%b
    echo %%c
    echo %%d
    )
set fname=%ifname%.%fontname%.exp0

if exist %fname%.box goto bbb
    echo BOX file not found
    pause
    exit
:bbb

echo Run Tesseract for Training..  
tesseract.exe %fname%.tif %fname% box.train  

if exist font_properties goto exit
   echo %fontname% 0 0 0 0 0 > font_properties
:exit

echo Compute the Character Set..  
unicharset_extractor.exe %fname%.box  
mftraining -F font_properties -U unicharset -O %ifname%.unicharset %fname%.tr  
  
echo Clustering..  
cntraining.exe %fname%.tr  
  
echo Rename Files..  
rename normproto %ifname%.normproto  
rename inttemp %ifname%.inttemp  
rename pffmtable %ifname%.pffmtable  
rename shapetable %ifname%.shapetable   
  
echo Create Tessdata..  
combine_tessdata.exe %ifname%. 
@pause

{% endhighlight %}

这样在目录下会生成xx.traineddata字库文件，把它拿到tesseract目录：

linux：/usr/share/tesseract-ocr/tessdata

windows：jTessBoxEditor\tesseract-ocr\tessdata

执行：

	tesseract malu.jpg out -l xx

就能识别了

3.再附上一个自动清理目录.bat

{% highlight bat %}

for /f %%i in ('dir /b /o:d *.tif') do (
        echo %%i
        set filen=%%~nxi
    )

if exist %filen% goto aaa
    echo TIF file not found
    pause
    exit
:aaa

for /f "tokens=1,2,3,4 delims=. " %%a in ('echo %filen%') do (
    set fontname=%%b
    set ifname=%%a
    echo %%a
    echo %%b
    echo %%c
    echo %%d
    )
set fname=%ifname%.%fontname%.exp0

del font_properties
del normproto
del inttemp
del pffmtable
del shapetable
del unicharset

del %ifname%.normproto  
del %ifname%.inttemp  
del %ifname%.pffmtable  
del %ifname%.shapetable
del %ifname%.unicharset


{% endhighlight %}

会把转换过程中的临时文件进行清理


参考博文: http://blog.csdn.net/yasi_xi/article/details/8763385



# 编译安装

编译安装 tesseract 首先需要安装 leptonica，否则编译tesseract 的时候出现 "configure: error: leptonica not found"。

leptonica下载地址：[http://www.leptonica.org/download.html](http://www.leptonica.org/download.html)

安装过程

	tar -zxvf leptonica-1.73.tar.gz
	cd leptonica-1.73
	./configure 
	make
	make install


### 下载安装tesseract

tesseract下载地址：[https://github.com/tesseract-ocr/tesseract/releases](https://github.com/tesseract-ocr/tesseract/releases)

安装过程

	wget https://github.com/tesseract-ocr/tesseract/archive/3.04.01.tar.gz
	tar -zxvf 3.04.01.tar.gz 
	cd tesseract-3.04.01/
	./autogen.sh 
	./configure
	make -j4
	make install

下面可以查看版本了：

	[ root@2dfc0631f40e:/usr/local/bin ]$ ./tesseract -v
	tesseract 3.04.01
	 leptonica-1.73
	  zlib 1.2.8


如果出现错误：

	[ root@2dfc0631f40e:/usr/local/bin ]$ ./tesseract 
	./tesseract: error while loading shared libraries: liblept.so.5: cannot open shared object file: No such file or directory

那么需执行一下ldconfig命令

> ldconfig命令的用途,
> 
> 主要是在默认搜寻目录(/lib和/usr/lib)以及动态库配置文件/etc/ld.so.conf内所列的目录下, 
> 
> 搜索出可共享的动态链接库(格式如lib*.so*), 进而创建出动态装入程序(ld.so)所需的连接和缓存文件. 
> 
> 缓存文件默认为/etc/ld.so.cache, 此文件保存已排好序的动态链接库名字列表.
> 


### 安装语言数据包

下载地址：[https://github.com/tesseract-ocr/tessdata](https://github.com/tesseract-ocr/tessdata)

下载安装：

	cd /usr/local/share/tessdata
	wget https://github.com/tesseract-ocr/tessdata/raw/master/eng.traineddata

如果出现错误：

	提示缺少liblept.so.4，没找到此共享库
	Error in pixReadStreamPng: function not present
	Error in pixReadStream: png: no pix returned
	Error in pixGetInputFormat: pix not defined
	Error in pixRead: image not returned
	Error in fopenReadStream: file not found
	Error in pixRead: image file not found

安装必要的库，然后重新编译安装leptonica：

	$ sudo apt-get install libjpeg-dev libpng-dev libtiff4-dev
	$ cd leptonica-1.73
	$ ./configure && make && sudo make install
