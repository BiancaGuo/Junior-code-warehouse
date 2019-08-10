FROM ubuntu
MAINTAINER Bianca
ENV INTERNAL_INTER "eth0"
# Install the DHCP server
RUN apt update -qq -y
RUN apt install -y isc-dhcp-server

# Expose the DHCP server port on the container
EXPOSE 67/udp
COPY ./dhcpd.conf /etc/dhcp
COPY ./dhcpd.leases /etc/dhcp
#COPY ./interfaces /etc/network
COPY ./isc-dhcp-server /etc/default
COPY ./entrypoint.sh /etc/dhcp
RUN  sed -i "s/INTERNAL_INTER/$INTERNAL_INTER/g" /etc/default/isc-dhcp-server 
RUN  chmod +x /etc/dhcp/dhcpd.conf && chmod +x /etc/dhcp/dhcpd.leases && chmod +x /etc/dhcp/entrypoint.sh 
# Start the DHCP server in the foreground,
# with config files from /data.
ENTRYPOINT ["/etc/dhcp/entrypoint.sh"]
