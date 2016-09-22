---
layout: post
title:  "接口自动化测试postman+newman"
---

postman下载地址：

[https://www.getpostman.com/apps](https://www.getpostman.com/apps)

newman快速安装过程:

	npm install -g newman

注：newman最新版需要nodejs4.x以上支持

查看版本：

	newman --version

从postman导出collections，后缀为xxx.postman_test_run.json文件到安装newman的机器环境下。

newman测试：

	newman run test.postman_collection.json

导出成html（使用环境变量）：

	newman run --reporters html test.postman_collection.json --reporter-html-export htmlOutput.html --export-environment svn.com.postman_environment.json

