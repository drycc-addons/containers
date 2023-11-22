#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load Seaweedfs environment variables
. /opt/drycc/scripts/seaweedfs-env.sh

# Load libraries
. /opt/drycc/scripts/libseaweedfs.sh

# print_welcome_page

if [[ "$*" = *"/opt/drycc/scripts/seaweedfs/run.sh"* || "$*" = *"/run.sh"* ]]; then
    info "** Starting Seaweedfs setup **"
    /opt/drycc/scripts/seaweedfs/setup.sh
    info "** Seaweedfs setup finished! **"
fi

echo ""
exec "$@"
