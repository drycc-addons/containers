#!/bin/bash
#
# Drycc Apollo library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/drycc/scripts/libfile.sh
. /opt/drycc/scripts/liblog.sh
. /opt/drycc/scripts/libnet.sh
. /opt/drycc/scripts/libos.sh
. /opt/drycc/scripts/libservice.sh
. /opt/drycc/scripts/libvalidations.sh

# Functions

########################
# Retrieve a configuration setting value
# Globals:
#   APOLLO_BASE_DIR
# Arguments:
#   $1 - key
#   $2 - conf file
# Returns:
#   None
#########################
apollo_conf_get() {
    local -r key="${1:?missing key}"
    local -r conf_file="${2:-"${APOLLO_BASE_DIR}/apollo-configservice.conf"}"

    if grep -q -E "^\s*$key " "$conf_file"; then
        grep -E "^\s*$key " "$conf_file" | awk '{print $2}'
    fi
}


########################
# Set a configuration setting value
# Globals:
#   APOLLO_BASE_DIR
# Arguments:
#   $1 - key
#   $2 - value
# Returns:
#   None
#########################
apollo_conf_set() {
    local -r key="${1:?missing key}"
    local value="${2:-}"

    # Sanitize inputs
    value="${value//\\/\\\\}"
    value="${value//&/\\&}"
    value="${value//\?/\\?}"
    value="${value//[$'\t\n\r']}"
    [[ "$value" = "" ]] && value="\"$value\""

    replace_in_file "${APOLLO_BASE_DIR}/apollo-configservice.conf" "^#*\s*${key}.*" "${key}=${value}" false
}


########################
# Apollo configure perissions
# Globals:
#   APOLLO_*
# Arguments:
#   None
# Returns:
#   None
#########################
apollo_configure_permissions() {
  debug "Ensuring expected directories/files exist"
  for dir in "${APOLLO_BASE_DIR}" "${APOLLO_LOG_FOLDER}"; do
      ensure_dir_exists "$dir"
      if am_i_root; then
          chown "$APOLLO_DAEMON_USER:$APOLLO_DAEMON_GROUP" "$dir"
      fi
  done
}


########################
# Ensure Apollo is initialized
# Globals:
#   APOLLO_*
# Arguments:
#   None
# Returns:
#   None
#########################
apollo_initialize() {
  apollo_configure_default
}


########################
# Configures Apollo permissions and general parameters
# Globals:
#   APOLLO_*
# Arguments:
#   None
# Returns:
#   None
#########################
apollo_configure_default() {
    info "Initializing Apollo configservice"

    apollo_configure_permissions

    apollo_conf_set LOG_FOLDER "${APOLLO_LOG_FOLDER}"
    apollo_conf_set LOG_FILENAME "${APOLLO_LOG_FILE}"
    
    sed -i -e "s|LOG_DIR=/opt/logs|LOG_DIR=${APOLLO_LOG_FOLDER}|g" "${APOLLO_SCRIPTS_DIR}"/startup.sh
}
