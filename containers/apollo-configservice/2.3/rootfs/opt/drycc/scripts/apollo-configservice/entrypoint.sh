#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load Redis environment variables
. /opt/drycc/scripts/apollo-configservice-env.sh

# Load libraries
. /opt/drycc/scripts/libapollo-configservice.sh

/opt/drycc/scripts/apollo-configservice/setup.sh


echo ""
exec "$@"
