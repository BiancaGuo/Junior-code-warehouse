# 第三章：动手实战SYSTEMD

----------


## 一、环境配置

* Ubuntu 16.04 Server 64bit
* 在asciinema注册一个账号，并在本地安装配置好asciinema

## 二、实验过程

### 1、 Systemd 入门教程：命令篇

* 参考资料：http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-commands.html

* 演示：
* https://asciinema.org/a/PlST0B15CAzPNIyfI2VuvAH92
* https://asciinema.org/a/GqpSgveySl30ErxytfCez21k8
* https://asciinema.org/a/AIxNXvZ9sJ3Zp543crNxmduZl
* https://asciinema.org/a/O0ZYRoGf2Z1saf5gQyZWLKLpH

**设置当前时区未成功**

错误提示如下：

![](https://i.imgur.com/yNHV6NW.jpg)

### 2、 Systemd 入门教程：实战篇

* 参考资料：http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-part-two.html

* 演示：
* https://asciinema.org/a/NjeTd18BQ2hUA1JfSHA4KhjMH
* https://asciinema.org/a/DYPpdqjf9ueBFheNT4W4fFfr1

**更改sshd.service中的[Service]内选项，未成功，sudo systemctl start sshd 后无任何反应**

    [Service]
	ExecStart=/bin/echo execstart1
	ExecStart=
	ExecStart=/bin/echo execstart2
	ExecStartPost=/bin/echo post1
	ExecStartPost=/bin/echo post2


* https://asciinema.org/a/DGaA6qVV4TnDwUZai69OojPPj


## 三、自查清单

* 如何添加一个用户并使其具备sudo执行程序的权限？


	* add user添加用户，修改/etc/sudoers文件

	* 演示：	
		* https://asciinema.org/a/mGklAmywRI320r7vOz6G41BaA

* 如何将一个用户添加到一个用户组？


	* usermod -G groupname username


	* 演示：
		* https://asciinema.org/a/or15klnMCYFaRtFqjeJ3AzwbF


* 如何查看当前系统的分区表和文件系统详细信息？

	* 查看分区表：fdisk -l  查看文件系统详情：df -Th

	* 演示：
		* https://asciinema.org/a/EPk7ozwOmMXxpsg10leqC5Swq


* 如何实现开机自动挂载Virtualbox的共享目录分区？


	*  /etc/fstab 文件添加 `sharing /mnt/share vboxsf defaults 0 0`

	*  或者在/etc/rc.local 中追加`mount -t vboxsf sharing /mnt/share`
	
	**本机增强功能还未安装成功，故未对上述命令进行实践**

* 基于LVM（逻辑分卷管理）的分区如何实现动态扩容和缩减容量？


	* 参考资料：http://wangshengzhuang.com/2017/05/27/Linux/Linux%E5%9F%BA%E7%A1%80/LVM%E5%9F%BA%E7%A1%80%E5%8F%8A%E5%9C%A8%E7%BA%BF%E6%89%A9%E5%AE%B9/
	* 演示：
		* https://asciinema.org/a/EB9zAtpVTi6tIEse3gN6E5w2E
		* https://asciinema.org/a/zr1Pnl3zPkDX0UtRQrLPsiyVA


* 如何通过systemd设置实现在网络连通时运行一个指定脚本，在网络断开时运行另一个脚本？

	* 方法：更改/etc/systemd/system/network-online.target.wants/networking.service配置文件下的[Service]部分属性

	![](https://i.imgur.com/2vqmhlT.jpg)

	* 演示效果：
		* https://asciinema.org/a/J782FTpWvJFwjr27GxkYjAmuV
		* https://asciinema.org/a/wcA0m2g6byS2RtQEAvZWhxxM4
	

	
* 如何通过systemd设置实现一个脚本在任何情况下被杀死之后会立即重新启动？实现杀不死？


	* 在/etc/systemd/system/caddy.service下创建cannotbekill(ed).service

	![](https://i.imgur.com/1OOMinC.jpg)

	* 执行sudo systemctl enable cannotbekill（Systemd只执行/etc/systemd/system目录里面的配置文件）
	* 编写service开启时调用的cannotstop.sh脚本
	* sudo systemctl start cannotbekill开启服务
	* 演示效果：
		* https://asciinema.org/a/celPUrPZumJJPnlqeRh2DxgQT
