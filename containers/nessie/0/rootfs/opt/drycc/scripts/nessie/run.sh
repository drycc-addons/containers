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
. /opt/drycc/scripts/libos.sh

# Load NESSIE environment settings
. /opt/drycc/scripts/nessie-env.sh

java -jar nessie-quarkus-0.103.0-runner.jar
if am_i_root; then
    exec_as_user "$NESSIE_DAEMON_USER" "jar" "${ARGS[@]-}"
else
    exec "$EXEC" "${ARGS[@]-}"
fi
