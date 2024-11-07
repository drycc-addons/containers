#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load Redis environment variables
. /opt/drycc/scripts/apollo-portal-env.sh

# Load libraries
. /opt/drycc/scripts/libapollo-portal.sh

/opt/drycc/scripts/apollo-portal/setup.sh


echo ""
exec "$@"
