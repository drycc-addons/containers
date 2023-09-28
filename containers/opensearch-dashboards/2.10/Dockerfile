ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV YQ_VERSION="4.35.1" \
  OPENSEARCH_DASHBOARDS_VERSION="2.10.0"

COPY prebuildfs /

RUN install-packages libnss-wrapper procps \
  && install-stack yq ${YQ_VERSION} \
  && install-stack opensearch-dashboards ${OPENSEARCH_DASHBOARDS_VERSION} \
  && echo "export NSS_WRAPPER_LIB=/usr/lib/`echo $(uname -m)`-linux-gnu/libnss_wrapper.so" >> /opt/drycc/opensearch-dashboards/profile.d/opensearch-dashboards.sh \
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
RUN . init-stack \
  && /opt/drycc/scripts/opensearch-dashboards/postunpack.sh

EXPOSE 5601

USER 1001
ENTRYPOINT [ "init-stack", "/opt/drycc/scripts/opensearch-dashboards/entrypoint.sh" ]
CMD [ "/opt/drycc/scripts/opensearch-dashboards/run.sh" ]
