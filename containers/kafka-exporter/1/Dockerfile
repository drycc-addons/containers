ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV KAFKA_EXPORTER_VERSION="1.7.0"

RUN install-stack kafka_exporter $KAFKA_EXPORTER_VERSION \
    && . init-stack \
    && rm -rf \
    /usr/share/doc \
    /usr/share/man \
    /usr/share/info \
    /usr/share/locale \
    /var/lib/apt/lists/* \
    /var/log/* \
    /var/cache/debconf/* \
    /etc/systemd \
    /lib/lsb \
    /lib/udev \
    /usr/lib/`echo $(uname -m)`-linux-gnu/gconv/IBM* \
    /usr/lib/`echo $(uname -m)`-linux-gnu/gconv/EBC* \
    && mkdir -p /usr/share/man/man{1..8}

EXPOSE 9308

USER 1001
WORKDIR /opt/drycc/kafka_exporter
ENTRYPOINT [ "init-stack", "kafka_exporter" ]
