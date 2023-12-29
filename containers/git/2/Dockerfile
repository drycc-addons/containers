ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

COPY prebuildfs /

RUN install-packages libnss-wrapper git procps ssh zlib1g \
  && mkdir -p /opt/drycc/git/profile.d \
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
RUN rm -f /etc/ssh/ssh_host_* > /dev/null 2>&1 && \
  chmod g+w /etc/ssh

ENTRYPOINT [ "init-stack", "/opt/drycc/scripts/git/entrypoint.sh" ]
CMD [ "/bin/bash" ]
