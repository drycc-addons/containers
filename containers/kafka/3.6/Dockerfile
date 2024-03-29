ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV JAVA_VERSION="17.0.10" \
  WAIT_FOR_PORT_VERSION="1.0.7" \
  RENDER_TEMPLATE_VERSION="1.0.6" \
  KAFKA_VERSION="3.6.1"

ARG JAVA_EXTRA_SECURITY_DIR="/drycc/java/extra-security"

COPY prebuildfs /

RUN install-packages libnss-wrapper procps zlib1g \
  && install-stack java $JAVA_VERSION \
  && install-stack wait-for-port $WAIT_FOR_PORT_VERSION \
  && install-stack render-template $RENDER_TEMPLATE_VERSION \
  && install-stack kafka $KAFKA_VERSION \
  && echo "export NSS_WRAPPER_LIB=/usr/lib/`echo $(uname -m)`-linux-gnu/libnss_wrapper.so" >> /opt/drycc/kafka/profile.d/kafka.sh \
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
  && ln -s /opt/drycc/scripts/kafka/entrypoint.sh /entrypoint.sh \
  && ln -s /opt/drycc/scripts/kafka/run.sh /run.sh

COPY rootfs /
RUN /opt/drycc/scripts/java/postunpack.sh
RUN /opt/drycc/scripts/kafka/postunpack.sh

EXPOSE 9092

USER 1001
ENTRYPOINT [ "init-stack", "/opt/drycc/scripts/kafka/entrypoint.sh" ]
CMD [ "/opt/drycc/scripts/kafka/run.sh" ]
