#!/bin/bash
# 04-setup-networking.sh
# Deploys Flannel CNI for pod networking in Kubernetes.
# Usage: Run ONLY on the control plane node after cluster initialization.

set -e

# Deploy Flannel CNI
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

echo "[INFO] Flannel CNI deployed for pod networking."
