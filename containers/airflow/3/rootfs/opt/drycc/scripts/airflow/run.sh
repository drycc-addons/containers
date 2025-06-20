#!/bin/bash
# Copyright Drycc Community.
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

command=("$AIRFLOW_COMPONENT_TYPE")
# 2.x and 3.x compatibility
[[ "$AIRFLOW_COMPONENT_TYPE" = "api-server" ]] && [[ $(airflow_major_version) -eq 2 ]] && command=("webserver")
args=("--pid" "${AIRFLOW_TMP_DIR}/airflow-${AIRFLOW_COMPONENT_TYPE}.pid" "$@")
if [[ "$AIRFLOW_COMPONENT_TYPE" = "worker" ]]; then
    command=("celery" "worker")
    [[ -n "$AIRFLOW_WORKER_QUEUE" ]] && args+=("-q" "$AIRFLOW_WORKER_QUEUE")
    am_i_root && export C_FORCE_ROOT="true"
fi

info "** Starting Airflow **"
if am_i_root; then
    exec_as_user "$AIRFLOW_DAEMON_USER" "${AIRFLOW_BIN_DIR}/airflow" "${command[@]}" "${args[@]}"
else
    exec "${AIRFLOW_BIN_DIR}/airflow" "${command[@]}" "${args[@]}"
fi