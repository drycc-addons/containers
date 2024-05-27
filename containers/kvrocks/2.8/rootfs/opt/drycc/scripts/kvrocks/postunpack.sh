#!/bin/bash
# Drycc Community
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/drycc/scripts/libfs.sh

# Load kvrocks environment variables
. /opt/drycc/scripts/kvrocks-env.sh

for dir in "$KVROCKS_VOLUME_DIR" "$KVROCKS_BASE_DIR" "$KVROCKS_CONF_DIR" "$KVROCKS_DEFAULT_CONF_DIR" "${KVROCKS_DATA_DIR}" "${KVROCKS_BACKUP_DIR}"; do
    ensure_dir_exists "$dir" "$DRYCC_UID" "$DRYCC_GID"
done
