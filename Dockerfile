FROM ubuntu:16.04

# install build dependencies
RUN \
 apt-get update && \
 apt-get install -y \
	g++ \
	gcc \
	libdvbcsa-dev \
	libssh-dev \
	make \
	wget && \

# fetch source
 wget -O \
	/tmp/satip.tar.gz https://github.com/catalinii/minisatip/archive/master.tar.gz && \
	mkdir -p /app/satip && \
	tar xvf /tmp/satip.tar.gz -C /app/satip --strip-components=1 && \

# compile satip
 cd /app/satip && \
	./configure && \
	make && \

# uninstall build dependencies
 apt-get purge --remove -y \
	g++ \
	gcc \
	libssh-dev \
	make \
        wget && \

 apt-get autoremove -y && \
 apt-get autoclean -y && \

# install runtime dependencies
 apt-get install -y \
	openssl && \

# cleanup
 apt-get clean && \
 rm -rfv /tmp/* /var/lib/apt/lists/* /var/tmp/*
