ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV ALERTMANAGER_VERSION="0.26.0" \
    PATH="/opt/drycc/alertmanager/bin:$PATH"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install-packages ca-certificates curl procps
RUN install-stack alertmanager ${ALERTMANAGER_VERSION}

RUN mkdir /etc/alertmanager && \
    ln -sf /opt/drycc/alertmanager/conf /etc/alertmanager

COPY config  /opt/drycc/alertmanager/

RUN mkdir -p /opt/drycc/alertmanager/data/ && chmod g+rwX /opt/drycc/alertmanager/data/ && chmod g+rwX /opt/drycc

EXPOSE 9093

WORKDIR /opt/drycc/alertmanager
USER 1001
ENTRYPOINT [ "/opt/drycc/alertmanager/bin/alertmanager" ]
CMD [ "--config.file=/opt/drycc/alertmanager/conf/config.yml", "--storage.path=/opt/drycc/alertmanager/data" ]
