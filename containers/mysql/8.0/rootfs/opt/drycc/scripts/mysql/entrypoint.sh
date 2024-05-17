#!/bin/bash
# Copyright Drycc Community
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/drycc/scripts/libdrycc.sh
. /opt/drycc/scripts/libmysql.sh

# Load MySQL environment variables
. /opt/drycc/scripts/mysql-env.sh

print_welcome_page

if [[ "$1" = "/opt/drycc/scripts/mysql/run.sh" ]]; then
    info "** Starting MySQL setup **"
    /opt/drycc/scripts/mysql/setup.sh
    info "** MySQL setup finished! **"
fi

echo ""
exec "$@"
