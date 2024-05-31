#!/bin/bash
# Copyright Drycc Community. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Kvrocks environment variables
. /opt/drycc/scripts/kvrocks-env.sh

# Load libraries
. /opt/drycc/scripts/libdrycc.sh
. /opt/drycc/scripts/libkvrocks.sh

print_welcome_page

# We add the copy from default config in the entrypoint to not break users 
# bypassing the setup.sh logic. If the file already exists do not overwrite (in
# case someone mounts a configuration file in /opt/drycc/kvrocks/etc)
debug "Copying files from $KVROCKS_DEFAULT_CONF_DIR to $KVROCKS_CONF_DIR"
cp -nr "$KVROCKS_DEFAULT_CONF_DIR"/. "$KVROCKS_CONF_DIR"

if [[ "$*" = *"/run.sh"* ]]; then
    info "** Starting Kvrocks setup **"
    /opt/drycc/scripts/kvrocks/setup.sh
    info "** Kvrocks setup finished! **"
fi

echo ""
exec "$@"