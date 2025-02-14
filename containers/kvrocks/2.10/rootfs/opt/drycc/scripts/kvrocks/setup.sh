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
. /opt/drycc/scripts/libfs.sh
. /opt/drycc/scripts/libkvrocks.sh

# Ensure Kvrocks environment variables settings are valid
kvrocks_validate
# Ensure Kvrocks daemon user exists when running as root
am_i_root && ensure_user_exists "$KVROCKS_DAEMON_USER" --group "$KVROCKS_DAEMON_GROUP"
# Ensure Kvrocks is initialized
kvrocks_initialize
