# Copyright Drycc Community.
# SPDX-License-Identifier: APACHE-2.0

ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV APOLLO_VERSION="2.3.0" \
  JAVA_VERSION="21.0.5" \
  APOLLO_RUN_MODE="Docker" \
  SERVER_PORT=8090

COPY prebuildfs /

RUN install-packages procps curl bash tzdata \
  && install-stack apollo-adminservice $APOLLO_VERSION \
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

WORKDIR /opt/drycc/apollo-adminservice

COPY rootfs /
RUN /opt/drycc/scripts/apollo-adminservice/postunpack.sh

EXPOSE $SERVER_PORT

USER 1001
ENTRYPOINT [ "init-stack", "/opt/drycc/scripts/apollo-adminservice/entrypoint.sh" ]
CMD [ "/opt/drycc/scripts/apollo-adminservice/run.sh" ]
