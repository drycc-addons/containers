ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV DRYCC_APP_NAME= \
    PATH="/opt/drycc/grafana/bin:$PATH" \
    GRAFANA_VERSION="10.4.2"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install-packages ca-certificates curl libfontconfig procps
RUN install-stack grafana $GRAFANA_VERSION
RUN chmod g+rwX /opt/drycc

COPY rootfs /
RUN /opt/drycc/scripts/grafana/postunpack.sh

EXPOSE 3000

WORKDIR /opt/drycc/grafana
USER 1001
ENTRYPOINT [ "/opt/drycc/scripts/grafana/entrypoint.sh" ]
CMD [ "/opt/drycc/scripts/grafana/run.sh" ]
