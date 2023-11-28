ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV DRYCC_UID=1001 \
    DRYCC_GID=1001 \
    JAVA_VERSION="17.0.9" \
    CLOUDBEAVER_VERSION="23_2_5" 

RUN install-stack java ${JAVA_VERSION}
RUN install-stack cloudbeaver ${CLOUDBEAVER_VERSION} 
RUN  chown -R ${DRYCC_UID}:${DRYCC_GID} /opt/drycc/cloudbeaver/
WORKDIR "/opt/drycc/cloudbeaver/"
USER ${DRYCC_UID}
ENTRYPOINT ["init-stack","./run-server.sh"]