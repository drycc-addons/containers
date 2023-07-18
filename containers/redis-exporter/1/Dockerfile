ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV REDIS_EXPORTER_VERSION="1.51.0"

RUN install-packages libnss-wrapper \
    && install-stack redis_exporter $REDIS_EXPORTER_VERSION \
    && echo "export NSS_WRAPPER_LIB=/usr/lib/`echo $(uname -m)`-linux-gnu/libnss_wrapper.so" >> /opt/drycc/redis_exporter/profile.d/redis_exporter.sh \
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

EXPOSE 9187

USER 1001
ENTRYPOINT [ "init-stack", "redis_exporter" ]
