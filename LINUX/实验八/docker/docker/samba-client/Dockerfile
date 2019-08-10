FROM	    ubuntu
MAINTAINER  Bianca

USER        root



ENV RUNLEVEL 1
# Avoid ERROR: invoke-rc.d: policy-rc.d denied execution of start.
RUN sed -i "s/^exit 101$/exit 0/" /usr/sbin/policy-rc.d

        
RUN         apt-get update \
                &&  apt install -y smbclient \
                &&  rm -rf /var/lib/apt/lists/* \
                &&  mkdir -p /etc/smbclient

ADD         ./entrypoint.sh /etc/smbclient


RUN         chmod +x /etc/smbclient/entrypoint.sh
	


ENTRYPOINT ["/etc/smbclient/entrypoint.sh"]




	


