ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV DRYCC_UID=1001 \
  DRYCC_GID=1001 \
  YQ_VERSION=4.35.1 \
  KVROCKS_VERSION=2.8.0 \
  KVROCKS_EXPORTER_VERSION=1.0.1 \
  REDIS_CLUSTER_PROXY_VERSION=1.0.1 \
  DRYCC_APP_NAME=kvrocks

COPY prebuildfs /

RUN  install-stack kvrocks ${KVROCKS_VERSION} \
  && install-stack kvrocks_exporter ${KVROCKS_EXPORTER_VERSION} \
  && install-stack redis-cluster-proxy $REDIS_CLUSTER_PROXY_VERSION \
  && install-stack yq ${YQ_VERSION} \
  && mkdir -p /drycc/kvrocks /opt/drycc/kvrocks/tmp \
  && chown -R ${DRYCC_UID}:${DRYCC_GID} /opt/drycc/kvrocks /drycc/kvrocks

ADD rootfs /
RUN /opt/drycc/scripts/kvrocks/postunpack.sh
USER ${DRYCC_UID}

EXPOSE 2379 2380

WORKDIR /opt/drycc/kvrocks
ENTRYPOINT [ "init-stack", "/opt/drycc/scripts/kvrocks/entrypoint.sh" ]
CMD [ "/opt/drycc/scripts/kvrocks/run.sh" ]
