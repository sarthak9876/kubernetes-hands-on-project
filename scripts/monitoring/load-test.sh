#!/bin/bash
# load-test.sh
# Runs a basic load test against the Prometheus and Grafana services.
# Usage: Run on the control plane node. Requires 'curl' installed.

set -e

NAMESPACE=monitoring
PROMETHEUS_PORT=$(kubectl get svc prometheus -n $NAMESPACE -o jsonpath='{.spec.ports[0].nodePort}')
GRAFANA_PORT=$(kubectl get svc grafana -n $NAMESPACE -o jsonpath='{.spec.ports[0].nodePort}')
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')

# Test Prometheus endpoint
PROM_URL="http://$NODE_IP:$PROMETHEUS_PORT/"
echo "[INFO] Testing Prometheus endpoint: $PROM_URL"
curl -s -o /dev/null -w "%{http_code}\n" "$PROM_URL"

# Test Grafana endpoint
GRAF_URL="http://$NODE_IP:$GRAFANA_PORT/"
echo "[INFO] Testing Grafana endpoint: $GRAF_URL"
curl -s -o /dev/null -w "%{http_code}\n" "$GRAF_URL"

echo "[INFO] Load test complete. Check HTTP status codes above (200 = OK)."
