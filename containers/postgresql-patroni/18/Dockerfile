ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV PG_MAJOR=18 \
  PG_MINOR=1 \
  WALG_VERSION="3.0.5" \
  HOME=/opt/drycc/postgresql 
ENV PGDATA=$HOME/$PG_MAJOR/data \
  PGHOME=$HOME
# Install postgresql && wal-g
RUN . init-stack && install-stack postgresql $PG_MAJOR.$PG_MINOR \
  && install-stack wal-g $WALG_VERSION \
  && export DEBIAN_FRONTEND=noninteractive \
  && echo 'APT::Install-Recommends "0";\nAPT::Install-Suggests "0";' > /etc/apt/apt.conf.d/01norecommend \
  && apt-get update -y \
  && apt-cache depends patroni | sed -n -e 's/.* Depends: \(python3-.\+\)$/\1/p' \
  | grep -Ev '^python3-(sphinx|etcd|consul|kazoo|kubernetes)' \
  | xargs apt-get install -y vim-tiny curl jq locales git python3-pip python3-wheel \
  ## Make sure we have a en_US.UTF-8 locale available
  && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
  && pip3 install --break-system-packages setuptools \
  && pip3 install --break-system-packages 'git+https://github.com/zalando/patroni.git#egg=patroni[kubernetes]' \
  && pip3 install --break-system-packages  uvicorn \
  && pip3 install --break-system-packages  fastapi 
# Prepare init script
COPY rootfs / 
COPY entrypoint.sh /

RUN chmod g+rwX $PGHOME \
  && sed -i "s|/var/lib/postgresql.*|$PGHOME:/bin/bash|" /etc/passwd \
  # Set permissions for OpenShift
  && chmod 775 $PGHOME \
  && chmod 664 /etc/passwd \
  # Clean up
  && apt-get remove -y git python3-pip python3-wheel \
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/* /root/.cache \
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
  && mkdir -p $PGDATA  \
  && groupadd postgres && useradd -g postgres postgres \
  && chown -R postgres:postgres $HOME 

ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 EDITOR=/usr/bin/editor \
  PATH=$PATH:/opt/drycc/postgresql/$PG_MAJOR/bin/:/opt/drycc/wal-g/bin/
USER postgres
ENTRYPOINT ["init-stack", "/entrypoint.sh"]
EXPOSE 5432 8008 9000