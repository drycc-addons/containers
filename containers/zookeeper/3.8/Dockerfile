ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV JAVA_VERSION="17" \
    GOSU_VERSION="1.16" \
    WAIT_FOR_PORT_VERSION="1.0.6" \
    RENDER_TEMPLATE_VERSION="1.0.3" \
    NETCAT_VERSION="0.7.1" \
    ZOOKEEPER_VERSION="3.8.2"

ARG JAVA_EXTRA_SECURITY_DIR="/drycc/java/extra-security"

COPY prebuildfs /

RUN install-packages libnss-wrapper psmisc procps xmlstarlet zlib1g \
  && install-stack java $JAVA_VERSION \
  && install-stack gosu $GOSU_VERSION \
  && install-stack wait-for-port $WAIT_FOR_PORT_VERSION \
  && install-stack netcat $NETCAT_VERSION \
  && install-stack zookeeper $ZOOKEEPER_VERSION \
  && echo "export NSS_WRAPPER_LIB=/usr/lib/`echo $(uname -m)`-linux-gnu/libnss_wrapper.so" >> /opt/drycc/zookeeper/profile.d/zookeeper.sh \
  && mkdir -p $JAVA_EXTRA_SECURITY_DIR \
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
  && mkdir -p /usr/share/man/man{1..8} \
  && chmod g+rwX /opt/drycc \
  && ln -s /opt/drycc/scripts/zookeeper/entrypoint.sh /entrypoint.sh \
  && ln -s /opt/drycc/scripts/zookeeper/run.sh /run.sh

COPY rootfs /
RUN /opt/drycc/scripts/zookeeper/postunpack.sh

EXPOSE 2181 2888 3888 8080

USER 1001
ENTRYPOINT [ "init-stack", "/opt/drycc/scripts/zookeeper/entrypoint.sh" ]
CMD [ "/opt/drycc/scripts/zookeeper/run.sh" ]
