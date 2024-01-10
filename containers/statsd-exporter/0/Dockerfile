ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV STATSD_EXPORTER="0.26.0"

RUN install-stack statsd_exporter ${STATSD_EXPORTER} \
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

EXPOSE 9104

USER 1001
ENTRYPOINT [ "init-stack", "statsd_exporter" ]
