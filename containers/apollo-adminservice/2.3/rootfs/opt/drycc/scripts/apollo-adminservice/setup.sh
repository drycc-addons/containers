#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Apollo environment variables
. /opt/drycc/scripts/apollo-adminservice-env.sh

# Load libraries
. /opt/drycc/scripts/libos.sh
. /opt/drycc/scripts/libfs.sh
. /opt/drycc/scripts/libapollo-adminservice.sh


# Ensure Apollo is initialized
apollo_initialize
