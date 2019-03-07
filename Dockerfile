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

############
# bcit/entropybroker

FROM bcit/centos:7

RUN yum --setopt tsflags=nodocs --setopt timeout=5 -y install \
    cryptopp \
    gd \
    gnu-free-mono-fonts \
    libpng \
    zlib

RUN mkdir /usr/share/fonts/truetype \
 && ln -s ../gnu-free /usr/share/fonts/truetype/freefont

COPY --from=builder /usr/local/entropybroker /usr/local/entropybroker

CMD ["/usr/local/entropybroker/bin/entropy_broker", "-n"]
