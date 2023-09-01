ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV DRYCC_UID=1001 \
  DRYCC_GID=1001 \
  FLUENT_BIT_VERSION=2.1.8

RUN install-stack fluent-bit ${FLUENT_BIT_VERSION} \
  && chown -R ${DRYCC_UID}:${DRYCC_GID} /opt/drycc/fluent-bit

ADD rootfs /
USER ${DRYCC_UID}

CMD ["/usr/local/bin/boot"]