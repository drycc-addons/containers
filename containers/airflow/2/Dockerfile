# Copyright Drycc Community.
# SPDX-License-Identifier: APACHE-2.0

ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV HOME="/opt/drycc" \
  JQ_VERSION="1.7.1" \
  INI_FILE_VERSION="1.4.6" \
  AIRFLOW_VERSION="2.8.0" \
  PYTHON_VERSION="3.11"

COPY prebuildfs /
# SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install-packages libnss-wrapper postgresql-client krb5-user libbsd0 libbz2-1.0 libcdt5 libcgraph6 libcom-err2 libcrypt1 libedit2 \
  libexpat1 libffi8 libgcc-s1 libgmp10 libgnutls30 libgss-dev libgssapi-krb5-2 libgvc6 libhogweed6 libicu72 libidn2-0 libk5crypto3 \
  libkeyutils1 libkrb5-3 libkrb5-dev libkrb5support0 libldap-common libltdl7 liblz4-1 liblzma5 libmariadb3 libmd0 libncursesw6 libnettle8 \
  libnsl2 libp11-kit0 libpathplan4 libreadline8 libsasl2-2 libsasl2-modules libsqlite3-0 libssl3 libstdc++6 libsybdb5 libtasn1-6 libtinfo6 \
  libtirpc3 libunistring2 libuuid1 libxml2 libxmlsec1 libxmlsec1-openssl libxslt1.1 locales netbase procps tzdata zlib1g gcc

RUN install-stack jq ${JQ_VERSION} && \
  install-stack python ${PYTHON_VERSION} && \
  install-stack ini-file ${INI_FILE_VERSION}

ENV AIRFLOW_HOME="/opt/drycc/airflow" \
  DRYCC_APP_NAME="airflow" \
  LANG="en_US.UTF-8" \
  LANGUAGE="en_US:en" \
  LNAME="airflow" \
  LIBNSS_WRAPPER_PATH="/usr/lib/$(uname -m)-linux-gnu/libnss_wrapper.so" \
  AIRFLOW_EXTRAS="postgres,celery,redis,statsd" \
  AIRFLOW_CONSTRAINTS_LOCATION="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"

RUN chmod g+rwX /opt/drycc 
RUN . init-stack && \
  python3 -m venv ${AIRFLOW_HOME}/venv && \
  echo "source /opt/drycc/airflow/venv/bin/activate" >> /opt/drycc/python/profile.d/python.sh && \
  source /opt/drycc/airflow/venv/bin/activate && \
  pip install apache-airflow[${AIRFLOW_EXTRAS}]==${AIRFLOW_VERSION} --constraint ${AIRFLOW_CONSTRAINTS_LOCATION}

RUN localedef -c -f UTF-8 -i en_US en_US.UTF-8
RUN update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX && \
  DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
RUN chown -R 1001:1001 /opt/drycc

COPY rootfs /
RUN /opt/drycc/scripts/airflow/postunpack.sh
RUN /opt/drycc/scripts/locales/add-extra-locales.sh


EXPOSE 8080

USER 1001
ENTRYPOINT [ "init-stack",  "/opt/drycc/scripts/airflow/entrypoint.sh" ]
CMD [ "/opt/drycc/scripts/airflow/run.sh" ]

