ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV HOME="/opt/drycc" \
    OS_NAME="linux" \
    MYSQLSHELL_VERSION="8.0.34"

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
# RUN groupadd -g $GID -o mysqlsh && useradd -m -u $UID -g $GID -o -s /bin/bash mysqlsh

RUN install-packages  locales iputils-ping telnet

RUN install-stack mysql-shell $MYSQLSHELL_VERSION 

RUN apt-get autoremove --purge -y curl && \
    apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives

RUN chmod g+rwX /opt/drycc && chmod +x /opt/drycc/mysql-shell/bin/mysqlsh  

# RUN mkdir -p /opt/drycc/.mysqlsh && chmod g+rwX /opt/drycc/.mysqlsh && cd / && ln -s /opt/drycc/.mysqlsh .mysqlsh && \
#     touch /.mylogin.cnf && chmod 666 /.mylogin.cnf

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

ENV DRYCC_APP_NAME="mysqlshell" \
    PATH="/opt/drycc/mysql-shell/bin:$PATH"

USER 1001
WORKDIR /opt/drycc

ENTRYPOINT [ "init-stack" ]
CMD [ "mysqlsh" ]