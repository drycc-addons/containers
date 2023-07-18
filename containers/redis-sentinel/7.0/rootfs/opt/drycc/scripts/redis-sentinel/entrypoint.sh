#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load Redis Sentinel environment variables
. /opt/drycc/scripts/redis-sentinel-env.sh

# Load libraries
. /opt/drycc/scripts/libredissentinel.sh
. /opt/drycc/scripts/libbitnami.sh
. /opt/drycc/scripts/liblog.sh

# print_welcome_page

if [[ "$*" == *"/opt/drycc/scripts/redis-sentinel/run.sh"* ]]; then
    info "** Starting Redis sentinel setup **"
    /opt/drycc/scripts/redis-sentinel/setup.sh
    info "** Redis sentinel setup finished! **"
fi

echo ""
exec "$@"
