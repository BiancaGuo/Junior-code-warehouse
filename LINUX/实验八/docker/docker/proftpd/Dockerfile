FROM	    ubuntu:16.04
MAINTAINER  Bianca

USER        root
ENV         PRO_WHITE_IP 192.168.227.1
ENV         PRO_VIRTUAL_USER user_ftp
ENV         PRO_VIRTUAL_PASS pass
ENV         PRO_DIR "/srv/ftp"
ENV         PRO_UID "1024"
ENV         PRO_GID "1024"
ENV         PRO_VIR_DIR /home/$PRO_VIRTUAL_USER
ENV         PRO_LIMIT 700
ENV         PRO_FTPASSWD_DIR /usr/local/etc/proftpd
ENV         PRO_PASSWD_DIR $PRO_FTPASSWD_DIR/passwd
ENV         PRO_GROUP_DIR $PRO_FTPASSWD_DIR/group
ENV         PRO_GROUP_NAME "virtualusers"

ENV         RUNLEVEL 1
# Avoid ERROR: invoke-rc.d: policy-rc.d denied execution of start.
RUN         sed -i "s/^exit 101$/exit 0/" /usr/sbin/policy-rc.d

        
RUN        apt-get -qq update -y \
		&&  apt install -y proftpd \
		&&  mkdir -p $PRO_DIR \ 
		&&  chown -R ftp:nogroup $PRO_DIR \
		&&  usermod -d $PRO_DIR ftp \
		&&  mkdir -p $PRO_VIR_DIR \
		&&  chown -R $PRO_UID:$PRO_GID $PRO_VIR_DIR \
		&&  chmod -R $PRO_LIMIT $PRO_VIR_DIR \ 
		&&  mkdir -p $PRO_FTPASSWD_DIR \
		&&  echo $PRO_VIRTUAL_PASS | ftpasswd --passwd --file=$PRO_PASSWD_DIR --name=$PRO_VIRTUAL_USER --uid=$PRO_UID --home=$PRO_VIR_DIR --shell=/bin/false --stdin \
		&&  ftpasswd --file=$PRO_GROUP_DIR --group --name=$PRO_GROUP_NAME --gid=$PRO_GID \
		&&  ftpasswd --group --name=$PRO_GROUP_NAME --gid=$PRO_GID --member=$PRO_VIRTUAL_USER --file=$PRO_GROUP_DIR

			
COPY        ./proftpd.conf /etc/proftpd
RUN         sed -i "s/PRO_WHITE_IP/$PRO_WHITE_IP/g" /etc/proftpd/proftpd.conf        
RUN         chown root:root /etc/proftpd/proftpd.conf 
#COPY        ./proftpd.conf /etc/proftpd/
	
VOLUME /etc/proftpd
EXPOSE		20 21
#ENTRYPOINT ["/entrypoint.sh"]
CMD          ["proftpd","--nodaemon"]

