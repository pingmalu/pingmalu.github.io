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

设置字符白名单(只有数字和大小字母)：

	# tesseract c.png out -c tessedit_char_whitelist='ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'

设置字符黑名单(不含数字)：

	# tesseract c.png out -c tessedit_char_blacklist='0123456789'

设置配置文件：

	# vim /usr/share/tesseract-ocr/tessdata/configs/digits
	改成
	tessedit_char_whitelist ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
	# tesseract c.png out -psm 10 digits



