#!/bin/bash
# 05-setup-metrics.sh
# Deploys the Kubernetes metrics server for resource monitoring.
# Usage: Run ONLY on the control plane node.

set -e

# Deploy metrics server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

echo "[INFO] Metrics server deployed for resource monitoring."
