#!/bin/bash

service bind9 start
# just keep this script running
while [[ true ]]; do
	sleep 1
done

