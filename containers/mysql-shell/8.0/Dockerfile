ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV HOME="/opt/drycc" \
    OS_NAME="linux" \
    MYSQLSHELL_VERSION="8.0.34" \
    MYSQL_VERSION="8.0.34" \
    MC_VERSION="2023.07.18.21.05.38"

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
# RUN groupadd -g $GID -o mysqlsh && useradd -m -u $UID -g $GID -o -s /bin/bash mysqlsh

RUN install-packages  locales iputils-ping telnet vim

RUN install-stack mysql-shell $MYSQLSHELL_VERSION 
RUN install-stack mc $MC_VERSION
RUN install-stack mysql $MYSQL_VERSION
RUN apt-get autoremove --purge -y && \
    apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives

RUN chmod g+rwX /opt/drycc && chmod +x /opt/drycc/mysql-shell/bin/mysqlsh  

# RUN mkdir -p /opt/drycc/.mysqlsh && chmod g+rwX /opt/drycc/.mysqlsh && cd / && ln -s /opt/drycc/.mysqlsh .mysqlsh && \
#     touch /.mylogin.cnf && chmod 666 /.mylogin.cnf

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

ENV DRYCC_APP_NAME="mysqlshell" \
    PATH="/opt/drycc/mysql-shell/bin:/opt/drycc/mysql/mysql/bin:/opt/drycc/mc/bin:$PATH"

USER 1001
WORKDIR /opt/drycc

ENTRYPOINT [ "init-stack" ]
CMD [ "mysqlsh" ]