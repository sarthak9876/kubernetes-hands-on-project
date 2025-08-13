#!/bin/bash
# health-check.sh
# Checks the health of Prometheus and Grafana pods in the monitoring namespace.
# Usage: Run on the control plane node.

set -e

NAMESPACE=monitoring

echo "[INFO] Checking Prometheus pod(s):"
kubectl get pods -n $NAMESPACE -l app=prometheus
kubectl describe pods -n $NAMESPACE -l app=prometheus

echo "[INFO] Checking Grafana pod(s):"
kubectl get pods -n $NAMESPACE -l app=grafana
kubectl describe pods -n $NAMESPACE -l app=grafana

echo "[INFO] Monitoring health check complete."
