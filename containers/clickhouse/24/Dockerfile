ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV HOME="/" \
    OS_NAME="linux" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux" \
    CLICKHOUSE_VERSION="24.3.2.23" \
    OS_ARCH="${TARGETARCH:-amd64}" 

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl procps xmlstarlet
RUN install-stack clickhouse ${CLICKHOUSE_VERSION}
RUN chmod g+rwX /opt/drycc
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true
ENV APP_VERSION="24.3.2" \
    DRYCC_APP_NAME="clickhouse" \
    PATH="/opt/drycc/clickhouse/bin:/opt/drycc/common/bin:$PATH" \
    clickhouseCTL_API="3"
    
COPY rootfs /
RUN /opt/drycc/scripts/clickhouse/postunpack.sh

    

EXPOSE 8123 9000 9004 9005 9009

USER 1001
ENTRYPOINT [ "/opt/drycc/scripts/clickhouse/entrypoint.sh" ]
CMD [ "/opt/drycc/scripts/clickhouse/run.sh", "--", "--listen_host=0.0.0.0" ]
