#!/bin/bash
#
# Environment configuration for fluentbit

# The values for all environment variables will be set in the below order of precedence
# 1. Custom environment variables defined below after Bitnami defaults
# 2. Constants defined in this file (environment variables with no default), i.e. DRYCC_ROOT_DIR
# 3. Environment variables overridden via external files using *_FILE variables (see below)
# 4. Environment variables set externally (i.e. current Bash context/Dockerfile/userdata)

# Load logging library
# shellcheck disable=SC1090,SC1091
. /opt/drycc/scripts/liblog.sh

export DRYCC_ROOT_DIR="/opt/drycc"
export DRYCC_VOLUME_DIR="/drycc"

# Logging configuration
export MODULE="${MODULE:-fluentbit}"
export DRYCC_DEBUG="${DRYCC_DEBUG:-false}"

# System users (when running with a privileged user)
export FLUENTBIT_DAEMON_USER="fluentbit"
export FLUENTBIT_DAEMON_GROUP="fluentbit"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
fluentbit_env_vars=(
    FLUENTBIT_EXTRA_ARGS
)
for env_var in "${fluentbit_env_vars[@]}"; do
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
unset fluentbit_env_vars
