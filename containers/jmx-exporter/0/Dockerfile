ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV JAVA_VERSION="17" \
  JMX_EXPORTER_VERSION="0.19.0"

RUN install-packages libnss-wrapper \
  && install-stack java $JAVA_VERSION \
  && install-stack jmx_exporter $JMX_EXPORTER_VERSION \
  && echo "export NSS_WRAPPER_LIB=/usr/lib/`echo $(uname -m)`-linux-gnu/libnss_wrapper.so" >> /opt/drycc/jmx_exporter/profile.d/jmx_exporter.sh \
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
  && chown -R 1001:1001 /opt/drycc/jmx_exporter
EXPOSE 5556

WORKDIR /opt/drycc/jmx_exporter
USER 1001
ENTRYPOINT [ "init-stack", "java", "-jar", "jmx_prometheus_httpserver.jar" ]
CMD [ "5556", "example_configs/httpserver_sample_config.yml" ]
