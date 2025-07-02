# Copyright Drycc Community.
# SPDX-License-Identifier: APACHE-2.0

ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV HOME="/opt/drycc" \
  JQ_VERSION="1.7.1" \
  INI_FILE_VERSION="1.4.7" \
  AIRFLOW_VERSION="3.0.1" \
  WAIT_FOR_PORT_VERSION="1.0.8" \
  PYTHON_VERSION="3.12"

COPY prebuildfs /

RUN install-packages ca-certificates curl git krb5-user libbz2-1.0 libcom-err2 libcrypt1 libffi8 libgcc-s1 libgmp10 libgnutls30 libgss-dev libgssapi-krb5-2 libhogweed6 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5-dev libkrb5support0 libldap-2.5-0 liblzma5 libmariadb3 libncursesw6 libnettle8 libnsl2 libp11-kit0 libreadline8 libsasl2-2 libsasl2-modules libsqlite3-0 libssl3 libstdc++6 libtasn1-6 libtinfo6 libtirpc3 libudev1 libunistring2 locales netbase openssh-client procps tzdata zlib1g

RUN install-stack jq ${JQ_VERSION} && \
  install-stack python ${PYTHON_VERSION} && \
  install-stack ini-file ${INI_FILE_VERSION} && \
  install-stack wait-for-port $WAIT_FOR_PORT_VERSION

ENV AIRFLOW_HOME="/opt/drycc/airflow" \
  DRYCC_APP_NAME="airflow" \
  APP_VERSION="3.0.1" \
  NSS_WRAPPER_GROUP="/opt/drycc/airflow/nss-wrapper/nss_group" \
  NSS_WRAPPER_PASSWD="/opt/drycc/airflow/nss-wrapper/nss_passwd" \
  LNAME="airflow" \
  LIBNSS_WRAPPER_PATH="/usr/lib/$(uname -m)-linux-gnu/libnss_wrapper.so" \
  AIRFLOW_EXTRAS="postgres,celery,redis,statsd" \
  AIRFLOW_CONSTRAINTS_LOCATION="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"

RUN chmod g+rwX /opt/drycc 
RUN . init-stack && \
  python3 -m venv ${AIRFLOW_HOME}/venv && \
  echo "source /opt/drycc/airflow/venv/bin/activate" >> /opt/drycc/python/profile.d/python.sh && \
  source /opt/drycc/airflow/venv/bin/activate && \
  pip install apache-airflow[${AIRFLOW_EXTRAS}]==${AIRFLOW_VERSION} --constraint ${AIRFLOW_CONSTRAINTS_LOCATION} apache-airflow-providers-fab

RUN chown -R 1001:1001 /opt/drycc

COPY rootfs /
RUN /opt/drycc/scripts/airflow/postunpack.sh
RUN /opt/drycc/scripts/locales/add-extra-locales.sh


EXPOSE 8080 8125 8793 8794

USER 1001
ENTRYPOINT [ "init-stack",  "/opt/drycc/scripts/airflow/entrypoint.sh" ]
CMD [ "/opt/drycc/scripts/airflow/run.sh" ]

