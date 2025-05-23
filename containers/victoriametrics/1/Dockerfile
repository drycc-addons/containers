ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV PATH="/opt/drycc/victoriametrics/bin:$PATH" \
    VICTORIAMETRICS_VERSION="1.116.0"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install-packages ca-certificates procps
RUN install-stack victoriametrics $VICTORIAMETRICS_VERSION 

RUN mkdir /etc/victoriametrics && \
    ln -sf /opt/drycc/victoriametrics/config /etc/victoriametrics && \
    chmod g+rwX /opt/drycc
 
RUN chown -R 1001:1001 /opt/drycc/victoriametrics && mkdir -p /opt/drycc/victoriametrics/data/ && chmod g+rwX /opt/drycc/victoriametrics/data/

WORKDIR /opt/drycc/victoriametrics
USER 1001
