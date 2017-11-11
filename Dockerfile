FROM mcfio/java
MAINTAINER nmcfaul

# unifi package version
ARG UNIFI_VER="5.7.4-8fd8ebcbcc"

RUN apk upgrade --update \
  # Install mongodb
  && apk add --no-cache --virtual=build-dependencies \
    curl \
    tar \
  && apk add --no-cache \
    mongodb \

  # Install unifi
  && curl -J -L -o /tmp/UniFi.unix.zip https://www.ubnt.com/downloads/unifi/${UNIFI_VER}/UniFi.unix.zip \
  && mkdir -p /usr/lib/unifi \
  && cd /tmp && unzip UniFi.unix.zip \
  && cp -vr /tmp/UniFi/* /usr/lib/unifi \
  && rm /usr/lib/unifi/bin/mongod \
  && ln -s /usr/bin/mongod /usr/lib/unifi/bin/mongod \
  
  # Cleanup
  && apk del --purge \
    build-dependencies \
  && rm -rf \
    /tmp/*
	
# add local files
COPY root/ /

# volumes and ports
WORKDIR /usr/lib/unifi
VOLUME /config
EXPOSE 3478/udp 6789/tcp 8080/tcp 8443/tcp 8843/tcp 8880/tcp 10001/udp
