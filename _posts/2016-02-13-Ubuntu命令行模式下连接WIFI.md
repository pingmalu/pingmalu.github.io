---
layout: post
title: Ubuntu命令行模式下连接WIFI
---

iwconfig key方式适用于WEP

	iwconfig wlan0 essid "TP-link" key 1234-5678

该方法对WPA加密方式不支持，解决方法是用wpasupplicant软件：

	wpa_passphrase ESSID PWD > xxx.conf
	wpa_supplicant -B -i wlan0 -Dwext -c ./xxx.conf
	iwconfig wlan0
	dhclient wlan0