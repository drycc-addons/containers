ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV SPARK_VERSION="3.5.0" \
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
ENV NSS_WRAPPER_GROUP="/opt/drycc/spark/tmp/nss_group" \
  NSS_WRAPPER_PASSWD="/opt/drycc/spark/tmp/nss_passwd" \
  PYTHONPATH="/opt/drycc/spark/python/:$PYTHONPATH" \
  SPARK_HOME="/opt/drycc/spark" \
  SPARK_USER="spark"

WORKDIR /opt/drycc/spark
USER 1001
ENTRYPOINT [ "init-stack", "/opt/drycc/scripts/spark/entrypoint.sh" ]
CMD [ "/opt/drycc/scripts/spark/run.sh" ]
