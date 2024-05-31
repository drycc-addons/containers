#!/bin/bash
# Copyright Drycc Community
# SPDX-License-Identifier: APACHE-2.0
#
# drycc Seaweedfs library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/drycc/scripts/libfile.sh
. /opt/drycc/scripts/libfs.sh
. /opt/drycc/scripts/liblog.sh
. /opt/drycc/scripts/libos.sh
. /opt/drycc/scripts/libservice.sh
. /opt/drycc/scripts/libvalidations.sh


S3_CONFIG_FILE="/etc/seaweedfs/s3.json"
FILER_CONFIG_FILE="/etc/seaweedfs/filer.toml"

# Functions

########################
# Validate settings in SEAWEEDFS_* environment variables
# Globals:
#   SEAWEEDFS_*
# Arguments:
#   None
# Returns:
#   None
#########################
seaweedfs_validate() {
    info "Validating settings in SEAWEEDFS_* env vars.."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }
    check_yes_no_value() {
        if ! is_yes_no_value "${!1}" && ! is_true_false_value "${!1}"; then
            print_validation_error "An invalid value was specified in the environment variable ${1}. Valid values are: yes or no"
        fi
    }
    check_true_false_value() {
        if ! is_yes_no_value "${!1}" && ! is_true_false_value "${!1}"; then
            print_validation_error "An invalid value was specified in the environment variable ${1}. Valid values are: true or false"
        fi
    }
    check_multi_value() {
        if [[ " ${2} " != *" ${!1} "* ]]; then
            print_validation_error "The allowed values for ${1} are: ${2}"
        fi
    }
    check_conflicting_ports() {
        local -r total="$#"
        for i in $(seq 1 "$((total - 1))"); do
            for j in $(seq "$((i + 1))" "$total"); do
                if (("${!i}" == "${!j}")); then
                    print_validation_error "${!i} and ${!j} are bound to the same port"
                fi
            done
        done
    }
    check_allowed_port() {
        local port_var="${1:?missing port variable}"
        local -a validate_port_args=()
        ! am_i_root && validate_port_args+=("-unprivileged")
        validate_port_args+=("${!port_var}")
        if ! err="$(validate_port "${validate_port_args[@]}")"; then
            print_validation_error "An invalid port was specified in the environment variable ${port_var}: ${err}."
        fi
    }

    check_file_exists_or_path_writable() {
        local path_to_check="${!1}"
        local full_path_to_check
        full_path_to_check=$(realpath "${path_to_check}")
        local path_directory_to_check="${full_path_to_check%/*}"

        # check if given path is empty
        if [[ -z "${path_to_check}" ]]; then
            # not okay if the given path is empty
            print_validation_error "The variable ${1} must be set to either an existant file or a non-existant file in a writable directory."
        fi
        # check if file at given path exists
        if [[ ! -f "${path_to_check}" ]]; then
            # if the file does not exist, check if the directory is writable
            if [[ ! -w "${path_directory_to_check}" ]]; then
                # not okay if not writable
                print_validation_error "The variable ${1} must be set to either an existant file or a non-existant file in a writable directory."
            fi
            # ok if writable
        fi
        # ok if the file exists
    }

    if [ ! -f "$S3_CONFIG_FILE" ]; then
        if [[ -z "$SEAWEEDFS_ACCESS_KEY" ]]; then
            print_validation_error "You must indicate a access key"
        fi

        if [[ -z "$SEAWEEDFS_SECRET_KEY" ]]; then
            print_validation_error "You must indicate a secret key"
        fi
    fi
    if [ ! -f "$FILER_CONFIG_FILE" ]; then
        if [[ -z "$SEAWEEDFS_FILER_PATH" ]]; then
            print_validation_error "You must indicate a filer path"
        fi
    fi

    [[ "$error_code" -eq 0 ]] || return "$error_code"
}

seaweedfs_initialize(){
    if [ ! -f "$S3_CONFIG_FILE" ]; then
        cat << EOF >> "$S3_CONFIG_FILE"
{
    "identities": [
        {
            "name": "admin",
            "credentials": [
                {
                    "accessKey": "${SEAWEEDFS_ACCESS_KEY}",
                    "secretKey": "${SEAWEEDFS_SECRET_KEY}"
                }
            ],
            "actions": ["Admin", "Read", "List", "Tagging", "Write"]
        }
    ]
}
EOF
    fi
    if [ ! -f "$FILER_CONFIG_FILE" ]; then
        cat << EOF >> "$FILER_CONFIG_FILE"
[leveldb3]
# similar to leveldb2.
# each bucket has its own meta store.
enabled = true
dir = "${SEAWEEDFS_FILER_PATH}"                    # directory to store level db files
EOF
    fi
}
