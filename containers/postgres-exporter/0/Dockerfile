ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV POSTGRES_EXPORTER_VERSION="0.15.0"

RUN install-packages libnss-wrapper \
    && install-stack postgres_exporter $POSTGRES_EXPORTER_VERSION \
    && echo "export NSS_WRAPPER_LIB=/usr/lib/`echo $(uname -m)`-linux-gnu/libnss_wrapper.so" >> /opt/drycc/postgres_exporter/profile.d/postgres_exporter.sh \
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
ENTRYPOINT [ "init-stack", "postgres_exporter" ]
