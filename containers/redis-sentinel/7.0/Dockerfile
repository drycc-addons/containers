ARG CODENAME
FROM registry.drycc.cc/drycc/go-dev as BUILD

ADD redis-sentinel-proxy /redis-sentinel-proxy

RUN cd /redis-sentinel-proxy; \
  . init-stack; \
  go mod vendor; \
  go build main.go


FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV GOSU_VERSION="1.16" \
    REDIS_SENTINEL_VERSION="7.0.12"

COPY prebuildfs /

RUN install-packages libnss-wrapper \
    && install-stack gosu $GOSU_VERSION \
    && install-stack redis-sentinel $REDIS_SENTINEL_VERSION \
    && echo "export NSS_WRAPPER_LIB=/usr/lib/`echo $(uname -m)`-linux-gnu/libnss_wrapper.so" >> /opt/drycc/redis-sentinel/profile.d/redis-sentinel.sh \
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

COPY rootfs /
COPY --from=BUILD /redis-sentinel-proxy/main /opt/drycc/redis-sentinel/bin/redis-sentinel-proxy
RUN /opt/drycc/scripts/redis-sentinel/postunpack.sh

EXPOSE 26379

USER 1001
ENTRYPOINT [ "init-stack", "/opt/drycc/scripts/redis-sentinel/entrypoint.sh" ]
CMD [ "/opt/drycc/scripts/redis-sentinel/run.sh" ]
