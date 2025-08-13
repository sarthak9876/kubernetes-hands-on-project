#!/bin/bash
# cleanup.sh
# Cleans up unused resources and temporary files in the cluster and local system.
# Usage: Run on the control plane node.

set -e

# Delete completed pods in all namespaces
kubectl get pods --all-namespaces --field-selector=status.phase=Succeeded -o json | \
  jq -r '.items[].metadata | "kubectl delete pod " + .name + " -n " + .namespace' | bash

# Remove dangling Docker images (if Docker is installed)
if command -v docker &> /dev/null; then
  docker image prune -f
fi

# Remove unused containerd images (if containerd is installed)
if command -v ctr &> /dev/null; then
  sudo ctr image prune
fi

echo "[INFO] Cleanup complete."
