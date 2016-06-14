FROM alpine:3.4

# install build dependencies
RUN \
 apk add --no-cache --virtual=build-dependencies \
	curl \
	g++ \
	gcc \
	openssl-dev \
	make \
	tar \
	wget && \

apk add --no-cache \
	libdvbcsa-dev \
	linux-headers && \

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
 apk del --purge \
	build-dependencies && \

# clean up
 rm -rf /var/cache/apk/* /tmp/*
