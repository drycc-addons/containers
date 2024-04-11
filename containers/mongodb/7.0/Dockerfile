ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV HOME="/" \
    OS_NAME="linux" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux" \
    MONGODB_VERSION="7.0.8" \
    MONGOSH_VERSION="2.2.3" \
    YQ_VERSION="4.43.1" \
    WAITFORPORT_VERSION="1.0.7" \
    RENDER_TEMPLATE_VERSION="1.0.6"  
    
COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libbrotli1 libcom-err2 libcurl4 libffi8 libgcc-s1 libgmp10 libgnutls30 libgssapi-krb5-2 libhogweed6 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.5-0 liblzma5 libnettle8 libnghttp2-14 libp11-kit0 libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl3 libtasn1-6 libunistring2 libzstd1 numactl procps zlib1g
RUN install-stack yq ${YQ_VERSION} && \
    install-stack wait-for-port ${WAITFORPORT_VERSION} && \
    install-stack render-template ${RENDER_TEMPLATE_VERSION} && \
    install-stack mongosh  ${MONGOSH_VERSION} && \
    install-stack mongodb ${MONGODB_VERSION}

RUN chmod g+rwX /opt/drycc
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true

COPY rootfs /
RUN . init-stack && /opt/drycc/scripts/mongodb/postunpack.sh
ENV APP_VERSION="7.0.8" \
    BITNAMI_APP_NAME="mongodb" \
    PATH="/opt/drycc/common/bin:/opt/drycc/mongodb/bin:$PATH"

EXPOSE 27017

USER 1001
ENTRYPOINT [ "init-stack", "/opt/drycc/scripts/mongodb/entrypoint.sh" ]
CMD [ "/opt/drycc/scripts/mongodb/run.sh" ]
