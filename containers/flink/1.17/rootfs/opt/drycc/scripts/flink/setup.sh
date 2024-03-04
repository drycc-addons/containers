#!/bin/bash
# Copyright Drycc Community.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/drycc/scripts/liblog.sh
. /opt/drycc/scripts/libos.sh
. /opt/drycc/scripts/libvalidations.sh
. /opt/drycc/scripts/libflink.sh

# Load Apache Flink environment variables
. /opt/drycc/scripts/flink-env.sh

# Ensure Flink environment variables are valid
flink_validate

# Ensure Flink is initialized
flink_initialize
