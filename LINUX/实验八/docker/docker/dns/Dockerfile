FROM	    ubuntu:16.04
MAINTAINER  Bianca

USER        root

ENV         ZONES /etc/bind/zones
ENV         INTERNAL_IP 10.0.11.1


ENV         RUNLEVEL 1
# Avoid ERROR: invoke-rc.d: policy-rc.d denied execution of start.
RUN sed -i "s/^exit 101$/exit 0/" /usr/sbin/policy-rc.d

        
RUN        apt-get -qq update \
		&&  apt install -y bind9 dnsutils \
		&&  mkdir -p $ZONES \
		&&  mkdir -p /etc/dns
		
			
COPY        ./named.conf.local /etc/bind/
COPY        ./db.cuc.edu.cn $ZONES
RUN         sed -i "s/INTERNAL_IP/$INTERNAL_IP/g" /etc/bind/zones/db.cuc.edu.cn          
COPY        ./entrypoint.sh /etc/dns
RUN         chmod +x /etc/dns/entrypoint.sh
#ADD         ./dns.stop /etc/sv/dns/finish

	
ENTRYPOINT ["/etc/dns/entrypoint.sh"]
#CMD [ "sh", "-c", "service bind9.service restart; bash"]


