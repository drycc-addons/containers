ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV PATH="/opt/drycc/prometheus/bin:$PATH" \
    PROMETHEUS_VERSION="2.47.0"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install-packages  ca-certificates curl procps
RUN install-stack prometheus $PROMETHEUS_VERSION 

COPY config  /opt/drycc/prometheus/
RUN mkdir /etc/prometheus && \
    ln -sf /opt/drycc/prometheus/conf /etc/prometheus && \
    chmod g+rwX /opt/drycc
 
RUN chown -R 1001:1001 /opt/drycc/prometheus && mkdir -p /opt/drycc/prometheus/data/ && chmod g+rwX /opt/drycc/prometheus/data/

EXPOSE 9090

WORKDIR /opt/drycc/prometheus
USER 1001
ENTRYPOINT [ "/opt/drycc/prometheus/bin/prometheus" ]
CMD [ "--config.file=/opt/drycc/prometheus/conf/prometheus.yml", "--storage.tsdb.path=/opt/drycc/prometheus/data", "--web.console.libraries=/opt/drycc/prometheus/conf/console_libraries", "--web.console.templates=/opt/drycc/prometheus/conf/consoles" ]
