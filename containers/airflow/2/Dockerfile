# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0

ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV HOME="/opt/drycc" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux" \
    WAIT_FOR_PORT_VERSION="1.0.7" \
    POSTGERSQL_VERSION="15.5" \
    INI_FILE_VERSION="1.4.6" \
    AIRFLOW_VERSION="2.8.0" \
    PYTHON_VERSION="3.11"

COPY prebuildfs /
# SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install-packages ca-certificates curl git krb5-user libbsd0 libbz2-1.0 libcdt5 libcgraph6 \
    libcom-err2 libcrypt1 libedit2 libexpat1  libgcc-s1 libgmp10 libgnutls30 libgss-dev libgssapi-krb5-2 libgvc6 \
    libhogweed6 libicu72 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5-dev libkrb5support0 libldap-2.5-0 \
    libltdl7 liblz4-1 liblzma5 libmariadb3 libmd0 libncursesw6 libnettle8 libnsl2 libp11-kit0 libpathplan4 libreadline8 \
    libsasl2-2 libsasl2-modules libsqlite3-0  libstdc++6 libsybdb5 libtasn1-6 libtinfo6 libtirpc3 libunistring2 libuuid1 \
    libxml2 libxslt1.1 locales netbase procps tzdata zlib1g libffi8 libssl3 libnss-wrapper gcc

RUN install-stack postgresql ${POSTGERSQL_VERSION}
RUN install-stack ini-file ${INI_FILE_VERSION}
RUN install-stack python ${PYTHON_VERSION}
RUN install-stack wait-for-port ${WAIT_FOR_PORT_VERSION}

RUN chmod g+rwX /opt/drycc 
RUN . init-stack &&  python3 -m venv /opt/drycc/airflow/venv && source /opt/drycc/airflow/venv/bin/activate &&  \
    pip install apache-airflow[postgres,celery,ftp,github,redis,sftp,sqlite,ssh]==${AIRFLOW_VERSION} --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt" && \
    pip install -r /opt/drycc/airflow/requirements.txt --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt" && \
    echo "source /opt/drycc/airflow/venv/bin/activate" >> /opt/drycc/python/profile.d/python.sh
    
RUN localedef -c -f UTF-8 -i en_US en_US.UTF-8
RUN update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
RUN mkdir /.local && chmod g+rwX /.local

COPY rootfs /
RUN /opt/drycc/scripts/airflow/postunpack.sh
RUN /opt/drycc/scripts/locales/add-extra-locales.sh

ENV AIRFLOW_HOME="/opt/drycc/airflow" \
    DRYCC_APP_NAME="airflow" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LNAME="airflow" \
    LIBNSS_WRAPPER_PATH="/usr/lib/$(uname -m)-linux-gnu/libnss_wrapper.so" \
    PATH="/opt/drycc/airflow/venv/bin:$PATH"

EXPOSE 8080

USER 1001
ENTRYPOINT [ "init-stack",  "/opt/drycc/scripts/airflow/entrypoint.sh" ]
CMD [ "/opt/drycc/scripts/airflow/run.sh" ]
