#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Seaweedfs environment variables
. /opt/drycc/scripts/seaweedfs-env.sh

# Load libraries
. /opt/drycc/scripts/libos.sh
. /opt/drycc/scripts/libseaweedfs.sh

EXEC=$(command -v weed)

seaweedfs_extra_args=("${@}")

if ! is_empty_value "$SEAWEEDFS_EXTRA_ARGS"; then
    read -r -a seaweedfs_extra_args <<< "$SEAWEEDFS_EXTRA_ARGS"
fi

info "** Starting Seaweedfs **"
if am_i_root; then
    exec gosu "${SEAWEEDFS_DAEMON_USER}" "${EXEC}" "${seaweedfs_extra_args[@]}"
else
    exec "${EXEC}" "${seaweedfs_extra_args[@]}"
fi