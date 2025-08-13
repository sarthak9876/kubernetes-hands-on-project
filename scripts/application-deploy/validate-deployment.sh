#!/bin/bash
# validate-deployment.sh
# Validates the status of all application tiers in Kubernetes.
# Usage: Run on the control plane node after deploying all tiers.

set -e

for ns in database backend frontend; do
  echo "\n[INFO] Checking pods in namespace: $ns"
  kubectl get pods -n $ns
  echo "[INFO] Checking services in namespace: $ns"
  kubectl get svc -n $ns
  echo "[INFO] Checking deployments/statefulsets in namespace: $ns"
  kubectl get deployments,statefulsets -n $ns
  echo "[INFO] Checking configmaps and secrets in namespace: $ns"
  kubectl get configmaps,secrets -n $ns
  echo "[INFO] Checking events in namespace: $ns"
  kubectl get events -n $ns --sort-by=.metadata.creationTimestamp
  echo "------------------------------------------------------"
done

echo "[INFO] Application deployment validation complete."
