#!/bin/bash

source global_var.sh

KNOWN_HOSTS="/root/.ssh/known_hosts"
if [ -d "$KNOWN_HOSTS" ] ; then
  rm $KNOWN_HOSTS
fi


#设置root权限免密登录，相关配置文件下载到本地config/实验六/config/文件夹下
bash root_login.sh

#将配置文件传到目标主机~/config文件夹下
scp -r config/实验六/config/ $AIM_USER_ROOT@$HOST:~/config
#scp globl_var.sh $AIM_USER_ROOT@$HOST:
#ssh $username@$ip 'bash -s' < apt-ins.sh

#全局变量
scp global_var.sh $AIM_USER_ROOT@$HOST:~

#执行apt软件安装与配置文件备份
ssh $AIM_USER_ROOT@$HOST 'bash -s' < apt_install.sh

#配置文件替换
ssh $AIM_USER_ROOT@$HOST 'bash -s' < config_change.sh

#相关基础命令行配置
ssh $AIM_USER_ROOT@$HOST 'bash -s' < basic_allocation.sh