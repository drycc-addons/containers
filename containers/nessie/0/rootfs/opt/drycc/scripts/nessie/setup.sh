#!/bin/bash
# Copyright Drycc Community
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/drycc/scripts/libos.sh
. /opt/drycc/scripts/libfs.sh
. /opt/drycc/scripts/libnessie.sh

# Load NESSIE environment settings
. /opt/drycc/scripts/nessie-env.sh

# Ensure NESSIE environment variables settings are valid
nessie_validate

# Ensure 'nessie' user exists when running as 'root'
am_i_root && ensure_user_exists "$NESSIE_DAEMON_USER" --group "$NESSIE_DAEMON_GROUP"

# Ensure NESSIE is initialized
nessie_initialize

# Run custom initialization scripts
nessie_custom_init_scripts
