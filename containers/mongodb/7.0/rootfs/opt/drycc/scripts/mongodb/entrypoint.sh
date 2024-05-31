#!/bin/bash
# Copyright Drycc Community
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/drycc/scripts/libdrycc.sh
. /opt/drycc/scripts/libmongodb.sh

# Load environment
. /opt/drycc/scripts/mongodb-env.sh

print_welcome_page

# We add the copy from default config in the entrypoint to not break users 
# bypassing the setup.sh logic. If the file already exists do not overwrite (in
# case someone mounts a configuration file in /opt/drycc/mongodb/conf)
debug "Copying files from $MONGODB_DEFAULT_CONF_DIR to $MONGODB_CONF_DIR"
cp -nr "$MONGODB_DEFAULT_CONF_DIR"/. "$MONGODB_CONF_DIR"

if [[ "$1" = "/opt/drycc/scripts/mongodb/run.sh" ]]; then
    info "** Starting MongoDB setup **"
    /opt/drycc/scripts/mongodb/setup.sh
    info "** MongoDB setup finished! **"
fi

echo ""
exec "$@"

