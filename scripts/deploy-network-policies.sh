#!/usr/bin/env bash

# See documentation for more information on network policies:
# https://kubernetes.io/docs/concepts/services-networking/network-policies/

# Initialization
SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR"/init-env.sh

# Apply the default policies "deny-all"
oc apply --filename ./test-target/ingress-deny-all-np.yaml --namespace "$TNF_EXAMPLE_CNF_NAMESPACE"
oc apply --filename ./test-target/egress-deny-all-np.yaml --namespace "$TNF_EXAMPLE_CNF_NAMESPACE"

# Apply policies to allow pod-to-pod communication (aka make the ping test work)
oc apply --filename ./test-target/pod-to-pod-np.yaml --namespace "$TNF_EXAMPLE_CNF_NAMESPACE"
