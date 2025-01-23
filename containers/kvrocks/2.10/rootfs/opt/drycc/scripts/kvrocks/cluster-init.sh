#!/bin/bash
# Copyright Drycc Community. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Kvrocks environment variables
. /opt/drycc/scripts/kvrocks-env.sh

# Load libraries
. /opt/drycc/scripts/libos.sh
. /opt/drycc/scripts/libkvrocks.sh

if [[ -z "$KVROCKS_NODES" ]]; then
    empty_environment_error KVROCKS_NODES
fi

if [[ -z "$KVROCKS_CONTROLLER" ]]; then
    empty_environment_error KVROCKS_CONTROLLER
fi

info "** Starting Kvrocks Cluster Init **"
# Set the kvrocks cluster init
namespace=$(kvctl list namespaces --host "${KVROCKS_CONTROLLER}" | grep "^${KVROCKS_CONTROLLER_NAMESPACE}$" || echo "")
if [[ "${namespace}" != "${KVROCKS_CONTROLLER_NAMESPACE}" ]]; then
  kvctl create namespace "${KVROCKS_CONTROLLER_NAMESPACE}" --host "${KVROCKS_CONTROLLER}"
  cluster=$(kvctl list clusters -n "${KVROCKS_CONTROLLER_NAMESPACE}" --host "${KVROCKS_CONTROLLER}" | grep "^${KVROCKS_CONTROLLER_CLUSTER}$" || echo "")
  if [[ "${cluster}" != "${KVROCKS_CONTROLLER_CLUSTER}" ]]; then
    kvctl create cluster "${KVROCKS_CONTROLLER_CLUSTER}" \
      --host "${KVROCKS_CONTROLLER}" \
      --nodes "${KVROCKS_NODES}" \
      --namespace "${KVROCKS_CONTROLLER_NAMESPACE}" \
      --replica "${KVROCKS_REPLICA}" \
      --password "${KVROCKS_MASTERAUTH}"
  fi
fi
