ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV GOSU_VERSION="1.16" \
  POSTGRESQL_VERSION="15.3" \
  POSTGRESQL_BASE_DIR="/opt/drycc/postgresql/15"

COPY prebuildfs /

RUN install-packages libnss-wrapper \
  && install-stack gosu $GOSU_VERSION \
  && install-stack postgresql $POSTGRESQL_VERSION \
  && echo "export NSS_WRAPPER_LIB=/usr/lib/`echo $(uname -m)`-linux-gnu/libnss_wrapper.so" >> /opt/drycc/postgresql/profile.d/postgresql.sh \
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
RUN /opt/drycc/scripts/postgresql/postunpack.sh

VOLUME [ "/drycc/postgresql", "/docker-entrypoint-initdb.d", "/docker-entrypoint-preinitdb.d" ]

EXPOSE 5432
USER 1001
ENTRYPOINT [ "init-stack", "/opt/drycc/scripts/postgresql/entrypoint.sh" ]
CMD [ "/opt/drycc/scripts/postgresql/run.sh" ]
