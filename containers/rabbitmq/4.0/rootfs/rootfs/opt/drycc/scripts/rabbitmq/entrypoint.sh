#!/bin/bash
# Copyright Drycc Community
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/drycc/scripts/librabbitmq.sh
. /opt/drycc/scripts/liblog.sh

# Load RabbitMQ environment variables
. /opt/drycc/scripts/rabbitmq-env.sh

if ! is_dir_empty "$RABBITMQ_DEFAULT_CONF_DIR"; then
    # We add the copy from default config in the entrypoint to not break users 
    # bypassing the setup.sh logic. If the file already exists do not overwrite (in
    # case someone mounts a configuration file in /opt/bitnami/rabbitmq/etc/rabbitmq)
    debug "Copying files from $RABBITMQ_DEFAULT_CONF_DIR to $RABBITMQ_CONF_DIR"
    cp -nr "$RABBITMQ_DEFAULT_CONF_DIR"/. "$RABBITMQ_CONF_DIR"
fi
if [[ "$1" = "/opt/drycc/scripts/rabbitmq/run.sh" ]]; then
    info "** Starting RabbitMQ setup **"
    /opt/drycc/scripts/rabbitmq/setup.sh
    info "** RabbitMQ setup finished! **"
fi

echo ""
exec "$@"
