#!/bin/bash
# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

# Load libraries
. /opt/drycc/scripts/libopensearchdashboards.sh
. /opt/drycc/scripts/libos.sh
. /opt/drycc/scripts/liblog.sh

# Load environment
. /opt/drycc/scripts/opensearch-dashboards-env.sh

info "** Starting Opensearch Dashboards **"
start_command=("${SERVER_BIN_DIR}/opensearch-dashboards" "serve")
if am_i_root; then
    exec_as_user "$SERVER_DAEMON_USER" "${start_command[@]}"
else
    exec "${start_command[@]}"
fi
