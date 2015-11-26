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
