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
. /opt/drycc/scripts/libos.sh

# Load Spark environment settings
. /opt/drycc/scripts/spark-env.sh

java -jar nessie-quarkus-0.103.0-runner.jar
if am_i_root; then
    exec_as_user "$SPARK_DAEMON_USER" "jar" "${ARGS[@]-}"
else
    exec "$EXEC" "${ARGS[@]-}"
fi
