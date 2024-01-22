# Copyright Drycc Community.
# SPDX-License-Identifier: APACHE-2.0

ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV FLINK_VERSION="1.18.1" \
  JAVA_VERSION="17.0.8"

COPY prebuildfs /

RUN install-packages acl gettext libjemalloc2 procps zlib1g \
  && install-stack flink $FLINK_VERSION \
  && install-stack java $JAVA_VERSION \
  && . init-stack \
  && rm -rf \
    /usr/share/doc \
    /usr/share/man \
    /usr/share/info \
    /usr/share/locale \
    /var/lib/apt/lists/* \
    /var/log/* \
    /var/cache/debconf/* \
    /etc/systemd \
    /lib/lsb \
    /lib/udev \
    /usr/lib/`echo $(uname -m)`-linux-gnu/gconv/IBM* \
    /usr/lib/`echo $(uname -m)`-linux-gnu/gconv/EBC* \
  && mkdir -p /usr/share/man/man{1..8}

RUN chmod g+rwX /opt/drycc
COPY rootfs /
RUN /opt/drycc/scripts/flink/postunpack.sh
RUN /opt/drycc/scripts/java/postunpack.sh

VOLUME [ "/docker-entrypoint-initdb.d", "/docker-entrypoint-preinitdb.d" ]

WORKDIR /opt/drycc/flink
USER 1001
ENTRYPOINT [ "init-stack", "/opt/drycc/scripts/flink/entrypoint.sh", "/opt/drycc/scripts/flink/run.sh" ]
