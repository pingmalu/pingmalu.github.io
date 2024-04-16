---
layout: post
title: JavaScript
---

# JavaScript 中等号判断

[![JavaScript](https://wx2.sinaimg.cn/large/a83bb572gy1g30lcizj9aj21bi12vjxs.jpg)](https://wx2.sinaimg.cn/large/a83bb572gy1g30lcizj9aj21bi12vjxs.jpg)


# ES6 浏览器兼容

### 如果在页面直接写ES6语法，会导致低版本浏览器不兼容，通过引入browser和browser-polyfill来支持：

    <script src="https://cdn.staticfile.org/babel-core/5.8.38/browser.min.js"></script>
    <script src="https://cdn.staticfile.org/babel-core/5.8.38/browser-polyfill.min.js"></script>

### Bluebird 是早期 Promise 的一种实现，它提供了丰富的方法和语法糖，一方面降低了 Promise 的使用难度，一方面扩展了 Promise 的功能：

    <script src="https://cdn.jsdelivr.net/bluebird/3.5.0/bluebird.min.js"></script>

### 针对浏览器来选择 polyfill,在线创建一个兼容脚本

[https://polyfill.io/v3/url-builder/](https://polyfill.io/v3/url-builder/)

使用方法：

    <script crossorigin="anonymous" src="https://cdn.polyfill.io/v2/polyfill.min.js?features=Promise"></script>
    或者
    <script crossorigin="anonymous" src="https://polyfill.io/v3/polyfill.min.js?features=Promise"></script>


### 在线把ES6转成ES5

谷歌的：[http://google.github.io/traceur-compiler/demo/repl.html](http://google.github.io/traceur-compiler/demo/repl.html)

Babel：[https://babeljs.io/repl](https://babeljs.io/repl)



