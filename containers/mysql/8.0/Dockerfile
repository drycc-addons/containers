ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV HOME="/" \
    OS_NAME="linux" \
    MYSQL_VERSION="8.0.34"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies

# RUN install-packages ca-certificates curl gcc-10 libaio1 libcom-err2 libgcc-s1 libgssapi-krb5-2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libsasl2-2 libssl1.1 libstdc++6 libtinfo6 libtirpc3 procps psmisc
RUN install-packages ca-certificates curl gcc-12 libaio1 libcom-err2 libgcc-s1 libgssapi-krb5-2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libsasl2-2  libstdc++6 libtinfo6 libtirpc3 procps psmisc

RUN mkdir -p /tmp/drycc/pkg/cache/ && cd /tmp/drycc/pkg/cache/ && \
    install-stack mysql $MYSQL_VERSION && \
    mv /opt/drycc/mysql/mysql/* /opt/drycc/mysql/ && rm -rf /opt/drycc/mysql/mysql/
#    rm -rf /opt/drycc/mysql/mysql-8.0/mysql-test && mv /opt/drycc/mysql/mysql-8.0/* /opt/drycc/mysql/ && rm /opt/drycc/mysql/mysql-8.0/

RUN install-stack ini-file 1.4.5

RUN apt-get autoremove --purge -y curl && \
    apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/drycc

RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /opt/drycc/scripts/mysql/postunpack.sh
ENV APP_VERSION="8.0.34" \
    DRYCC_APP_NAME="mysql" \
    PATH="/opt/drycc/ini-file/bin:/opt/drycc/mysql/bin:/opt/drycc/mysql/sbin:$PATH"

EXPOSE 3306

USER 1001
ENTRYPOINT [ "/opt/drycc/scripts/mysql/entrypoint.sh" ]
CMD [ "/opt/drycc/scripts/mysql/run.sh" ]
