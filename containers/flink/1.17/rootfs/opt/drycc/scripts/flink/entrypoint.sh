#!/bin/bash
# Copyright Drycc Community.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/drycc/scripts/liblog.sh

# Load Apache Flink environment variables
. /opt/drycc/scripts/flink-env.sh

if [[ "$1" = "/opt/drycc/scripts/flink/run.sh" ]]; then
    info "** Starting Apache Flink ${FLINK_MODE} setup **"
    /opt/drycc/scripts/flink/setup.sh
    info "** FLINK ${FLINK_MODE} setup finished! **"
fi

echo ""
exec "$@"
