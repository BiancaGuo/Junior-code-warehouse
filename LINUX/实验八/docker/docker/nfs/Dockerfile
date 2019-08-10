FROM ubuntu:14.04

MAINTAINER Bianca

WORKDIR /root

RUN apt-get update && apt-get install -y nfs-kernel-server nfs-common

ADD ./start-nfs-server.sh /usr/local/bin

ADD ./start-nfs-client.sh /usr/local/bin

RUN chmod +x /usr/local/bin/start-nfs-server.sh && chmod +x /usr/local/bin/start-nfs-client.sh


EXPOSE 111/udp 2049/tcp

