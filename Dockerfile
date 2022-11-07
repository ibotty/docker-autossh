FROM quay.io/centos/centos:stream9
MAINTAINER tob@butter.sh

# Install system utils & Gogs runtime dependencies
RUN dnf install -y epel-release \
 && dnf install -y autossh nss_wrapper-libs \
 && dnf clean all \
 && mkdir -p /conf /opt/app-root/etc /opt/app-root/src \
 && chmod 0777 /conf /opt/app-root/etc /opt/app-root/src

ADD start.sh /

USER 1000

# Configure Docker Container
VOLUME ["/secrets"]
ENTRYPOINT ["/start.sh"]
