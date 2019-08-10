# 第五章：WEB服务器实验


----------

## 一、实验环境

* ubuntu 16.04 server 
* nginx/1.10.3 (Ubuntu) 
* VeryNginx【80 port】
* WordPress 4.7【8082 port 443 port】
* DVWA【8080 port 】
* 本机IP：

	![](https://i.imgur.com/cSAYM1i.jpg)

## 二、实验检查点

### 1、基本要求

* 在一台主机（虚拟机）上同时配置Nginx和VeryNginx

	* 配置VeryNginx：
	
		* 安装方法参见：https://github.com/alexazhou/VeryNginx/blob/master/readme_zh.md
		* bug解决方法参见：https://github.com/alexazhou/VeryNginx/wiki/Trouble-Shooting

	![1](https://i.imgur.com/0fobBlU.jpg)

	
	* 配置Nginx
	
		* 安装方法：sudo apt install nginx

	![2](https://i.imgur.com/23gmFzF.jpg)


* VeryNginx作为本次实验的Web App的反向代理服务器和WAF
* PHP-FPM进程的反向代理配置在nginx服务器上，VeryNginx服务器不直接配置Web站点服务

	![](https://i.imgur.com/1KIcvb6.jpg)
	![](https://i.imgur.com/ABOmjdw.jpg)

* 使用Wordpress搭建的站点对外提供访问的地址为： https://wp.sec.cuc.edu.cn 和 http://wp.sec.cuc.edu.cn
	* 搭建wordpress站点：https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-with-lamp-on-ubuntu-16-04
	* 配置http和https同时支持：https://www.server-world.info/en/note?os=Ubuntu_16.04&p=nginx&f=4

	![](https://i.imgur.com/s1RaP0o.jpg)
	
	![](https://i.imgur.com/gb1RYQ2.jpg)

* 使用Damn Vulnerable Web Application (DVWA)搭建的站点对外提供访问的地址为： http://dvwa.sec.cuc.edu.cn

	![](https://i.imgur.com/M3veEa2.jpg)

### 2、安全加固要求

* 使用IP地址方式均无法访问上述任意站点，并向访客展示自定义的友好错误提示信息页面-1

	* 相关配置：
	
	![](https://i.imgur.com/I4Y1aad.jpg)
	![](https://i.imgur.com/hPd4DAx.jpg)
	![](https://i.imgur.com/NKzCLZw.jpg)

	* 配置后：
	
	![](https://i.imgur.com/t4U7rs2.jpg)

* Damn Vulnerable Web Application (DVWA)只允许白名单上的访客来源IP，其他来源的IP访问均向访客展示自定义的友好错误提示信息页面-2


	* 相关配置（假设白名单中ip为192.168.67.2）：
	
	![](https://i.imgur.com/Rg9fE3m.jpg)
	![](https://i.imgur.com/W5vgWgE.jpg)
	![](https://i.imgur.com/8QtmtNO.jpg)

	* 配置后不允许本机IP访问指定站点：
	
	![](https://i.imgur.com/WFqFC1F.jpg)
	
* 在不升级Wordpress版本的情况下，通过定制VeryNginx的访问控制策略规则，热修复WordPress < 4.7.1 - Username Enumeration

	* 漏洞详情：https://www.exploit-db.com/exploits/41497/ or https://www.seebug.org/vuldb/ssvid-92732

	* 相关配置：
	
	![](https://i.imgur.com/g6OybOK.jpg)
	![](https://i.imgur.com/gT9hbK0.jpg)
	![](https://i.imgur.com/iKllcIC.jpg)

	* 配置前：
	
	![](https://i.imgur.com/ElyMm0e.jpg)

	* 配置后：
	
	![](https://i.imgur.com/Tain6Ch.jpg)

* 通过配置VeryNginx的Filter规则实现对Damn Vulnerable Web Application (DVWA)的SQL注入实验在低安全等级条件下进行防护

	* filter前：
	
	![](https://i.imgur.com/dHY2BQ4.jpg)

	* 相关配置

	![](https://i.imgur.com/yStROwV.jpg)
	![](https://i.imgur.com/62NJeJC.jpg)
	![](https://i.imgur.com/NcSpbsX.jpg)

	* 配置后：
	
	![](https://i.imgur.com/W1EDnc5.jpg)

### 3、VERYNGINX配置要求

* VeryNginx的Web管理页面仅允许白名单上的访客来源IP，其他来源的IP访问均向访客展示自定义的友好错误提示信息页面-3

	* 配置：
	
	![](https://i.imgur.com/R6x6Odf.jpg)
	![](https://i.imgur.com/dmwCmwZ.jpg)
	![](https://i.imgur.com/feK98Y7.jpg)

	* 配置后：

	![](https://i.imgur.com/zdphRVQ.jpg)

* 通过定制VeryNginx的访问控制策略规则实现：

	* 限制DVWA站点的单IP访问速率为每秒请求数 < 50

		![](https://i.imgur.com/yGexKWQ.jpg)

	* 限制Wordpress站点的单IP访问速率为每秒请求数 < 20
	
		![](https://i.imgur.com/mf1zwW8.jpg)

		* 配置：

			![](https://i.imgur.com/Hu0Ea0t.jpg)
			![](https://i.imgur.com/xJERHul.jpg)


	* 超过访问频率限制的请求直接返回自定义错误提示信息页面-4
	
		* curl查看页面返回数据：
		
			![](https://i.imgur.com/Ivs0B4X.jpg)

	* 禁止curl访问
	
		*	配置：
		
			![](https://i.imgur.com/1zISZRV.jpg)
			![](https://i.imgur.com/15evHWv.jpg)

		* 测试：

			![](https://i.imgur.com/EWv2Zql.jpg)

## 三、实验反思

1、在wordpress仪表盘设置中直接更改域名会导致wordpress无法登陆，正确方法应为先进行后台hosts设置

2、nginx配置文件中可以进行同一IP不同端口对应不同服务的设置

* [/etc/nginx/sites-available/default 文件](/file/default)

3、wordpress相关配置

* [/opt/verynginx/verynginx/configs/config.json](/file/config.json)