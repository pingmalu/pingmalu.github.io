---
layout: post
title: 接口自动化测试postman+newman
---

postman下载地址：

[https://www.getpostman.com/apps](https://www.getpostman.com/apps)

postman编写测试代码：

参考官方说明文档：[https://www.getpostman.com/docs/testing_examples](https://www.getpostman.com/docs/testing_examples)

TV4 json校验解析器：[https://github.com/geraintluff/tv4](https://github.com/geraintluff/tv4)


newman源码地址：

[https://github.com/postmanlabs/newman](https://github.com/postmanlabs/newman)

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

