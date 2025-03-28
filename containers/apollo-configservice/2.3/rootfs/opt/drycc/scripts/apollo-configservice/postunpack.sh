#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load apollo-configservice environment variables
. /opt/drycc/scripts/apollo-configservice-env.sh

# Load libraries
. /opt/drycc/scripts/libapollo-configservice.sh
. /opt/drycc/scripts/libfs.sh

for dir in "${APOLLO_BASE_DIR}" "${APOLLO_LOG_FOLDER}"; do
    ensure_dir_exists "$dir"
done
chmod -R g+rwX "${APOLLO_BASE_DIR}" "${APOLLO_LOG_FOLDER}"
