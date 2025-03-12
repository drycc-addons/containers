#!/bin/bash
# Copyright Drycc Community
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/drycc/scripts/libnessie.sh

# Load NESSIE environment settings
. /opt/drycc/scripts/nessie-env.sh

if [ ! $EUID -eq 0 ] && [ -e "$NSS_WRAPPER_LIB" ]; then
    echo "nessie:x:$(id -u):$(id -g):NESSIE:$NESSIE_HOME:/bin/false" > "$NSS_WRAPPER_PASSWD"
    echo "nessie:x:$(id -g):" > "$NSS_WRAPPER_GROUP"
fi

if [[ "$1" = "/opt/drycc/scripts/nessie/run.sh" ]]; then
    info "** Starting NESSIE setup **"
    /opt/drycc/scripts/nessie/setup.sh
    info "** NESSIE setup finished! **"
fi

# NESSIE has an special 'driver' command which is an alias for nessie-submit
# https://github.com/apache/nessie/blob/master/resource-managers/kubernetes/docker/src/main/dockerfiles/nessie/entrypoint.sh

set -o pipefail

CMD=(
  "${JAVA_HOME}/bin/java"
  "${NESSIE_EXECUTOR_JAVA_OPTS[@]}"
)

echo ""
exec "${CMD[@]}"
