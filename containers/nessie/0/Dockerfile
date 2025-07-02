ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV NESSIE_VERSION="0.104.2" \
  JAVA_VERSION="21.0.6"

COPY prebuildfs /

RUN install-packages libnss-wrapper procps net-tools zlib1g \
  && install-stack nessie $NESSIE_VERSION \
  && install-stack java $JAVA_VERSION \
  && ln -s /opt/drycc/nessie/nessie-quarkus-${NESSIE_VERSION}-runner.jar /opt/drycc/nessie/app.jar
  
COPY rootfs /
RUN /opt/drycc/scripts/java/postunpack.sh

ENV NSS_WRAPPER_GROUP="/opt/drycc/nessie/tmp/nss_group" \
  NSS_WRAPPER_PASSWD="/opt/drycc/nessie/tmp/nss_passwd" \
  NESSIE_HOME="/opt/drycc/nessie" \
  NESSIE_USER="nessie"

WORKDIR /opt/drycc/nessie
USER 1001

ENTRYPOINT [ "init-stack", "java" ]
CMD ["-jar", "/opt/drycc/nessie/app.jar"]

