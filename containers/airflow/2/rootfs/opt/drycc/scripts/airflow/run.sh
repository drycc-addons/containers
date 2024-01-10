#!/bin/bash
# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Airflow environment variables
. /opt/drycc/scripts/airflow-env.sh

# Load libraries
. /opt/drycc/scripts/libos.sh
. /opt/drycc/scripts/libairflow.sh

AIRFLOW_EXTRA_ARGS="${AIRFLOW_EXTRA_ARGS} --pid ${AIRFLOW_PID_FILE}"

airflow_extra_args=("${@}")
if ! is_empty_value "$AIRFLOW_EXTRA_ARGS"; then
    read -r -a airflow_extra_args <<< "$AIRFLOW_EXTRA_ARGS"
fi

info "** Starting Airflow **"
if am_i_root; then
    exec_as_user "$AIRFLOW_DAEMON_USER" "${AIRFLOW_BIN_DIR}/airflow" "${airflow_extra_args[@]}"
else
    exec "${AIRFLOW_BIN_DIR}/airflow" "${airflow_extra_args[@]}"
fi