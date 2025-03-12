#!/bin/bash
# Copyright Drycc Community
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

# Load libraries
. /opt/drycc/scripts/libfs.sh
. /opt/drycc/scripts/libnessie.sh

# Load NESSIE environment settings
. /opt/drycc/scripts/nessie-env.sh

for dir in "$NESSIE_TMP_DIR" "$NESSIE_LOG_DIR" "$NESSIE_CONF_DIR" "$NESSIE_WORK_DIR" "$NESSIE_JARS_DIR"; do
    ensure_dir_exists "$dir"
    configure_permissions_ownership "$dir" -d "775" -f "664" -g "root"
done

# Set correct owner in installation directory
chown -R "1001:root" "$NESSIE_BASE_DIR"
