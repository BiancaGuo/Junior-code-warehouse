# 第六章：FTP、NFS、DHCP、DNS、Samba服务器的自动安装与自动配置

----------

## 一、实验环境

* ubuntu 16.04 server 
* 使用多台虚拟机，故实验过程中IP存在变化

## 二、实验过程

### 1、FTP任务

* FTP软件选择：proftpd


	* 安装： sudo apt install proftpd
	* 配置文件：/etc/proftpd/proftpd.conf

* 任务要求：

	* 配置一个提供匿名访问的FTP服务器，匿名访问者可以访问1个目录且仅拥有该目录及其所有子目录的只读访问权限；


	![](https://i.imgur.com/pvGzNMc.jpg)


	* 配置一个支持用户名和密码方式访问的账号，该账号继承匿名访问者所有权限，且拥有对另1个独立目录及其子目录完整读写（包括创建目录、修改文件、删除文件等）权限；
	
		* 参考链接：http://blog.163.com/dingding_jacky/blog/static/166912787201271333147196/

		![](https://i.imgur.com/xLUGuvY.jpg)
	
	* 该账号仅可用于FTP服务访问，不能用于系统shell登录；

		* 通过命令 sudo ftpasswd --passwd --file=/usr/local/etc/proftpd/passwd --name=user1 --uid=1024 --home=/home/user1 --shell=/bin/false 中的最后一项进行设置

		![](https://i.imgur.com/mYSdlJt.jpg)

	* FTP用户不能越权访问指定目录之外的任意其他目录和文件；

	
		* 配置文件中设置：
			
		![](https://i.imgur.com/osOhjCf.jpg)

		* 效果

		![](https://i.imgur.com/kFl2AHc.jpg)

	* 匿名访问权限仅限白名单IP来源用户访问，禁止白名单IP以外的访问；

		* 参考：http://www.proftpd.org/docs/howto/Limit.html

		![](https://i.imgur.com/AUkFYLK.jpg)

		![](https://i.imgur.com/DPpB7Mp.jpg)

	* （可选加分任务）使用FTPS服务代替FTP服务，上述所有要求在FTPS服务中同时得到满足；

		* 配置参考：https://www.tecmint.com/enable-ssl-on-proftpd-in-centos/   
			* 注意：（1）参考文件的bash中有错误，正确的如下：

					#!/bin/bash
					echo -e "\nPlease enter a name for your SSL Certificate and Key pairs:"
					read name
					openssl req -x509 -newkey rsa:1024 \
					-keyout /etc/ssl/private/$name.key -out /etc/ssl/certs/$name.crt \
					-nodes -days 365
					chmod 0600 /etc/ssl/private/$name.key
					
					（2）ubuntu中tls.conf的路径为/etc/proftpd/tls.conf

					（3）在 /etc/proftpd/modules.conf 中添加tls模块即可开启服务

			![](https://i.imgur.com/VwQkWdh.jpg)


### 2、NFS任务

* 在1台Linux上配置NFS服务，另1台电脑上配置NFS客户端挂载2个权限不同的共享目录，分别对应只读访问和读写访问权限；
* 参考资料：https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-mount-on-ubuntu-16-04

	* NFS server：192.168.227.4
	* NFS client：192.168.227.6
	* 创建文件夹后修改/etc/exports文件（bug解决参考：https://blog.csdn.net/zhongzai2010/article/details/38175637）：
		
		* home/ 为只读文件目录
		* var/nfs/general 为读写文件目录
		
		![](https://i.imgur.com/5KZVJad.jpg)

	* mount 添加： sudo mount 192.168.227.4:/home /nfs/home 和  sudo mount 192.168.227.4:/var/nfs/general /nfs/general

	* 目录权限验证：

		![](https://i.imgur.com/GybCRf2.jpg)

* 实验报告中请记录你在NFS客户端上看到的：
	* 共享目录中文件、子目录的属主、权限信息

		![](https://i.imgur.com/GJBGxPx.jpg)
	
	* 你通过NFS客户端在NFS共享目录中新建的目录、创建的文件的属主、权限信息

		![](https://i.imgur.com/JutP4vS.jpg)

	* 上述共享目录中文件、子目录的属主、权限信息和在NFS服务器端上查看到的信息一样吗？无论是否一致，请给出你查到的资料是如何讲解NFS目录中的属主和属主组信息应该如何正确解读

		* 不一致，因为在配置时参数此项未配置，默认为使用root_squash

		![](https://i.imgur.com/qgfBGnO.jpg)
		![](https://i.imgur.com/Na7jROD.jpg)


### 3、DHCP

* 2台虚拟机使用Internal网络模式连接，其中一台虚拟机上配置DHCP服务，另一台服务器作为DHCP客户端，从该DHCP服务器获取网络地址配置

	* 网络设置

	![](https://i.imgur.com/JzFHX9Y.jpg)
	![](https://i.imgur.com/BKMqlRu.jpg)

	* server配置
	
		参考：https://www.ostechnix.com/install-dhcp-server-in-ubuntu-16-04/
		* 修改配置文件：/etc/default/isc-dhcp-server
		* 修改配置文件：/etc/dhcp/dhcpd.conf
		
		* 注意：要先使用  ifconfig enp0s8 10.0.11.1（自己指定） netmask 255.255.255.0 为指定网卡分配IP或直接设置为静态IP（修改 /etc/network/interfaces）

		![](https://i.imgur.com/ULW1sVx.jpg)
		![](https://i.imgur.com/hhVjcsS.jpg)

	* 客户端

		* 设置：
		
		![](https://i.imgur.com/yt3b5xt.jpg)

		* 设置前：

		![](https://i.imgur.com/47R8gZD.jpg)

		* 设置后：
		
		![](https://i.imgur.com/wBuxQEw.jpg)

#### 4、Samba（linux系统作为client端，windows作为server端）

* Linux访问Windows的匿名共享目录

	![](https://i.imgur.com/yI0lQJp.jpg)
	![](https://i.imgur.com/B4O5hXE.jpg)
	![](https://i.imgur.com/D2RVGts.jpg)

* Linux访问Windows的用户名密码方式共享目录


	* bug解决方法：https://wiki.archlinux.org/index.php/Samba#Protocol_negotiation_failed:_NT_STATUS_CONNECTION_RESET

	![](https://i.imgur.com/pWvkJnp.jpg)
	![](https://i.imgur.com/dbOQEjo.jpg)
	![](https://i.imgur.com/dEZ4lpv.jpg)

* 下载整个目录

	* 注意共享文件夹权限问题

	![](https://i.imgur.com/MrG5No5.jpg)
	![](https://i.imgur.com/4pV7Wh8.jpg)

* 安装参考：https://blog.csdn.net/tongxinv/article/details/72631062



#### 5、DNS

* 基于上述Internal网络模式连接的虚拟机实验环境，在DHCP服务器上配置DNS服务，使得另一台作为DNS客户端的主机可以通过该DNS服务器进行DNS查询


	* 参考链接：https://www.ostechnix.com/install-and-configure-dns-server-ubuntu-16-04-lts/

* 在DNS服务器上添加 zone "cuc.edu.cn" 的以下解析记录

 	ns.cuc.edu.cn NS
	ns A 192.168.227.9
	wp.sec.cuc.edu.cn A 192.168.227.3
	dvwa.sec.cuc.edu.cn CNAME wp.sec.cuc.edu.cn

	* server端：

		* 修改/etc/bind/named.conf.local文件
	![](https://i.imgur.com/UWiuQCy.jpg)	

		* 修改 /etc/bind/zones/db.cuc.edu.cn文件
	![](https://i.imgur.com/qe1cTlJ.jpg)
	

		* 重启生效：sudo service bind9 restart


	* client端：


		* 修改/etc/resolvconf/resolv.conf.d/head 文件

			![](https://i.imgur.com/JFBeJeN.jpg)

		* sudo resolvconf -u

		![](https://i.imgur.com/2g8YuBq.jpg)
		![](https://i.imgur.com/6s48UZT.jpg)
		![](https://i.imgur.com/ucgf4dL.jpg)

## 三、无人值守安装

### 1、前期准备：

* 目标系统：192.168.227.6（ubuntu16.04 server）
* 脚本执行系统：192.168.227.13（ubuntu16.04 server）
* 安装expect处理部分人机交互
* 自动安装与自动配置过程的启动脚本要求在本地执行

	* 提示：配置远程目标主机的SSH免密root登录，安装脚本、配置文件可以从工作主机（执行启动脚本所在的主机）上通过scp或rsync方式拷贝或同步到远程目标主机，然后再借助SSH的远程命令执行功能实现远程控制安装和配置

* 进行必要的异常处理
* 目标环境相关参数应使用独立的配置文件或配置脚本（在主调脚本中引用配置脚本）
	* 目标服务器IP
	* 目标服务器SSH服务的端口
	* 目标服务器上使用的用户名
	* 目标服务器上用于临时存储安装脚本、配置文件的临时目录路径


### 2、实验过程

(1) 本地配置要求

* 本地服务器开启免密码sudo
* 赋予脚本执行权限

(2) 相关脚本说明

* 启动脚本

	* main.sh
	
* 配置root免密登录

	* root_login.sh

* 目标环境相关参数

	* global_var.sh

* 软件安装与配置文件备份

	* apt_install.sh

* 配置文件替换

	* config_change.sh

* 其他配置

	* basic_allocation.sh

