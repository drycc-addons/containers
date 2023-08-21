ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV GOSU_VERSION="1.16" \
  ERLANG_VERSION="26.0.2" \
  RABBITMQ_VERSION="3.12.3"

COPY prebuildfs /

RUN install-packages libnss-wrapper \
  && install-stack erlang $ERLANG_VERSION \
  && install-stack rabbitmq $RABBITMQ_VERSION \
  && echo "export NSS_WRAPPER_LIB=/usr/lib/`echo $(uname -m)`-linux-gnu/libnss_wrapper.so" >> /opt/drycc/rabbitmq/profile.d/rabbitmq.sh \
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

COPY rootfs /
RUN /opt/drycc/scripts/rabbitmq/postunpack.sh

VOLUME [ "/docker-entrypoint-initdb.d", "/docker-entrypoint-preinitdb.d" ]

EXPOSE 4369 5551 5552 5671 5672 15671 15672 25672

USER 1001
ENTRYPOINT [ "/opt/drycc/scripts/rabbitmq/entrypoint.sh" ]
CMD [ "/opt/drycc/scripts/rabbitmq/run.sh" ]

