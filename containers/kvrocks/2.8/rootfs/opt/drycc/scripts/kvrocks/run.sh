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
. /opt/drycc/scripts/libos.sh
. /opt/drycc/scripts/libkvrocks.sh

# Add flags specified via the 'KVROCKS_EXTRA_FLAGS' environment variable
read -r -a extra_flags <<< "$KVROCKS_EXTRA_FLAGS"

# kvrocks component, default kvrocks
KVROCKS_COMPONENT="${KVROCKS_COMPONENT:-kvrocks}"

if [[ "$KVROCKS_COMPONENT" == "kvrocks" ]]; then
    info "** Starting Kvrocks **"
    # Parse CLI flags to pass to the 'kvrocks' call
    args=("-c" "${KVROCKS_CONF_FILE}" "--daemonize" "no")
    args+=("${extra_flags[@]}")
    if am_i_root; then
        exec_as_user "$KVROCKS_DAEMON_USER" kvrocks "${args[@]}"
    else
        exec kvrocks "${args[@]}"
    fi
else
    info "** Starting Kvrocks Controller **"
    # Parse CLI flags to pass to the 'kvrocks' call
    args=("-c" "${KVROCKS_CONTROLLER_CONF_FILE}")
    args+=("${extra_flags[@]}")
    if am_i_root; then
        exec_as_user "$KVROCKS_DAEMON_USER" kvctl-server "${args[@]}"
    else
        exec kvctl-server "${args[@]}"
    fi
fi