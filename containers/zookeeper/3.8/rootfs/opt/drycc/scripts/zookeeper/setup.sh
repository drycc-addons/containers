#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/drycc/scripts/libfs.sh
. /opt/drycc/scripts/libos.sh
. /opt/drycc/scripts/libzookeeper.sh

# Load ZooKeeper environment variables
. /opt/drycc/scripts/zookeeper-env.sh

# Ensure ZooKeeper environment variables are valid
zookeeper_validate
# Ensure ZooKeeper user and group exist when running as 'root'
if am_i_root; then
    ensure_user_exists "$ZOO_DAEMON_USER" --group "$ZOO_DAEMON_GROUP"
    ZOOKEEPER_OWNERSHIP_USER="$ZOO_DAEMON_USER"
else
    ZOOKEEPER_OWNERSHIP_USER=""
fi
# Ensure directories used by ZooKeeper exist and have proper ownership and permissions
for dir in "$ZOO_DATA_DIR" "$ZOO_CONF_DIR" "$ZOO_LOG_DIR"; do
    ensure_dir_exists "$dir" "$ZOOKEEPER_OWNERSHIP_USER"
done
# Ensure ZooKeeper is initialized
zookeeper_initialize
