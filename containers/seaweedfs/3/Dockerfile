ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV DRYCC_UID=1001 \
  DRYCC_GID=1001 \
  DRYCC_HOME_DIR=/home/drycc \
  SEAWEEDFS_VERSION="3.58" \
  SEAWEEDFS_DATA_DIR=/drycc \
  SEAWEEDFS_CONF_DIR=/etc/seaweedfs

COPY prebuildfs /

RUN groupadd drycc --gid ${DRYCC_GID} \
  && useradd drycc -u ${DRYCC_UID} -g ${DRYCC_GID} -s /bin/bash -m -d ${DRYCC_HOME_DIR} \
  && install-stack seaweedfs $SEAWEEDFS_VERSION \
  && mkdir -p ${SEAWEEDFS_DATA_DIR} ${SEAWEEDFS_CONF_DIR} \
  && chown -hR ${DRYCC_UID}:${DRYCC_GID} ${SEAWEEDFS_CONF_DIR} \
  && chown -hR ${DRYCC_UID}:${DRYCC_GID} ${SEAWEEDFS_DATA_DIR}

USER ${DRYCC_UID}

COPY --chown=${DRYCC_UID}:${DRYCC_GID} rootfs /

ENTRYPOINT [ "init-stack", "/opt/drycc/scripts/seaweedfs/entrypoint.sh" ]
CMD [ "/opt/drycc/scripts/seaweedfs/run.sh" ]