#!/bin/bash

source global_var.sh

# FTP
if [ ! -d "$PRO_DIR" ] ; then
  mkdir $PRO_DIR
fi
chown -R ftp:nogroup $PRO_DIR
usermod -d $PRO_DIR ftp

if [ ! -d "$PRO_VIR_DIR" ] ; then
  mkdir $PRO_VIR_DIR
fi
chown -R $PRO_UID:$PRO_GID $PRO_VIR_DIR
chmod -R $PRO_LIMIT $PRO_VIR_DIR

if [ ! -d "$PRO_FTPASSWD_DIR" ] ; then
  mkdir $PRO_FTPASSWD_DIR
fi

/usr/bin/expect << EOF
spawn ftpasswd --passwd --file=$PRO_PASSWD_DIR --name=$PRO_VIRTUAL_USER --uid=$PRO_UID --home=$PRO_VIR_DIR --shell=/bin/false
expect {
 "Password:" {send "${PRO_VIRTUAL_PASS}\r"; exp_continue}
 "Re-type password:" {send "${PRO_VIRTUAL_PASS}\r";}
}
expect eof
EOF
ftpasswd --file=$PRO_GROUP_DIR --group --name=$PRO_GROUP_NAME --gid=$PRO_GID

systemctl restart proftpd


# NFS
NFS_GEN_DIR="/var/nfs/general"
NFS_HOME_DIR="/home"
if [ ! -d "$NFS_GEN_DIR" ] ; then
  mkdir $NFS_GEN_DIR -p
fi
chown nobody:nogroup $NFS_GEN_DIR
systemctl restart nfs-kernel-server


# DHCP
systemctl restart networking
systemctl restart isc-dhcp-server

# DNS
systemctl restart bind9.service