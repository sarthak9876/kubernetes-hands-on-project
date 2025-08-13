#!/bin/bash
# resource-monitor.sh
# Monitors resource usage of pods in the monitoring namespace using metrics server.
# Usage: Run on the control plane node.

set -e

NAMESPACE=monitoring

echo "[INFO] Resource usage for monitoring pods:"
kubectl top pods -n $NAMESPACE

echo "[INFO] Resource usage for monitoring nodes:"
kubectl top nodes

echo "[INFO] Resource monitoring complete."
