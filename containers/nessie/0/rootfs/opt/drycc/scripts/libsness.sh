#!/bin/bash
# Copyright Drycc Community
# SPDX-License-Identifier: APACHE-2.0
#
# Drycc NESSIE library

# shellcheck disable=SC1091

# Load Libraries
. /opt/drycc/scripts/libservice.sh
. /opt/drycc/scripts/libos.sh
. /opt/drycc/scripts/libvalidations.sh
. /opt/drycc/scripts/libfile.sh

# Functions

########################
# Validate settings in NESSIE_* env vars
# Globals:
#   NESSIE_*
# Arguments:
#   None
# Returns:
#   None
#########################
nessie_validate() {
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    # Validate nessie mode
    case "$NESSIE_MODE" in
    master | worker) ;;

    *)
        print_validation_error "Invalid mode $NESSIE_MODE. Supported types are 'master/worker'"
        ;;
    esac

    # Validate metrics enabled
    if ! is_true_false_value "$NESSIE_METRICS_ENABLED"; then
        print_validation_error "Valid values for NESSIE_METRICS_ENABLED are: true or false"
    fi

    # Validate worker node inputs
    if [[ "$NESSIE_MODE" == "worker" ]]; then
        if [[ -z "$NESSIE_MASTER_URL" ]]; then
            print_validation_error "For worker nodes you need to specify the NESSIE_MASTER_URL"
        fi
    fi

    # Validate SSL parameters
    if is_boolean_yes "$NESSIE_SSL_ENABLED"; then
        if [[ -z "$NESSIE_SSL_KEY_PASSWORD" ]]; then
            print_validation_error "If you enable SSL configuration, you must provide the password to the private key in the key store."
        fi
        if [[ -z "$NESSIE_SSL_KEYSTORE_PASSWORD" ]]; then
            print_validation_error "If you enable SSL configuration, you must provide the password to the key store."
        fi
        if [[ -z "$NESSIE_SSL_TRUSTSTORE_PASSWORD" ]]; then
            print_validation_error "If you enable SSL configuration, you must provide the password to the trust store."
        fi
        if [[ ! -f "${NESSIE_SSL_KEYSTORE_FILE}" ]]; then
            print_validation_error "If you enable SSL configuration, you must mount your keystore file and specify the location in NESSIE_SSL_KEYSTORE_FILE. Default value: ${NESSIE_SSL_KEYSTORE_FILE}"
        fi
        if [[ ! -f "${NESSIE_SSL_TRUSTSTORE_FILE}" ]]; then
            print_validation_error "If you enable SSL configuration, you must mount your trutstore file and specify the location in NESSIE_SSL_TRUSTSTORE_FILE. Default value: ${NESSIE_SSL_TRUSTSTORE_FILE}\""
        fi
    fi

    # Validate RPC parameters
    if is_boolean_yes "$NESSIE_RPC_AUTHENTICATION_ENABLED"; then
        if [[ -z "$NESSIE_RPC_AUTHENTICATION_SECRET" ]]; then
            print_validation_error "If you enable RPC authentication, you must provide the RPC authentication secret."
        fi
    fi

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Configure NESSIE RPC Authentication (https://nessie.apache.org/docs/latest/security.html#authentication)
# Globals:
#   NESSIE_*
# Arguments:
#   None
# Returns:
#   None
#########################
nessie_generate_conf_file() {
    info "Generating NESSIE configuration file..."
    mv "${NESSIE_CONF_DIR}/nessie-defaults.conf.template" "${NESSIE_CONF_DIR}/nessie-defaults.conf"
}

########################
# Configure NESSIE RPC Authentication (https://nessie.apache.org/docs/latest/security.html#authentication)
# Globals:
#   NESSIE_*
# Arguments:
#   None
# Returns:
#   None
#########################
nessie_enable_rpc_authentication() {
    info "Configuring NESSIE RPC authentication..."

    echo "# NESSIE RPC Authentication settings" >>"${NESSIE_CONF_DIR}/nessie-defaults.conf"
    nessie_conf_set nessie.authenticate "true"
    nessie_conf_set nessie.authenticate.secret "$NESSIE_RPC_AUTHENTICATION_SECRET"
}

########################
# Configure NESSIE RPC Encryption (https://nessie.apache.org/docs/latest/security.html#encryption)
# Globals:
#   NESSIE_*
# Arguments:
#   None
# Returns:
#   None
#########################
nessie_enable_rpc_encryption() {
    info "Configuring NESSIE RPC encryption..."

    echo "# NESSIE RPC Encryption settings" >>"${NESSIE_CONF_DIR}/nessie-defaults.conf"
    nessie_conf_set nessie.network.crypto.enabled "true"
    nessie_conf_set nessie.network.crypto.keyLength "128"
}

########################
# Configure NESSIE Local Storage Encryption (https://nessie.apache.org/docs/latest/security.html#local-storage-encryption)
# Globals:
#   NESSIE_*
# Arguments:
#   None
# Returns:
#   None
#########################
nessie_enable_local_storage_encryption() {
    info "Configuring NESSIE local storage encryption..."

    echo "# NESSIE Local Storate Encryption settings" >>"${NESSIE_CONF_DIR}/nessie-defaults.conf"
    nessie_conf_set nessie.io.encryption.enabled "true"
    nessie_conf_set nessie.io.encryption.keySizeBits "128"
}

########################
# Enable metrics
# Globals:
#   NESSIE_*
# Arguments:
#   None
# Returns:
#   None
#########################
nessie_enable_metrics() {
    info "Enabling metrics..."

    mv "${NESSIE_CONF_DIR}/metrics.properties.template" "${NESSIE_CONF_DIR}/metrics.properties"

    nessie_metrics_conf_set "\*.sink.prometheusServlet.class" "org.apache.nessie.metrics.sink.PrometheusServlet"
    nessie_metrics_conf_set "\*.sink.prometheusServlet.path" "/metrics"
    nessie_metrics_conf_set "master.sink.prometheusServlet.path" "/metrics"
    nessie_metrics_conf_set "applications.sink.prometheusServlet.path" "/metrics"
}

########################
# Configure NESSIE SSL (https://nessie.apache.org/docs/latest/security.html#ssl-configuration)
# Globals:
#   NESSIE_*
# Arguments:
#   None
# Returns:
#   None
#########################
nessie_enable_ssl() {
    info "Configuring NESSIE SSL..."

    echo "# NESSIE SSL settings" >>"${NESSIE_CONF_DIR}/nessie-defaults.conf"
    nessie_conf_set nessie.ssl.enabled "true"
    if ! is_empty_value "${NESSIE_WEBUI_SSL_PORT}"; then
        nessie_conf_set nessie.ssl.standalone.port "${NESSIE_WEBUI_SSL_PORT}"
    fi
    nessie_conf_set nessie.ssl.keyPassword "${NESSIE_SSL_KEY_PASSWORD}"
    nessie_conf_set nessie.ssl.keyStore "${NESSIE_SSL_KEYSTORE_FILE}"
    nessie_conf_set nessie.ssl.keyStorePassword "${NESSIE_SSL_KEYSTORE_PASSWORD}"
    nessie_conf_set nessie.ssl.keyStoreType "JKS"
    nessie_conf_set nessie.ssl.protocol "${NESSIE_SSL_PROTOCOL}"
    if is_boolean_yes "$NESSIE_SSL_NEED_CLIENT_AUTH"; then
        nessie_conf_set nessie.ssl.needClientAuth "true"
    fi
    nessie_conf_set nessie.ssl.trustStore "${NESSIE_SSL_TRUSTSTORE_FILE}"
    nessie_conf_set nessie.ssl.trustStorePassword "${NESSIE_SSL_TRUSTSTORE_PASSWORD}"
    nessie_conf_set nessie.ssl.trustStoreType "JKS"
}

########################
# Set a metrics configuration setting value
# Globals:
#   NESSIE_CONF_DIR
# Arguments:
#   $1 - key
#   $2 - value
# Returns:
#   None
#########################
nessie_metrics_conf_set() {
    local -r key="${1:?missing key}"
    local value="${2:-}"

    # Sanitize inputs
    value="${value//\\/\\\\}"
    value="${value//&/\\&}"
    value="${value//\?/\\?}"
    [[ "$value" = "" ]] && value="\"$value\""

    replace_in_file "${NESSIE_CONF_DIR}/metrics.properties" "^#*\s*${key}.*" "${key}=${value}" false
}

########################
# Set a configuration setting value
# Globals:
#   NESSIE_BASE_DIR
# Arguments:
#   $1 - key
#   $2 - value
# Returns:
#   None
#########################
nessie_conf_set() {
    # TODO: improve this. Substitute action?
    local key="${1:?missing key}"
    local value="${2:-}"

    # Sanitize inputs
    value="${value//\\/\\\\}"
    value="${value//&/\\&}"

    [[ "$value" = "" ]] && value="\"$value\""

    echo "$key $value" >>"${NESSIE_BASE_DIR}/conf/nessie-defaults.conf"
}

########################
# Ensure NESSIE is initialized
# Globals:
#   NESSIE_*
# Arguments:
#   None
# Returns:
#   None
#########################
nessie_initialize() {
    ensure_dir_exists "$NESSIE_WORK_DIR"
    am_i_root && chown "$NESSIE_DAEMON_USER:$NESSIE_DAEMON_GROUP" "$NESSIE_WORK_DIR"
    if [[ ! -f "$NESSIE_CONF_FILE" ]]; then
        # Generate default config file
        nessie_generate_conf_file
        # Enable RPC authentication and encryption
        if is_boolean_yes "$NESSIE_RPC_AUTHENTICATION_ENABLED"; then
            nessie_enable_rpc_authentication
            #  For encryption to be enabled, RPC authentication must also be enabled and properly configured
            if is_boolean_yes "$NESSIE_RPC_ENCRYPTION_ENABLED"; then
                nessie_enable_rpc_encryption
            fi
        fi

        # Enable RPC authentication and encryption
        if is_boolean_yes "$NESSIE_LOCAL_STORAGE_ENCRYPTION_ENABLED"; then
            nessie_enable_local_storage_encryption
        fi

        # Enable SSL configuration
        if is_boolean_yes "$NESSIE_SSL_ENABLED"; then
            nessie_enable_ssl
        fi

        # Enable metrics
        if is_boolean_yes "$NESSIE_METRICS_ENABLED"; then
            nessie_enable_metrics
        fi
    else
        info "Detected mounted configuration file..."
    fi
}

########################
# Run custom initialization scripts
# Globals:
#   NESSIE_*
# Arguments:
#   None
# Returns:
#   None
#########################
nessie_custom_init_scripts() {
    if [[ -n $(find "${NESSIE_INITSCRIPTS_DIR}/" -type f -regex ".*\.sh") ]]; then
        info "Loading user's custom files from $NESSIE_INITSCRIPTS_DIR ..."
        local -r tmp_file="/tmp/filelist"
        find "${NESSIE_INITSCRIPTS_DIR}/" -type f -regex ".*\.sh" | sort >"$tmp_file"
        while read -r f; do
            case "$f" in
            *.sh)
                if [[ -x "$f" ]]; then
                    debug "Executing $f"
                    "$f"
                else
                    debug "Sourcing $f"
                    # shellcheck disable=SC1090
                    . "$f"
                fi
                ;;
            *)
                debug "Ignoring $f"
                ;;
            esac
        done <$tmp_file
        rm -f "$tmp_file"
    else
        info "No custom scripts in $NESSIE_INITSCRIPTS_DIR"
    fi
}
