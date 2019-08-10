#!/bin/bash

NFS_GEN_DIR = "/var/nfs/general"
NFS_HOME_DIR = "/home"

mkdir -p /var/nfs/general
echo "/var/nfs/general *(rw,sync,no_subtree_check,fsid=1,no_root_squash)" >> /etc/exports


mkdir -p /var/nfs/readonly
echo "/var/nfs/readonly *(sync,no_root_squash,fsid=1,no_subtree_check)" >> /etc/exports

exportfs -a

rpcbind

service nfs-kernel-server start 

# just keep this script running
while [[ true ]]; do
	sleep 1
done

