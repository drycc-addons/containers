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

if [[ "$1" = "/opt/drycc/scripts/rabbitmq/run.sh" ]]; then
    info "** Starting RabbitMQ setup **"
    /opt/drycc/scripts/rabbitmq/setup.sh
    info "** RabbitMQ setup finished! **"
fi

echo ""
exec "$@"
