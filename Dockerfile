FROM alpine:3.4

# install build dependencies and stuff..
RUN \
 apk add --no-cache --virtual=build-dependencies \
	curl \
	g++ \
	gcc \
	openssl-dev \
	make \
	tar \
	wget && \

# add runtime dependencies
 apk add --no-cache \
	libdvbcsa-dev \
	linux-headers \
	s6 \
	s6-portable-utils && \

# fetch satip source
 wget -O \
	/tmp/satip.tar.gz https://github.com/catalinii/minisatip/archive/master.tar.gz && \
	mkdir -p /app/satip && \
	tar xvf /tmp/satip.tar.gz -C /app/satip --strip-components=1 && \

# compile satip
 cd /app/satip && \
	./configure && \
	make && \

# add s6 overlay
  wget -O \
	/tmp/s6-overlay.tar.gz -L \
	https://github.com/just-containers/s6-overlay/releases/download/v1.18.1.0/s6-overlay-nobin.tar.gz && \
	tar xvfz /tmp/s6-overlay.tar.gz -C / && \

 # uninstall build dependencies
 apk del --purge \
	build-dependencies && \

# clean up
 rm -rf /var/cache/apk/* /tmp/*

# add runtime dependencies
RUN \
 apk add --no-cache \
	openssl && \

# clean up
 rm -rf /var/cache/apk/*

# add local files
COPY root/ /

ENTRYPOINT ["/init"]

# ports and volumes
EXPOSE 8875 554 1900/udp
