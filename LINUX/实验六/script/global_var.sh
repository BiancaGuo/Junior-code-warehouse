#!/bin/bash


#login
HOST=192.168.227.6
PORT=22
INSTALL_USER=cuc
INSTALL_PASS=CUC
AIM_USER_GENERAL=cuc
AIM_USER_GENERAL_PASS=CUC
RPSW=123
#echo -n "请输入当前系统用户名："
#read INSTALL_USER
#echo -n "请输入当前系统密码："
#read INSTALL_PASS
#echo -n "请输入目标系统普通用户名："
#read AIM_USER_GENERAL
#echo -n "请输入目标系统普通用户密码："
#read AIM_USER_GENERAL_PASS
#目标系统中root用户初始密码
#echo -n "请为目标系统root用户设置密码（若已设置过，请输入原有密码）："
#read RPSW

# 部分操作系统默认配置的 sshd 是禁止 root 用户远程登录的
AIM_USER_ROOT="root"

# FTP:proftpd
# white list
PRO_WHITE_IP="192.168.227.1"
# virtual user
PRO_VIRTUAL_USER="user_ftp"
PRO_VIRTUAL_PASS="pass"
PRO_DIR="/srv/ftp"
PRO_UID="1024"
PRO_GID="1024"
PRO_VIR_DIR="/home/${PRO_VIRTUAL_USER}"
PRO_LIMIT="700"
PRO_FTPASSWD_DIR="/usr/local/etc/proftpd"
PRO_PASSWD_DIR="${PRO_FTPASSWD_DIR}/passwd"
PRO_GROUP_DIR="${PRO_FTPASSWD_DIR}/group"
PRO_GROUP_NAME="virtualusers"



# samba
# samba user
#SAMBA_USERNAME="smbuser"
#SAMBA_PASSWORD="smbpass"
#SAMBA_GROUP="smbgroup"
# directories
#SAMBA_GUEST_DIR="/home/samba/guest"
#SAMBA_DEMO_DIR="/home/samba/demo"
#SAMBA_GUEST_LIMIT="2775"
#SAMBA_DEMO_LIMIT="2770"

# interfaces
HOST_ONLY_INTER="enp0s3"
NAT_INTER="enp0s9"
INTERNAL_INTER="enp0s8"
INTERNAL_IP="10.0.11.1"
INTERNAL_GATEWAY="10.0.11.254"
INTERNAL_NETMASK="255.255.255.0"

# DHCP
# subnet address
SUBNET_SUB="10.0.11.0"
SUBNET_BOTTOM="10.0.11.100"
SUBNET_TOP="10.0.11.200"

