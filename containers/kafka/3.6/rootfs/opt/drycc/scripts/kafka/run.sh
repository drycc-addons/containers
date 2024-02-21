#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/drycc/scripts/libkafka.sh
. /opt/drycc/scripts/libos.sh

# Load Kafka environment variables
. /opt/drycc/scripts/kafka-env.sh

if [[ -f "${KAFKA_CONF_DIR}/kafka_jaas.conf" ]]; then
    export KAFKA_OPTS="-Djava.security.auth.login.config=${KAFKA_CONF_DIR}/kafka_jaas.conf"
fi

cmd="$KAFKA_HOME/bin/kafka-server-start.sh"
args=("$KAFKA_CONF_FILE")
! is_empty_value "${KAFKA_EXTRA_FLAGS:-}" && args=("${args[@]}" "${KAFKA_EXTRA_FLAGS[@]}")

info "** Starting Kafka **"
if am_i_root; then
    exec_as_user "$KAFKA_DAEMON_USER" "$cmd" "${args[@]}" "$@"
else
    exec "$cmd" "${args[@]}" "$@"
fi
