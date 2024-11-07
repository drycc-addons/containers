#!/bin/bash
#
# Environment configuration for apollo

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
export MODULE="${MODULE:-apollo}"
export DRYCC_DEBUG="${DRYCC_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
apollo_env_vars=(
    APOLLO_DATA_DIR
)

# System users (when running with a privileged user)
export APOLLO_DAEMON_USER="apollo"
export APOLLO_DAEMON_GROUP="apollo"

# Paths
export APOLLO_VOLUME_DIR="/drycc/apollo-configservice"
export APOLLO_BASE_DIR="${DRYCC_ROOT_DIR}/apollo-configservice"
export APOLLO_CONF_FILE="${APOLLO_BASE_DIR}/apollo-configservice.conf"
export APOLLO_SCRIPTS_DIR="${APOLLO_BASE_DIR}/scripts"
export APOLLO_LOG_FOLDER="${APOLLO_BASE_DIR}/logs"
export APOLLO_LOG_FILE="apollo-configservice.console.log"

# Custom environment variables may be defined below
