ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV HOME="/" \
    OS_NAME="linux" \
    OS_FLAVOUR="debian-13" \
    OS_NAME="linux" \
    MONGODB_VERSION="8.0.17" \
    MONGOSH_VERSION="2.5.0" \
    YQ_VERSION="4.50.1" \
    WAITFORPORT_VERSION="1.0.10" \
    RENDER_TEMPLATE_VERSION="1.0.9"  

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libbrotli1 libcom-err2 libcurl4t64 libffi8 libgcc-s1 libgmp10 libgnutls30t64 libgssapi-krb5-2 libhogweed6t64 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap2 liblzma5 libnettle8t64 libnghttp2-14 libp11-kit0 libpsl5t64 librtmp1 libsasl2-2 libssh2-1t64 libssl3t64 libtasn1-6 libunistring5 libzstd1 numactl procps zlib1g
RUN install-stack yq ${YQ_VERSION} && \
    install-stack wait-for-port ${WAITFORPORT_VERSION} && \
    install-stack render-template ${RENDER_TEMPLATE_VERSION} && \
    install-stack mongosh  ${MONGOSH_VERSION} && \
    install-stack mongodb ${MONGODB_VERSION}

RUN chmod g+rwX /opt/drycc
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true

COPY rootfs /
RUN . init-stack && /opt/drycc/scripts/mongodb/postunpack.sh
ENV APP_VERSION="8.0.17" \
    DRYCC_APP_NAME="mongodb" \
    PATH="/opt/drycc/mongosh/bin:/opt/drycc/yq/bin:/opt/drycc/wait-for-port/bin:/opt/drycc/render-template/bin:/opt/drycc/mongodb/bin:$PATH"

EXPOSE 27017

USER 1001
ENTRYPOINT ["/opt/drycc/scripts/mongodb/entrypoint.sh" ]
CMD [ "/opt/drycc/scripts/mongodb/run.sh" ]
