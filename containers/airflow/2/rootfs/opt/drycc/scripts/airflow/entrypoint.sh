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
. /opt/drycc/scripts/libdrycc.sh
. /opt/drycc/scripts/libairflow.sh

print_welcome_page

if ! am_i_root && [[ -e "$LIBNSS_WRAPPER_PATH" ]]; then
    info "Enabling non-root system user with nss_wrapper"
    echo "airflow:x:$(id -u):$(id -g):Airflow:$AIRFLOW_HOME:/bin/false" > "$NSS_WRAPPER_PASSWD"
    echo "airflow:x:$(id -g):" > "$NSS_WRAPPER_GROUP"

    export LD_PRELOAD="$LIBNSS_WRAPPER_PATH"
    export HOME="$AIRFLOW_HOME"
fi

# Install dags requirements
if [[ -d "${AIRFLOW_DAGS_DIR}" ]]; then
    for folder in $(ls "${AIRFLOW_DAGS_DIR}")
    do
        DAG_PATH="${AIRFLOW_DAGS_DIR}/${folder}"
        REQUIREMENTS_PATH="${DAG_PATH}/requirements.txt"
        if [[ -f "${REQUIREMENTS_PATH}" ]]; then
            pip install -r "${REQUIREMENTS_PATH}"
        fi
        if [[ "${PYTHONPATH:-}" == "" ]]; then
            PYTHONPATH=$DAG_PATH
        else
            PYTHONPATH=$PYTHONPATH:$DAG_PATH
        fi
    done
    if [[ "${PYTHONPATH:-}" != "" ]]; then
        export PYTHONPATH
    fi
fi

if [[ "$*" = *"/opt/drycc/scripts/airflow/run.sh"* || "$*" = *"/run.sh"* ]]; then
    info "** Starting Airflow setup **"
    /opt/drycc/scripts/postgresql-client/setup.sh
    /opt/drycc/scripts/airflow/setup.sh
    info "** Airflow setup finished! **"
fi

echo ""
exec "$@"
