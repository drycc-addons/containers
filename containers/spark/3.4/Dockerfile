ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV SPARK_VERSION="3.4.1" \
  PYTHON_VERSION="3.11.4" \
  JAVA_VERSION="17.0.8"

COPY prebuildfs /

RUN install-packages libnss-wrapper procps net-tools zlib1g \
  && install-stack spark $SPARK_VERSION \
  && install-stack python $PYTHON_VERSION \
  && install-stack java $JAVA_VERSION \
  && echo "export NSS_WRAPPER_LIB=/usr/lib/`echo $(uname -m)`-linux-gnu/libnss_wrapper.so" >> /opt/drycc/spark/profile.d/spark.sh \
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
RUN /opt/drycc/scripts/spark/postunpack.sh
RUN /opt/drycc/scripts/java/postunpack.sh

VOLUME [ "/docker-entrypoint-initdb.d", "/docker-entrypoint-preinitdb.d" ]

USER 1001
ENTRYPOINT [ "init-stack", "/opt/drycc/scripts/spark/entrypoint.sh" ]
CMD [ "/opt/drycc/scripts/spark/run.sh" ]
