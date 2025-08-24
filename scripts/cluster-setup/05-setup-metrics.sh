#!/bin/bash
# 05-setup-metrics.sh
# Installs Metrics Server for resource monitoring.
# Usage: Run ONLY on control plane node after cluster is ready.

set -e

echo "[INFO] Installing Metrics Server..."

# Check if cluster is accessible
if ! kubectl cluster-info &> /dev/null; then
    echo "[ERROR] Cannot connect to Kubernetes cluster. Please ensure:"
    echo "1. kubeconfig is set up correctly"
    echo "2. Cluster is initialized and running"
    echo "3. CNI (Flannel) is installed and nodes are Ready"
    exit 1
fi

# Wait for nodes to be ready
echo "[INFO] Waiting for all nodes to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=300s

# Apply Metrics Server with custom configuration for self-signed certificates
echo "[INFO] Deploying Metrics Server..."
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# Patch Metrics Server to work with self-signed certificates (common in development)
echo "[INFO] Patching Metrics Server for development environment..."
kubectl patch deployment metrics-server -n kube-system --type='json' \
  -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]'

# Wait for Metrics Server to be ready
echo "[INFO] Waiting for Metrics Server to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/metrics-server -n kube-system

# Verify installation
echo "[INFO] Verifying Metrics Server installation..."
kubectl get pods -n kube-system | grep metrics-server

echo "[INFO] Metrics Server installed successfully!"
echo "[INFO] You can now use 'kubectl top nodes' and 'kubectl top pods' commands."

# Test metrics
echo "[INFO] Testing metrics collection..."
sleep 30
kubectl top nodes || echo "[WARNING] Metrics not ready yet. Wait a few more minutes and try 'kubectl top nodes'."
