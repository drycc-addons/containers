ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV YQ_VERSION="4.45.4" \
  OPENSEARCH_DASHBOARDS_VERSION="3.0.0"

COPY prebuildfs /

RUN install-packages ca-certificates curl libgcc-s1 libstdc++6 procps \
  && install-stack yq ${YQ_VERSION} \
  && install-stack opensearch-dashboards ${OPENSEARCH_DASHBOARDS_VERSION} \
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
RUN . init-stack \
  && /opt/drycc/scripts/opensearch-dashboards/postunpack.sh

EXPOSE 5601

USER 1001
ENTRYPOINT [ "init-stack", "/opt/drycc/scripts/opensearch-dashboards/entrypoint.sh" ]
CMD [ "/opt/drycc/scripts/opensearch-dashboards/run.sh" ]
