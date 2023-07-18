ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV KUBECTL_VERSION="1.27.3"

RUN install-packages libnss-wrapper \
    && install-stack kubectl $KUBECTL_VERSION \
    && echo "export NSS_WRAPPER_LIB=/usr/lib/`echo $(uname -m)`-linux-gnu/libnss_wrapper.so" >> /opt/drycc/kubectl/profile.d/kubectl.sh \
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
    && mkdir /.kube && chmod g+rwX /.kube

USER 1001
ENTRYPOINT [ "init-stack", "kubectl" ]
CMD [ "--help" ]
