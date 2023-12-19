#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Fluentbit environment variables
. /opt/drycc/scripts/fluentbit-env.sh

# Load libraries
. /opt/drycc/scripts/libos.sh

BOOTLOADER="/opt/drycc/scripts/bootloader.py"

fluentbit_extra_args=("${@}")

if ! is_empty_value "$FLUENTBIT_EXTRA_ARGS"; then
    read -r -a fluentbit_extra_args <<< "$FLUENTBIT_EXTRA_ARGS"
fi

info "** Starting Fluentbit **"
if am_i_root; then
    gosu "${FLUENTBIT_DAEMON_USER}" "${BOOTLOADER}" "${fluentbit_extra_args[@]}"
else
    "${BOOTLOADER}" "${fluentbit_extra_args[@]}"
fi