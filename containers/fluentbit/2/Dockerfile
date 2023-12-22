ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV DRYCC_UID=1001 \
  DRYCC_GID=1001 \
  PYTHON_VERSION=3.12 \
  FLUENT_BIT_VERSION=2.1.8

COPY prebuildfs /

RUN install-stack python ${PYTHON_VERSION} && . init-stack \
  && python3 -m venv /opt/drycc/.venv \
  && source /opt/drycc/.venv/bin/activate \
  && echo "source /opt/drycc/.venv/bin/activate" >> /opt/drycc/python/profile.d/python.sh \
  && install-stack fluent-bit ${FLUENT_BIT_VERSION} \
  && chown -R ${DRYCC_UID}:${DRYCC_GID} /opt/drycc/fluent-bit \
  && pip install pyyaml kubernetes-client

ADD rootfs /
USER ${DRYCC_UID}

CMD ["/opt/drycc/scripts/run.sh"]
