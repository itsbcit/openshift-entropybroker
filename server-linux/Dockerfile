############
# builder stage
FROM centos:7 as builder

RUN yum --setopt tsflags=nodocs --setopt timeout=5 -y install epel-release \
 && yum --setopt tsflags=nodocs --setopt timeout=5 -y install \
    cryptopp-devel \
    gcc-c++ \
    gd-devel \
    libpng-devel \
    make \
    gcc \
    pkgconfig \
    zlib-devel

ADD https://www.vanheusden.com/entropybroker/eb-2.9.tgz /tmp/
WORKDIR /tmp/builder
RUN tar zxvf /tmp/eb-2.9.tgz
WORKDIR /tmp/builder/eb-2.9
RUN ./configure \
 && make \
        entropy_broker \
        eb_client_kernel_generic \
        eb_server_linux_kernel \
 && make install

RUN cp auth.txt /usr/local/entropybroker/etc/auth.txt

FROM bcit/centos:7
LABEL maintainer="jesse@weisner.ca"
LABEL build_id="1567140093"
ENV RUNUSER entropybroker
ENV BROKER_HOST entropybroker
ENV BROKER_PORT 55225
ENV SERVER_USERFILE /usr/local/entropybroker/etc/auth.txt
ENV SERVER_USERNAME none
ENV SERVER_PASSWORD none
ENV LOG_LEVEL 10

RUN yum --setopt tsflags=nodocs --setopt timeout=5 -y install \
    cryptopp \
    zlib

RUN mkdir -p \
    /usr/local/entropybroker \
    /usr/local/entropybroker/bin \
    /usr/local/entropybroker/etc-dist

COPY --from=builder /usr/local/entropybroker/bin/eb_server_linux_kernel /usr/local/entropybroker/bin/eb_server_linux_kernel
COPY --from=builder /usr/local/entropybroker/etc/auth.txt /usr/local/entropybroker/etc-dist/auth.txt

COPY 90-entropybroker-vardir.sh /docker-entrypoint.d/90-entropybroker-vardir.sh
COPY 90-entropyserver-auth.sh /docker-entrypoint.d/90-entropyserver-auth.sh

RUN mkdir /usr/local/entropybroker/etc /usr/local/entropybroker/var \
 && chown 0:0 /usr/local/entropybroker/etc /usr/local/entropybroker/var \
 && chmod 0770 /usr/local/entropybroker/etc /usr/local/entropybroker/var \
 && chmod 0664 /usr/local/entropybroker/etc-dist/*

VOLUME /usr/local/entropybroker/etc
VOLUME /usr/local/entropybroker/var

CMD ["sh", "-c", "/usr/local/entropybroker/bin/eb_server_linux_kernel -I ${BROKER_HOST}:${BROKER_PORT} -X ${SERVER_USERFILE} -n"]
