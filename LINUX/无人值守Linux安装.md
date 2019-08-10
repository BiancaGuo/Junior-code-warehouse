# 第一章：LINUX基础（实验）

----------


## 一、无人值守安装ubuntu系统

### 1、实验目标

（1）定制一个普通用户名和默认密码

（2）定制安装OpenSSH Server

（3）安装过程禁止自动联网更新软件包

### 2、实验环境

* Virtualbox
* ubuntu16.04.4-server-amd64.iso
* 虚拟主机配置双网卡，其中配置host-only网卡时，需要启用dhcp服务器才能分配到ip地址，以便putty连接

![](https://i.imgur.com/8YOrjdS.jpg)

（更正：Host-only 的IP设置过于随意了 1.1.1.2 是 APNIC.NET 的互联网地址，不是私有地址；）

* 现Host-only的IP重设为 192.168.227.3，putty需重新配置，但配置步骤相同


### 2、实验过程

(1) 使用putty免密连接虚拟主机

免密配置方法：

*  putty生成私钥
*  将私钥（更正：公钥）存入虚拟机

![](https://i.imgur.com/kULx1Pb.jpg)

*  将登录用户名存储到putty上

![](https://i.imgur.com/eDzyElX.jpg)

*  将私钥导入putty

![](https://i.imgur.com/9kK29cv.jpg)


*  don't forget to save！

![](https://i.imgur.com/3jstiDl.jpg)


（2）将待修改打包的iso镜像使用psftp传入虚拟主机

![](https://i.imgur.com/AOcnEKd.jpg)


（3）按以下步骤操作，将光盘内容到目标工作目录

    # 在当前用户目录下创建一个用于挂载iso镜像文件的目录
    mkdir loopdir

    # 挂载iso镜像文件到该目录
    mount -o loop ubuntu-16.04.1-server-amd64.iso loopdir

    # 创建一个工作目录用于克隆光盘内容
    mkdir cd

    # 同步光盘内容到目标工作目录
    # 一定要注意loopdir后的这个/，cd后面不能有/

    rsync -av loopdir/ cd
    # 卸载iso镜像
    umount loopdir

![](https://i.imgur.com/C810Mto.jpg)


（4）编辑Ubuntu安装引导界面增加一个新菜单项入口

    # 进入目标工作目录
    cd cd/
	#修改
    vim isolinux/txt.cfg
	#添加以下内容到该文件后强制保存退出
	label autoinstall
	  menu label ^Auto Install Ubuntu Server
	  kernel /install/vmlinuz
	  append  file=/cdrom/preseed/ubuntu-server-autoinstall.seed debian-installer/locale=en_US console-setup/layoutcode=us keyboard-configuration/layoutcode=us console-setup/ask_detect=false localechooser/translation/warn-light=true localechooser/translation/warn-severe=true initrd=/install/initrd.gz root=/dev/ram rw quiet


![](https://i.imgur.com/Tn5L9rZ.jpg)

* **注意：新添加选项一定要放到文件头部，否则执行时将按顺序先执行手动安装选项**

（5）该添加有自动安装选项定制信息的ubuntu-server-autoinstall.seed文件保存到~/cd/preseed/下

![](https://i.imgur.com/e8ty7UT.jpg)

（6）修改isolinux/isolinux.cfg，增加内容timeout 10（更正：完全可以改为0，不等待这10s），使开机时自动进入安装界面

![](https://i.imgur.com/0st4UHo.jpg)

（7）重新生成md5sum.txt

![](https://i.imgur.com/RxWBf4B.jpg)

* 注意：生成MD5文件需要修改文件权限或提升至管理员权限（更正：chmod 777 * 有毒，用root -s提权即可）

（8）封闭改动后的目录到custom.iso

![](https://i.imgur.com/mbfieGf.jpg)

（9）将生成的iso文件使用psftp重新传回到宿主机

![](https://i.imgur.com/1AcgZO1.jpg)

（10）无人值守安装Ubuntu

![](https://i.imgur.com/2PsZaWN.png)

## 二、相关问题

### 1、Virtualbox安装完Ubuntu之后新添加的网卡如何实现系统开机自动启用和自动获取IP


参考资料：https://jingyan.baidu.com/article/f25ef25414e8ea482d1b8265.html（有毒）

* 注意默认网卡为enp0s3


![](https://i.imgur.com/v5xYhxm.png)


### 2、如何使用sftp在虚拟机和宿主机之间传输文件？

（1）使用psftp传输文件

* 连接宿主机：open [宿主机IP]
* 上传：put [文件名]
* 下载：get [文件名]

* **注意：不指定目录的情况下，上传到虚拟机根目录（更正：上传到当前用户家目录），下载到putty根目录**

（2）安装virtualbox增强功能使用共享文件夹

参考资料：http://blog.csdn.net/yaolong336/article/details/78030500

## 三、定制好的ubuntu-server-autoinstall.seed与官方示例文件对比

* 左侧为修改后文件

1、添加多种支持本地支持语言（en，zh），跳过安装时语言支持的设置

![](https://i.imgur.com/K0Wryrw.jpg)

2、设置链路等待超时和DHCP超时为5s，选择手动配置网络

![](https://i.imgur.com/a1lKY2g.jpg)

3、网络配置

![](https://i.imgur.com/Ss1nHXo.jpg)

4、配置域名和主机名

![](https://i.imgur.com/yNqO9Uv.jpg)

5、定制一个普通用户名和默认密码

![](https://i.imgur.com/FSklYBG.jpg)

6、设置时区，安装期间不实用NTP设置时钟

![](https://i.imgur.com/UQEAnT4.jpg)

7、LVM分区中逻辑卷设置为最大。分成/home，/var和/tmp三个分区（multi）

![](https://i.imgur.com/3oed0bW.jpg)

8、安装时不实用网络镜像

![](https://i.imgur.com/eUOCcF8.jpg)

9、定制安装OpenSSH Server，不自动升级；将软件升级模式设置为automatically（自动）

![](https://i.imgur.com/19RRJIa.jpg)