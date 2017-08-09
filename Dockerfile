FROM mcfio/zesty

# unifi package version
ARG UNIFI_VER="5.6.12-d503e7daad"

RUN \
  apt-get update && \
  # add mongodb repo
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 && \
  echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" >> /etc/apt/sources.list.d/mongodb-org-3.4.list && \

  # add oracle java 8 repository
  apt-get install -y software-properties-common && \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
    
  # add additional packages
  apt-get update && \
  apt-get install -y \
	  binutils \
    jsvc \
    mongodb-org-server \
    oracle-java8-installer \
    libcap2 \
  && \
  
  # Minimize JVM installation, so annoyingly huge
  rm -rf /usr/lib/jvm/java-8-oracle/*src.zip \
    /usr/lib/jvm/java-8-oracle/lib/missioncontrol \
    /usr/lib/jvm/java-8-oracle/lib/visualvm \
    /usr/lib/jvm/java-8-oracle/lib/*javafx* \
    /usr/lib/jvm/java-8-oracle/jre/lib/plugin.jar \
    /usr/lib/jvm/java-8-oracle/jre/lib/ext/jfxrt.jar \
    /usr/lib/jvm/java-8-oracle/jre/bin/javaws \
    /usr/lib/jvm/java-8-oracle/jre/lib/javaws.jar \
    /usr/lib/jvm/java-8-oracle/jre/lib/desktop \
    /usr/lib/jvm/java-8-oracle/jre/plugin \
    /usr/lib/jvm/java-8-oracle/jre/lib/deploy* \
    /usr/lib/jvm/java-8-oracle/jre/lib/*javafx* \
    /usr/lib/jvm/java-8-oracle/jre/lib/*jfx* \
    /usr/lib/jvm/java-8-oracle/jre/lib/amd64/libdecora_sse.so \
    /usr/lib/jvm/java-8-oracle/jre/lib/amd64/libprism_*.so \
    /usr/lib/jvm/java-8-oracle/jre/lib/amd64/libfxplugins.so \
    /usr/lib/jvm/java-8-oracle/jre/lib/amd64/libglass.so \
    /usr/lib/jvm/java-8-oracle/jre/lib/amd64/libgstreamer-lite.so \
    /usr/lib/jvm/java-8-oracle/jre/lib/amd64/libjavafx*.so \
    /usr/lib/jvm/java-8-oracle/jre/lib/amd64/libjfx*.so \
  && \
  
  # Install unifi
  curl -J -L -o /tmp/unifi.deb -L https://www.ubnt.com/downloads/unifi/${UNIFI_VER}/unifi_sysvinit_all.deb && \
  dpkg -i /tmp/unifi.deb && \
  
  # Cleanup
  apt-get clean && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/cache/oracle-jdk8-installer \
    /var/tmp/*
	
# add local files
COPY root/ /

# volumes and ports
WORKDIR /usr/lib/unifi
VOLUME /config
EXPOSE 3478/udp 6789/tcp 8080/tcp 8443/tcp 8843/tcp 8880/tcp 10001/udp