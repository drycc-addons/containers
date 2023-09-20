ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV YQ_VERSION="4.35.1" \
  JAVA_VERSION="17.0.8" \
  OPENSEARCH_VERSION="2.9.0"

COPY prebuildfs /

RUN install-packages libnss-wrapper procps zlib1g \
  && install-stack yq ${YQ_VERSION} \
  && install-stack java ${JAVA_VERSION} \
  && install-stack opensearch ${OPENSEARCH_VERSION} \
  && echo "export NSS_WRAPPER_LIB=/usr/lib/`echo $(uname -m)`-linux-gnu/libnss_wrapper.so" >> /opt/drycc/opensearch/profile.d/opensearch.sh \
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
RUN /opt/drycc/scripts/opensearch/postunpack.sh
RUN /opt/drycc/scripts/java/postunpack.sh

EXPOSE 9200 9300

USER 1001
ENTRYPOINT [ "init-stack", "/opt/drycc/scripts/opensearch/entrypoint.sh" ]
CMD [ "/opt/drycc/scripts/opensearch/run.sh" ]
