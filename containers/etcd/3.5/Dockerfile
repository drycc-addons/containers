ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV DRYCC_UID=1001 \
  DRYCC_GID=1001 \
  ETCD_VERSION=3.5.13 \
  DRYCC_APP_NAME=etcd

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]

RUN mkdir -p /drycc/etcd \
  && install-packages procps \
  && install-stack etcd ${ETCD_VERSION} \
  && chown -R ${DRYCC_UID}:${DRYCC_GID} /opt/drycc/etcd /drycc/etcd

ADD rootfs /
USER ${DRYCC_UID}

EXPOSE 2379 2380

WORKDIR /opt/drycc/etcd
ENTRYPOINT [ "/opt/drycc/scripts/etcd/entrypoint.sh" ]
CMD [ "/opt/drycc/scripts/etcd/run.sh" ]
