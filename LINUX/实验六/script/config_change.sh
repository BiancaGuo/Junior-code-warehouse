#!/bin/bash
source  global_var.sh

sed -i "s/PRO_WHITE_IP/${PRO_WHITE_IP}/g" config/proftpd.conf
sed -i "s/HOST_ONLY_INTER/${HOST_ONLY_INTER}/g" config/interfaces
sed -i "s/INTERNAL_INTER/${INTERNAL_INTER}/g" config/interfaces
sed -i "s/INTERNAL_IP/${INTERNAL_IP}/g" config/interfaces
sed -i "s/INTERNAL_INTER/${INTERNAL_INTER}/g" config/isc-dhcp-server
sed -i "s/SUBNET_SUB/${SUBNET_SUB}/g" config/dhcpd.conf
sed -i "s/SUBNET_BOTTOM/${SUBNET_BOTTOM}/g" config/dhcpd.conf
sed -i "s/SUBNET_TOP/${SUBNET_TOP}/g" config/dhcpd.conf
sed -i "s/INTERNAL_IP/${INTERNAL_IP}/g" config/dhcpd.conf
sed -i "s/INTERNAL_IP/${INTERNAL_IP}/g" config/db.cuc.edu.cn


# use sed to change the configurations
cp -rf config/proftpd.conf /etc/proftpd/proftpd.conf
cp -rf config/exports /etc/exports
cp -rf config/interfaces  /etc/network/interfaces
cp -rf config/isc-dhcp-server /etc/default/isc-dhcp-server
cp -rf config/dhcpd.conf /etc/dhcp/dhcpd.conf
cp -rf config/named.conf.local /etc/bind/named.conf.local
mkdir /etc/bind/zones
cp -rf config/db.cuc.edu.cn /etc/bind/zones/db.cuc.edu.cn