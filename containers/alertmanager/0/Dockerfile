ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV HOME="/" \
    OS_ARCH="${CODENAME:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux" \
    ALERTMANAGER_VERSION="0.26.0"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install-packages ca-certificates curl procps
RUN install-stack alertmanager ${ALERTMANAGER_VERSION}



RUN apt-get autoremove --purge -y curl && \
    apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives


RUN mkdir /etc/alertmanager && \
    ln -sf /opt/drycc/alertmanager/conf /etc/alertmanager

COPY config  /opt/drycc/alertmanager/

RUN mkdir -p /opt/drycc/alertmanager/data/ && chmod g+rwX /opt/drycc/alertmanager/data/

RUN chmod g+rwX /opt/drycc

ENV APP_VERSION="0.25.0" \
    BITNAMI_APP_NAME="alertmanager" \
    PATH="/opt/drycc/alertmanager/bin:$PATH"

EXPOSE 9093

WORKDIR /opt/drycc/alertmanager
USER 1001
ENTRYPOINT [ "/opt/drycc/alertmanager/bin/alertmanager" ]
CMD [ "--config.file=/opt/drycc/alertmanager/conf/config.yml", "--storage.path=/opt/drycc/alertmanager/data" ]
