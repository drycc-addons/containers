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
. /opt/drycc/scripts/libfs.sh
. /opt/drycc/scripts/libseaweedfs.sh

# Ensure Seaweedfs environment variables settings are valid
seaweedfs_validate
# Ensure Seaweedfs is initialized
seaweedfs_initialize
