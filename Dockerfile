FROM alpine:3.2
MAINTAINER tob@butter.sh

# Install system utils & Gogs runtime dependencies
RUN echo "@edge http://dl-4.alpinelinux.org/alpine/edge/main" | tee -a /etc/apk/repositories \
 && echo "@testing http://dl-4.alpinelinux.org/alpine/edge/testing" | tee -a /etc/apk/repositories \
 && apk -U --no-progress upgrade \
 && apk -U --no-progress add autossh@testing \
 && mkdir /conf \
 && chmod 0777 /conf \
 && adduser ssh_user -Du 1000 -h /home/ssh_user \
 && mkdir -p /home/ssh_user/.ssh

ADD start.sh /

USER 1000

# Configure Docker Container
VOLUME ["/secrets"]
ENTRYPOINT ["/start.sh"]
CMD ["/usr/bin/autossh", "-i /secrets/ssh-privkey"]
