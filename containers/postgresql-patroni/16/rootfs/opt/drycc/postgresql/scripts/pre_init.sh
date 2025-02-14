#!/bin/bash

cat > /opt/drycc/postgresql/patroni.yml <<__EOF__
log:
  level: DEBUG

bootstrap:
  dcs:
    postgresql:
      use_pg_rewind: true
      pg_hba:
      - local all all     peer
      - host all all 0.0.0.0/0 md5
      - host replication ${PATRONI_REPLICATION_USERNAME} ${PATRONI_KUBERNETES_POD_IP}/16 md5
  initdb:
  - auth-host: md5
  - auth-local: trust
  - encoding: UTF8
  - locale: en_US.UTF-8
  - data-checksums
restapi:
  connect_address: '${PATRONI_KUBERNETES_POD_IP}:8008'
postgresql:
  connect_address: '${PATRONI_KUBERNETES_POD_IP}:5432'
  authentication:
    superuser:
      password: '${PATRONI_SUPERUSER_PASSWORD}'
    replication:
      password: '${PATRONI_REPLICATION_PASSWORD}'
__EOF__
