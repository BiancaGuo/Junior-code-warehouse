#!/bin/bash

rpcbind

for directory in $* 
do
	source=`echo $directory | awk -F':' '{ print $1 }'`
    target=`echo $directory | awk -F':' '{ print $2 }'`
    mkdir -p $target
    mount $NFS_SERVER_IP:$source $target
done

# just keep this script running
while [[ true ]]; do
	sleep 1
done

