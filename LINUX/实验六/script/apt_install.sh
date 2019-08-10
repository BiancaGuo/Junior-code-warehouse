#!/bin/bash

source  global_var.sh

# update & install
apt update
if [ $? -ne 0 ] ; then
  echo "Error : Fail to update"
  exit 0
else
  apt install -y  proftpd nfs-kernel-server smbclient isc-dhcp-server bind9 expect
  if [ $? -ne 0 ] ; then
    echo "Error : Fail to install the packages"
    exit 0
  fi
fi


# 配置文件备份
# FTP:proftpd
cp /etc/proftpd/proftpd.conf /etc/proftpd/proftpd.conf.bak
# NFS
cp /etc/exports /etc/exports.bak
# DHCP
cp /etc/network/interfaces  /etc/network/interfaces.bak
cp /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server.bak
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bak
# DNS:bind9
cp /etc/bind/named.conf.local /etc/bind/named.conf.local.bak