#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/drycc/scripts/libapollo-adminservice.sh
. /opt/drycc/scripts/libos.sh

# Load apollo adminservice environment variables
. /opt/drycc/scripts/apollo-adminservice-env.sh


cmd="$APOLLO_SCRIPTS_DIR/startup.sh"

info "** Starting Apollo Adminservice **"
if am_i_root; then
    exec_as_user "$APOLLO_DAEMON_USER" "$cmd"
else
    exec "$cmd"
fi
