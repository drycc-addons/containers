#!/bin/bash
# Drycc Community
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for kvrocks

# The values for all environment variables will be set in the below order of precedence
# 1. Custom environment variables defined below after Drycc defaults
# 2. Constants defined in this file (environment variables with no default), i.e. DRYCC_ROOT_DIR
# 3. Environment variables overridden via external files using *_FILE variables (see below)
# 4. Environment variables set externally (i.e. current Bash context/Dockerfile/userdata)

# Load logging library
# shellcheck disable=SC1090,SC1091
. /opt/drycc/scripts/liblog.sh

export DRYCC_ROOT_DIR="/opt/drycc"
export DRYCC_VOLUME_DIR="/drycc"

# Logging configuration
export MODULE="${MODULE:-kvrocks}"
export DRYCC_DEBUG="${DRYCC_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
kvrocks_env_vars=(
    KVROCKS_PORT_NUMBER
    KVROCKS_CONTROLLER_ADDR
    KVROCKS_CONTROLLER_ETCD_ADDRS
    KVROCKS_CONTROLLER_ETCD_USERNAME
    KVROCKS_CONTROLLER_ETCD_PASSWORD
    KVROCKS_MASTERAUTH
    KVROCKS_REQUIREPASS
)
for env_var in "${kvrocks_env_vars[@]}"; do
    file_env_var="${env_var}_FILE"
    if [[ -n "${!file_env_var:-}" ]]; then
        if [[ -r "${!file_env_var:-}" ]]; then
            export "${env_var}=$(< "${!file_env_var}")"
            unset "${file_env_var}"
        else
            warn "Skipping export of '${env_var}'. '${!file_env_var:-}' is not readable."
        fi
    fi
done
unset kvrocks_env_vars

# Paths
export KVROCKS_VOLUME_DIR="/drycc/kvrocks"
export KVROCKS_BASE_DIR="${DRYCC_ROOT_DIR}/kvrocks"
export KVROCKS_CONF_DIR="${KVROCKS_BASE_DIR}/etc"
export KVROCKS_DEFAULT_CONF_DIR="${KVROCKS_BASE_DIR}/etc.default"
export KVROCKS_DATA_DIR="${KVROCKS_DATA_DIR:-${KVROCKS_VOLUME_DIR}/data}"
export KVROCKS_BACKUP_DIR="${KVROCKS_BACKUP_DIR:-${KVROCKS_VOLUME_DIR}/data}"
export KVROCKS_CONF_FILE="${KVROCKS_CONF_DIR}/kvrocks.conf"
export KVROCKS_CONTROLLER_CONF_FILE="${KVROCKS_CONF_DIR}/kvrocks-controller.yaml"
export KVROCKS_DEFAULT_CONF_FILE="${KVROCKS_DEFAULT_CONF_DIR}/kvrocks.conf"
export KVROCKS_DEFAULT_CONTROLLER_CONF_FILE="${KVROCKS_DEFAULT_CONF_DIR}/kvrocks-controller.yaml"
export KVROCKS_LOG_DIR="${KVROCKS_BASE_DIR}/logs"
export KVROCKS_LOG_FILE="${KVROCKS_LOG_DIR}/kvrocks.log"
export KVROCKS_TMP_DIR="${KVROCKS_BASE_DIR}/tmp"
export KVROCKS_PID_FILE="${KVROCKS_TMP_DIR}/kvrocks.pid"
export KVROCKS_BIN_DIR="${KVROCKS_BASE_DIR}/bin"
export PATH="${KVROCKS_BIN_DIR}:${DRYCC_ROOT_DIR}/common/bin:${PATH}"

#
export KVROCKS_EXTRA_FLAGS="${KVROCKS_EXTRA_FLAGS:-}"

# System users (when running with a privileged user)
export KVROCKS_DAEMON_USER="kvrocks"
export KVROCKS_DAEMON_GROUP="kvrocks"

# kvrocks settings
export KVROCKS_BIND="${KVROCKS_BIND:-0.0.0.0}"
export KVROCKS_MASTERAUTH="${KVROCKS_MASTERAUTH:-}"
export KVROCKS_REQUIREPASS="${KVROCKS_REQUIREPASS:-}"
export KVROCKS_PORT_NUMBER="${KVROCKS_PORT_NUMBER:-6101}"

# kvrocks controller settings
export KVROCKS_NODES="${KVROCKS_NODES:-}"
export KVROCKS_REPLICA="${KVROCKS_REPLICA:-2}"
export KVROCKS_CONTROLLER_ADDR="${KVROCKS_CONTROLLER_ADDR:-0.0.0.0:9379}"
export KVROCKS_CONTROLLER_ETCD_ADDRS="${KVROCKS_CONTROLLER_ETCD_ADDRS:-127.0.0.1:2379}"
export KVROCKS_CONTROLLER_ETCD_USERNAME="${KVROCKS_CONTROLLER_ETCD_USERNAME:-}"
export KVROCKS_CONTROLLER_ETCD_PASSWORD="${KVROCKS_CONTROLLER_ETCD_PASSWORD:-}"
export KVROCKS_CONTROLLER_CLUSTER="${KVROCKS_CONTROLLER_CLUSTER:-default}"
export KVROCKS_CONTROLLER_NAMESPACE="${KVROCKS_CONTROLLER_NAMESPACE:-default}"

# Custom environment variables may be defined below
