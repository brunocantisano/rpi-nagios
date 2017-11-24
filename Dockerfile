FROM resin/rpi-raspbian:latest

MAINTAINER Bruno Cardoso Cantisano

ENV	DEBIAN_FRONTEND=noninteractive
ENV	nagios=nagios-4.1.1
ENV	livestatusversion=1.2.6p16
ENV	nagiosplugins=nagios-plugins-2.1.1
ENV	nagvis=nagvis-1.8.5
ENV	nagiosgraphversion=1.5.2
ENV	nrpeversion=nrpe-2.15
ENV     ndoutilsversion=1.5.2
ENV     centreonpage=0.0.0.0:9430
ENV     dokuwikipage=0.0.0.0:9411
ENV     mantisbtpage=0.0.0.0:9408
ENV     centreonlogin=admin
ENV     centreonpassword=admin
ENV     dokuwikilogin=admin
ENV     dokuwikipassword=admin
ENV     mantisbtlogin=admin
ENV     mantisbtpassword=admin

RUN apt-get update && \
     apt-get install -y --no-install-recommends \
		gcc	\
		apache2 \
		php5 	\
	       	php5-gd \
	       	php5-sqlite	\
	       	apache2-utils 	\
		xinetd 		\
		supervisor \
		git \
		rsync \
		nano \
		wget \
		postfix \
                telnet \
		make \
		unzip \
		openssl    			   \
		libssl-dev  			   \
		ca-certificates			   \
		libcgi-pm-perl \
		librrds-perl \
		libgd-gd2-perl \
		libnagios-object-perl \

# Packages pour mklive
		build-essential dpatch dnsutils fping smbclient \
		git-buildpackage libboost-all-dev \
		libcloog-ppl1 libcurl4-openssl-dev  libevent-dev \
		libgd2-xpm-dev libglib2.0-dev libgnutls28-dev \
		libldap2-dev libltdl-dev libmcrypt-dev \
		libmysqlclient15-dev libpango1.0-dev \
		libperl-dev libreadline-dev libssl-dev libxml2-dev patch \
		python-dev python-setuptools uuid-dev snmp snmpd libnet-snmp-perl apache2-threaded-dev \
		libncurses5-dev dietlibc-dev  libpcap-dev  gettext  libgsf-1-dev \
		libradiusclient-ng-dev \
		libjson-perl libnagios-plugin-perl libwww-perl \
		aptitude 	      && \
		apt-get clean 	      && \
		apt-get autoclean     && \
		rm -rf /var/lib/apt/lists/* \
                /tmp/* 		    \
		/var/tmp/* 	    && \

### enable apache modules.. \
    	a2enmod rewrite && \
    	a2enmod cgi && \
    \
    ### add nagios (and www-data) user and make them part of nagioscmd group \
    	useradd -ms /bin/bash nagios && \
    	groupadd nagcmd && \
    	usermod -a -G nagcmd nagios && \
    	usermod -a -G nagcmd www-data

WORKDIR /usr/local/src/${nagios}
RUN	wget https://assets.nagios.com/downloads/nagioscore/releases/${nagios}.tar.gz && \
    	tar -zxvf ${nagios}.tar.gz -C ../					      && \
	./configure --with-command-group=nagcmd 				      && \
    	make all    								      && \
    	make install 								      && \
    	make install-init 							      && \
    	make install-config 							      && \
    	make install-commandmode 						      && \
    	/usr/bin/install -c					\
			 -m 644					\
			 sample-config/httpd.conf		\
			 /etc/apache2/sites-enabled/nagios.conf && \
    	echo -n admin | htpasswd -i -c /usr/local/nagios/etc/htpasswd.users nagiosadmin && \

	rm -rf /usr/local/src/${nagios}


WORKDIR /usr/local/src/check-mk-raw-${livestatusversion}.cre
RUN	wget https://mathias-kettner.de/support/${livestatusversion}/check-mk-raw-${livestatusversion}.cre.tar.gz && \
	tar -zxvf check-mk-raw-${livestatusversion}.cre.tar.gz -C ../ && \
	rm -rf check-mk-raw-${livestatusversion}.cre.tar.gz    	      && \
	./configure --with-nagios4 	&& \
	make 	    			&& \
### specifically make mk-livestatus package /again/ with the --with-nagios4 flag,
### by default it's build for nagios3 which doesn't work.. \
### /usr/local/lib/mk-livestatus/livestatus.o /usr/local/nagios/var/rw/live
        cd ./packages/mk-livestatus/mk-livestatus-${livestatusversion} && \
    	make clean && \
	./configure --with-nagios4 && \
    	make && \
    	make install && \
       rm -rf /usr/local/src/check-mk-raw-${livestatusversion}.cre

WORKDIR /usr/local/src/${nagiosplugins}
RUN 	wget http://nagios-plugins.org/download/${nagiosplugins}.tar.gz && \
	tar -zxvf ${nagiosplugins}.tar.gz -C ../			&& \
	./configure --with-nagios-user=nagios				   \
		    --with-nagios-group=nagios 				   \
		    --with-openssl					&& \
    	make 								&& \
    	make install 							&& \
	rm -rf /usr/local/src/${nagiosplugins}

WORKDIR /usr/local/src/${ndoutilsversion}

#RUN wget http://downloads.sourceforge.net/project/nagios/ndoutils-1.x/ndoutils-${ndoutilsversion}/ndoutils-${ndoutilsversion}.tar.gz    && \
#    tar xzvf ndoutils-${ndoutilsversion}.tar.gz && \
#    rm -rf /usr/local/src/ndoutils-${ndoutilsversion}.tar.gz && \
#    cd ndoutils-${ndoutilsversion} && \
#    bash -c "CFLAGS=-DDEBUG_NDO2DB \
#    ./configure --prefix=/usr/local/nagios/ \
#    --enable-mysql --disable-pgsql \
#    --with-ndo2db-user=nagios \
#    --with-ndo2db-group=nagios 2>&1 | tail -n 10" && \
#    make 2>&1 | tail -n 10 && \
#    cp src/ndomod-3x.o /usr/local/nagios/bin/ndomod.o && \
#    cp src/ndo2db-3x /usr/local/nagios/bin/ndo2db && \
#    cp src/log2ndo /usr/local/nagios/bin/ && \
#    cp src/file2sock /usr/local/nagios/bin/ && \
#    chmod 774 /usr/local/nagios/bin/ndo* && \
#    chown nagios:nagios /usr/local/nagios/bin/ndo* && \
#    rm -rf /usr/local/src/ndoutils-${ndoutilsversion}

RUN mkdir -p -m 0755 /usr/share/snmp/mibs && \
    touch /usr/share/snmp/mibs/.foo && \
    ln -s /usr/share/snmp/mibs /usr/local/nagios/libexec/mibs

RUN sed -i 's,/bin/mail,/usr/bin/mail,' /usr/local/nagios/etc/objects/commands.cfg && \
    sed -i 's,/usr/usr,/usr,'           /usr/local/nagios/etc/objects/commands.cfg

RUN cp /etc/services /var/spool/postfix/etc/

WORKDIR /usr/local/src/${nagvis}
RUN	wget http://www.nagvis.org/share/${nagvis}.tar.gz	&& \
   	tar -zxvf ${nagvis}.tar.gz -C ../			&& \
	./install.sh -n /usr/local/nagios			   \
		     -p /usr/local/nagvis			   \
		     -l "unix:/usr/local/nagios/var/rw/live"	   \
		     -b mklivestatus				   \
		     -u www-data				   \
		     -g www-data				   \
		     -w /etc/apache2/conf-enabled		   \
		     -a y					   \
		     -F -q 				        && \
	rm -rf /usr/local/src/${nagvis}				&& \

### Fix nagvis apache2.4 vhost
    	printf "%s\n" "<Directory \"/usr/local/nagvis/share\">" \
	       	      "  Require all granted"			\
		      "</Directory>"				\
	>> /etc/apache2/conf-enabled/nagvis.conf

WORKDIR /usr/local/src/nagiosgraph-${nagiosgraphversion}
RUN    	wget http://downloads.sourceforge.net/project/nagiosgraph/nagiosgraph/${nagiosgraphversion}/nagiosgraph-${nagiosgraphversion}.tar.gz && \
	tar -zxvf nagiosgraph-${nagiosgraphversion}.tar.gz -C ../ && \
	./install.pl --check-prereq				  && \
    	NG_PREFIX=/usr/local/nagiosgraph			     \
	NG_WWW_DIR=/usr/local/nagios/share 			     \
	./install.pl --prefix=/usr/local/nagiosgraph 		  && \
	rm -rf /usr/local/src/nagiosgraph-${nagiosgraphversion}	  && \

### Fix nagiosgraph vhost
    	cp -prv /usr/local/nagiosgraph/etc/nagiosgraph-apache.conf /etc/apache2/sites-enabled/ && \
    	printf "%s\n" "<Directory \"/usr/local/nagiosgraph/cgi/\">"	\
    	       	      "  Require all granted"				\
    		      "</Directory>"					\
	>> /etc/apache2/sites-enabled/nagiosgraph-apache.conf		&& \

### fix the perfdata log location in nagiosgraph.conf \
    	sed -i 's/\/tmp\/perfdata.log/\/usr\/local\/nagios\/var\/perfdata.log/' /usr/local/nagiosgraph/etc/nagiosgraph.conf

WORKDIR /usr/local/src/${nrpeversion}
RUN	wget http://downloads.sourceforge.net/project/nagios/nrpe-2.x/${nrpeversion}/${nrpeversion}.tar.gz && \
   	tar -zxvf ${nrpeversion}.tar.gz -C ../			&& \
	./configure --enable-command-args  			\
		    --with-nagios-user=nagios			\
		    --with-nagios-group=nagios			\
		    --with-ssl=/usr/bin/openssl			\
		    --with-ssl-lib=/usr/lib/arm-linux-gnueabihf && \
	make all    						&& \
	make install-xinetd					&& \
	make install-daemon-config				&& \
        make install						&& \
	#sed -i
	rm -rf /usr/local/src/${nrpeversion}

WORKDIR	/root

COPY provisioning/supervisord.conf	/etc/supervisor/conf.d/supervisord.conf
COPY provisioning/nagios-config		/usr/local/nagios/etc
COPY provisioning/nagvis-config		/usr/local/nagvis/etc
COPY provisioning/nagios-plugins	/usr/local/nagios/libexec-custom
COPY provisioning/index.php		/var/www/html/index.php
ADD  provisioning/css                   /var/www/html/
ADD  provisioning/images                /var/www/html/
COPY provisioning/nagvis-config		/usr/local/nagvis/etc
COPY provisioning/nagvis-config/shapes	/usr/local/nagvis/share/userfiles/images/
COPY provisioning/postfix.init          /etc/sv/postfix/run

RUN \
	chown nagios:nagcmd /usr/local/nagios/etc -R	&& \
	chown www-data:www-data /usr/local/nagvis -R	&& \
	rm /var/www/html/index.html		  	&& \
	ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime

RUN cd /usr/local/nagios/libexec && \
	wget https://raw.githubusercontent.com/c-kr/check_json/master/check_json.pl && \
	chmod a+x check_json.pl

ADD entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

EXPOSE 80 5666

VOLUME /usr/local/nagios/ /usr/local/nagiosgraph /usr/local/nagvis /usr/share/snmp/mibs

ENTRYPOINT ["/entrypoint.sh"]

CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
