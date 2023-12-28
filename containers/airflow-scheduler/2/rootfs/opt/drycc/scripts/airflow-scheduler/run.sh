#!/bin/bash
# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Airflow environment variables
. /opt/drycc/scripts/airflow-scheduler-env.sh

# Load libraries
. /opt/drycc/scripts/libos.sh
. /opt/drycc/scripts/libairflowscheduler.sh

args=("--pid" "$AIRFLOW_PID_FILE" "$@")

info "** Starting Airflow **"
if am_i_root; then
    exec_as_user "$AIRFLOW_DAEMON_USER" "${AIRFLOW_BIN_DIR}/airflow" "scheduler" "${args[@]}"
else
    exec "${AIRFLOW_BIN_DIR}/airflow" "scheduler" "${args[@]}"
fi
