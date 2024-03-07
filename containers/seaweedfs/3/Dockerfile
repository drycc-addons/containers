ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV JQ_VERSION="1.7" \
  SEAWEEDFS_VERSION="3.63" \
  SEAWEEDFS_DATA_DIR=/seaweedfs \
  SEAWEEDFS_CONF_DIR=/etc/seaweedfs

COPY prebuildfs /

RUN install-stack jq $JQ_VERSION \
  && install-stack seaweedfs $SEAWEEDFS_VERSION \
  && mkdir -p ${SEAWEEDFS_DATA_DIR} ${SEAWEEDFS_CONF_DIR} \
  && chown -hR 1001:1001 ${SEAWEEDFS_CONF_DIR} \
  && chown -hR 1001:1001 ${SEAWEEDFS_DATA_DIR}

COPY rootfs /

USER 1001

ENTRYPOINT [ "init-stack", "/opt/drycc/scripts/seaweedfs/entrypoint.sh" ]
CMD [ "/opt/drycc/scripts/seaweedfs/run.sh" ]
