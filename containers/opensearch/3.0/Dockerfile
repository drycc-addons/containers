ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV YQ_VERSION="4.45.4" \
  JAVA_VERSION="21.0.7" \
  WAIT_FOR_PORT_VERSION="1.0.8" \
  OPENSEARCH_VERSION="3.0.0"

COPY prebuildfs /

RUN install-packages ca-certificates curl libgcc-s1 libgomp1 libstdc++6 procps zlib1g \
  && install-stack yq ${YQ_VERSION} \
  && install-stack java ${JAVA_VERSION} \
  && install-stack wait-for-port $WAIT_FOR_PORT_VERSION \
  && install-stack opensearch ${OPENSEARCH_VERSION} \
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
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true

COPY rootfs /
RUN /opt/drycc/scripts/opensearch/postunpack.sh
RUN /opt/drycc/scripts/java/postunpack.sh

EXPOSE 9200 9300

USER 1001
ENTRYPOINT [ "init-stack", "/opt/drycc/scripts/opensearch/entrypoint.sh" ]
CMD [ "/opt/drycc/scripts/opensearch/run.sh" ]
