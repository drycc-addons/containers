#!/bin/bash
# Copyright Drycc Community
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

# Load libraries
. /opt/drycc/scripts/libopensearchdashboards.sh
. /opt/drycc/scripts/liblog.sh

# Load environment
. /opt/drycc/scripts/opensearch-dashboards-env.sh

if [[ "$1" = "/opt/drycc/scripts/opensearch-dashboards/run.sh" ]]; then
    info "** Starting Opensearch Dashboards setup **"
    /opt/drycc/scripts/opensearch-dashboards/setup.sh
    info "** Opensearch Dashboards setup finished! **"
fi

echo ""
exec "$@"
