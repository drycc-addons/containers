#!/bin/bash
# Drycc Community
# SPDX-License-Identifier: APACHE-2.0
#
# Drycc etcd library

# shellcheck disable=SC1090,SC1091,SC2119,SC2120

# Load Generic Libraries
. /opt/drycc/scripts/libfile.sh
. /opt/drycc/scripts/libfs.sh
. /opt/drycc/scripts/liblog.sh
. /opt/drycc/scripts/libos.sh
. /opt/drycc/scripts/libnet.sh
. /opt/drycc/scripts/libservice.sh

# Functions

########################
# Set the kvrocks configuration file
#########################
kvrocks_config_setup() {
  kvrocks_conf_set bind "$KVROCKS_BIND"
  kvrocks_conf_set port "$KVROCKS_PORT_NUMBER"
  kvrocks_conf_set masterauth "$KVROCKS_MASTERAUTH"
  kvrocks_conf_set requirepass "$KVROCKS_REQUIREPASS"
  kvrocks_conf_set dir "$KVROCKS_DATA_DIR"
  kvrocks_conf_set backup-dir "$KVROCKS_BACKUP_DIR"
  kvrocks_conf_set pidfile "$KVROCKS_PID_FILE"
  kvrocks_conf_set cluster-enabled yes
}

########################
# Set the kvrocks controller configuration file
#########################
kvrocks_controller_config_setup() {
  cp "${KVROCKS_DEFAULT_CONTROLLER_CONF_FILE}" "${KVROCKS_CONTROLLER_CONF_FILE}"
  yq e ".addr = \"${KVROCKS_CONTROLLER_ADDR}\"" -i "${KVROCKS_CONTROLLER_CONF_FILE}"
  if [ -n "${KVROCKS_CONTROLLER_ETCD_USERNAME}" ]; then
    yq e ".etcd.username = \"${KVROCKS_CONTROLLER_ETCD_USERNAME}\"" -i "${KVROCKS_CONTROLLER_CONF_FILE}"
  fi
  if [ -n "${KVROCKS_CONTROLLER_ETCD_PASSWORD}" ]; then
    yq e ".etcd.password = \"${KVROCKS_CONTROLLER_ETCD_PASSWORD}\"" -i "${KVROCKS_CONTROLLER_CONF_FILE}"
  fi
  yq e ".etcd.addrs = []" -i "${KVROCKS_CONTROLLER_CONF_FILE}"
  for addr in $(echo $KVROCKS_CONTROLLER_ETCD_ADDRS | tr "," "\n")
  do
    yq e ".etcd.addrs += \"${addr}\"" -i "${KVROCKS_CONTROLLER_CONF_FILE}"
  done
}

########################
# Retrieve a configuration setting value
# Globals:
#   KVROCKS_BASE_DIR
# Arguments:
#   $1 - key
#   $2 - conf file
# Returns:
#   None
#########################
kvrocks_conf_get() {
    local -r key="${1:?missing key}"
    local -r conf_file="${2:-"${KVROCKS_CONF_FILE}"}"

    if grep -q -E "^\s*$key " "$conf_file"; then
        grep -E "^\s*$key " "$conf_file" | awk '{print $2}'
    fi
}

########################
# Set a configuration setting value
# Globals:
#   KVROCKS_BASE_DIR
# Arguments:
#   $1 - key
#   $2 - value
# Returns:
#   None
#########################
kvrocks_conf_set() {
    local -r key="${1:?missing key}"
    local value="${2:-}"

    # Sanitize inputs
    value="${value//\\/\\\\}"
    value="${value//&/\\&}"
    value="${value//\?/\\?}"
    value="${value//[$'\t\n\r']}"
    [[ "$value" = "" ]] && value="\"$value\""

    replace_in_file "${KVROCKS_CONF_FILE}" "^#*\s*${key} .*" "${key} ${value}" false
}

########################
# Unset a configuration setting value
# Globals:
#   KVROCKS_BASE_DIR
# Arguments:
#   $1 - key
# Returns:
#   None
#########################
kvrocks_conf_unset() {
    local -r key="${1:?missing key}"
    remove_in_file "${KVROCKS_CONF_FILE}" "^\s*$key .*" false
}

########################
# Validate settings in KVROCKS_* env vars.
#########################
kvrocks_validate() {
    debug "Validating settings in KVROCKS_* env vars.."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    empty_environment_error() {
        print_validation_error "The $1 environment variable is empty or not set."
    }

    if [[ -z "$KVROCKS_PORT_NUMBER" ]]; then
        empty_environment_error KVROCKS_PORT_NUMBER
    fi

    if [[ -z "$KVROCKS_CONTROLLER_ADDR" ]]; then
        empty_environment_error KVROCKS_CONTROLLER_ADDR
    fi

    if [[ -z "$KVROCKS_CONTROLLER_ETCD_ADDRS" ]]; then
        empty_environment_error KVROCKS_CONTROLLER_ETCD_ADDRS
    fi

    if [[ -z "$KVROCKS_MASTERAUTH" ]]; then
        empty_environment_error KVROCKS_MASTERAUTH
    fi

    if [[ -z "$KVROCKS_REQUIREPASS" ]]; then
        empty_environment_error KVROCKS_REQUIREPASS
    fi

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Initialize a configuration setting value
#########################
kvrocks_initialize() {
  kvrocks_config_setup
  kvrocks_controller_config_setup
}
