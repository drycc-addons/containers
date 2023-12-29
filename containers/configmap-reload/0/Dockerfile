# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0

ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV DRYCC_UID=1001 \
  DRYCC_GID=1001 \
  CONFIGMAP_RELOAD_VERSION=0.12.0

COPY prebuildfs /

RUN install-stack configmap-reload ${CONFIGMAP_RELOAD_VERSION}

USER ${DRYCC_UID}

WORKDIR /opt/bitnami/configmap-reload
ENTRYPOINT ["init-stack", "configmap-reload"]
