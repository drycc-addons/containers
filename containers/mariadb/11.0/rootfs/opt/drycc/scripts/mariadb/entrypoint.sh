#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/drycc/scripts/libmariadb.sh

# Load MariaDB environment variables
. /opt/drycc/scripts/mariadb-env.sh

# print_welcome_page

if [[ "$1" = "/opt/drycc/scripts/mariadb/run.sh" ]]; then
    info "** Starting MariaDB setup **"
    /opt/drycc/scripts/mariadb/setup.sh
    info "** MariaDB setup finished! **"
fi

echo ""
exec "$@"
