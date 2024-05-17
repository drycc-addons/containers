#!/bin/bash
# Copyright Drycc Community
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/drycc/scripts/libopensearch.sh

# Load environment
. /opt/drycc/scripts/opensearch-env.sh

if [[ "$1" = "/opt/drycc/scripts/opensearch/run.sh" ]]; then
    info "** Starting Opensearch setup **"
    /opt/drycc/scripts/opensearch/setup.sh
    info "** Opensearch setup finished! **"
fi

echo ""
exec "$@"
