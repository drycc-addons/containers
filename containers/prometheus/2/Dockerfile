ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV HOME="/" \
    OS_ARCH="${CODENAME:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux" \
    PROMETHEUS_VERSION="2.47.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install-packages  ca-certificates curl procps

RUN install-stack prometheus $PROMETHEUS_VERSION 

COPY config  /opt/drycc/prometheus/
RUN mkdir /etc/prometheus && \
    ln -sf /opt/drycc/prometheus/conf /etc/prometheus

RUN apt-get autoremove --purge -y curl && \
     apt-get update && apt-get upgrade -y && \
     apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/drycc

RUN chown -R 1001:1001 /opt/drycc/prometheus

RUN mkdir -p /opt/drycc/prometheus/data/ && chmod g+rwX /opt/drycc/prometheus/data/
ENV APP_VERSION="2.47.0" \
    DRYCC_APP_NAME="prometheus" \
    PATH="/opt/drycc/prometheus/bin:$PATH"

EXPOSE 9090

WORKDIR /opt/drycc/prometheus
USER 1001
ENTRYPOINT [ "/opt/drycc/prometheus/bin/prometheus" ]
CMD [ "--config.file=/opt/drycc/prometheus/conf/prometheus.yml", "--storage.tsdb.path=/opt/drycc/prometheus/data", "--web.console.libraries=/opt/drycc/prometheus/conf/console_libraries", "--web.console.templates=/opt/drycc/prometheus/conf/consoles" ]
