#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /opt/drycc/scripts/libfs.sh
. /opt/drycc/scripts/libminioclient.sh

# Load MinIO Client environment
. /opt/drycc/scripts/minio-client-env.sh

for dir in "$MINIO_CLIENT_BASE_DIR" "$MINIO_CLIENT_CONF_DIR"; do
    ensure_dir_exists "$dir"
done
chmod -R g+rwX "$MINIO_CLIENT_BASE_DIR" "$MINIO_CLIENT_CONF_DIR"
