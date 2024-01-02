# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0

ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ENV DRYCC_UID=1001 \
  DRYCC_GID=1001

COPY prebuildfs /

RUN install-packages inotify-tools

COPY rootfs /

USER ${DRYCC_UID}
ENTRYPOINT ["init-stack", "/opt/drycc/scripts/config-reloader"]
