FROM openshift/base-centos7
MAINTAINER tob@butter.sh

# Install system utils & Gogs runtime dependencies
RUN yum install -y --setopt=tsflags=nodocs autossh nss_wrapper \
 && mkdir -p /conf /opt/app-root/etc /opt/app-root/src \
 && chmod 0777 /conf /opt/app-root/etc /opt/app-root/src

ADD start.sh /

USER 1000

# Configure Docker Container
VOLUME ["/secrets"]
ENTRYPOINT ["/start.sh"]
