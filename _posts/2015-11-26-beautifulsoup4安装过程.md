---
layout: post
title: Beautiful Soup4安装过程
---

下载Beautiful Soup:

    wget https://pypi.python.org/packages/source/b/beautifulsoup4/beautifulsoup4-4.3.2.tar.gz
   
解压：

    tar -zxvf beautifulsoup4-4.3.2.tar.gz 
    
进目录安装：

    cd beautifulsoup4-4.3.2
    python setup.py install
    
注：Beautiful Soup 3 目前已经停止开发，推荐在现在的项目中使用Beautiful Soup 4，不过它已经被移植到BS4了，也就是说导入时我们需要 import bs4 。


### 用pip安装

	pip install beautifulsoup4


注：

如果报错

FeatureNotFound: Couldn't find a tree builder with the features you requested: html5lib. Do you need to install a parser library?


意思是缺少html5解析库，用pip安装就行：

	pip install html5lib

同理：

bs4.FeatureNotFound: Couldn't find a tree builder with the features you requested: lxml. Do you need to install a parser library?

	pip install lxml