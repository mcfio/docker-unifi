FROM mcfio/java
MAINTAINER nmcfaul

# set environment variables
ARG DEBIAN_FRONTEND="noninteractive"

# unifi package version
ARG UNIFI_VER="5.6.14-f7a900184a"

RUN \
  # add mongodb repo
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 \
  && echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" >> /etc/apt/sources.list.d/mongodb-org-3.4.list \

  # add additional packages
  && apt-get update \
  && apt-get install -y \
    binutils \
    mongodb-org-server \
  
  # Install unifi
  && curl -J -L -o /tmp/unifi.deb -L https://www.ubnt.com/downloads/unifi/${UNIFI_VER}/unifi_sysvinit_all.deb \
  && dpkg -i --force-depends /tmp/unifi.deb \
  
  # Cleanup
  && apt-get clean \
  && rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*
	
# add local files
COPY root/ /

# volumes and ports
WORKDIR /usr/lib/unifi
VOLUME /config
EXPOSE 3478/udp 6789/tcp 8080/tcp 8443/tcp 8843/tcp 8880/tcp 10001/udp