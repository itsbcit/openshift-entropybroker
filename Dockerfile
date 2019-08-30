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
LABEL build_id="1567139740"
ENV RUNUSER entropybroker
ENV BROKER_CONFIG   /usr/local/entropybroker/etc/entropy_broker.conf
ENV BROKER_USERFILE /usr/local/entropybroker/etc/users.txt
ENV LOG_LEVEL 10

RUN yum --setopt tsflags=nodocs --setopt timeout=5 -y install \
    cryptopp \
    gd \
    gnu-free-mono-fonts \
    libpng \
    zlib

RUN mkdir /usr/share/fonts/truetype \
 && ln -s ../gnu-free /usr/share/fonts/truetype/freefont

COPY --from=builder /usr/local/entropybroker /usr/local/entropybroker

COPY 90-entropybroker-secrets.sh /docker-entrypoint.d/90-entropybroker-secrets.sh
COPY 90-entropybroker-vardir.sh /docker-entrypoint.d/90-entropybroker-vardir.sh

RUN mv /usr/local/entropybroker/etc /usr/local/entropybroker/etc-dist

RUN rm -rf /usr/local/entropybroker/var

RUN mkdir \
    /usr/local/entropybroker/etc \
    /usr/local/entropybroker/var

RUN chown 0:0 \
    /usr/local/entropybroker/etc \
    /usr/local/entropybroker/var

RUN chmod 0770 \
    /usr/local/entropybroker/etc \
    /usr/local/entropybroker/var

RUN chmod 0664 \
    /usr/local/entropybroker/etc-dist/*

VOLUME /usr/local/entropybroker/etc
VOLUME /usr/local/entropybroker/var

EXPOSE 55225
EXPOSE 48923

CMD ["/usr/local/entropybroker/bin/entropy_broker", "-n"]
