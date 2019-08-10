#!/bin/bash

service networking restart
#service isc-dhcp-server restart
dhcpd -cf /etc/dhcp/dhcpd.conf -lf /etc/dhcp/dhcpd.leases --no-pid -4 -f eth0

while [[ true ]]; do
	sleep 1
done

