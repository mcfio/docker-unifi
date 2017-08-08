FROM lsiobase/xenial

# unifi package version
ARG UNIFI_VER="5.6.12-d503e7daad"

# add mongodb repo
RUN \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 && \
  echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" >> /etc/apt/sources.list.d/mongodb-org-3.4.list && \
  
  # add additional packages
  apt-get update && \
  apt-get install -y \
	binutils \
	jsvc \
	mongodb-org-server \
	openjdk-8-jre-headless \
	wget && \
  
  # install unifi
  curl -o \
  /tmp/unifi.deb -L\
  "https://www.ubnt.com/downloads/unifi/${UNIFI_VER}/unifi_sysvinit_all.deb" && \
  dpkg -i /tmp/unifi.deb && \
  
  # cleanup
  apt-get clean && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*
	
# add local files
COPY root/ /

# volumes and ports
WORKDIR /usr/lib/unifi
VOLUME /config
EXPOSE 3478 5678 8080 8081 8443 8843 8880