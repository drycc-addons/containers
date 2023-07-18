#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load Redis environment variables
. /opt/drycc/scripts/redis-cluster-env.sh

# Load libraries
. /opt/drycc/scripts/librediscluster.sh

if [[ "$*" = *"/run.sh"* ]]; then
    info "** Starting Redis setup **"
    /opt/drycc/scripts/redis-cluster/setup.sh
    info "** Redis setup finished! **"
fi

echo ""
exec "$@"
