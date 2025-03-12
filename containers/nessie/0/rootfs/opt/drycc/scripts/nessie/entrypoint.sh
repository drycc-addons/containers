#!/bin/bash
# Copyright Drycc Community
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/drycc/scripts/libspark.sh

# Load Spark environment settings
. /opt/drycc/scripts/spark-env.sh

if [ ! $EUID -eq 0 ] && [ -e "$NSS_WRAPPER_LIB" ]; then
    echo "spark:x:$(id -u):$(id -g):Spark:$SPARK_HOME:/bin/false" > "$NSS_WRAPPER_PASSWD"
    echo "spark:x:$(id -g):" > "$NSS_WRAPPER_GROUP"
fi

if [[ "$1" = "/opt/drycc/scripts/spark/run.sh" ]]; then
    info "** Starting Spark setup **"
    /opt/drycc/scripts/spark/setup.sh
    info "** Spark setup finished! **"
fi

# Spark has an special 'driver' command which is an alias for spark-submit
# https://github.com/apache/spark/blob/master/resource-managers/kubernetes/docker/src/main/dockerfiles/spark/entrypoint.sh

set -o pipefail

CMD=(
  "${JAVA_HOME}/bin/java"
  "${SPARK_EXECUTOR_JAVA_OPTS[@]}"
)

echo ""
exec "${CMD[@]}"
