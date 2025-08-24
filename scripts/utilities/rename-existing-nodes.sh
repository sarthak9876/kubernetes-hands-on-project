#!/bin/bash
# rename-existing-nodes.sh
# Renames existing Kubernetes nodes to meaningful names
# Usage: Run on control plane node after cluster is running

set -e

echo "[INFO] Current nodes:"
kubectl get nodes

echo ""
echo "[INFO] Renaming nodes to meaningful names..."

# Get current node names and their roles
CONTROL_PLANE_NODE=$(kubectl get nodes --selector='node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].metadata.name}')
WORKER_NODES=($(kubectl get nodes --selector='!node-role.kubernetes.io/control-plane' -o jsonpath='{.items[*].metadata.name}'))

echo "[INFO] Control plane node: $CONTROL_PLANE_NODE"
echo "[INFO] Worker nodes: ${WORKER_NODES[@]}"

# Rename control plane node
echo "[INFO] Renaming control plane node..."
kubectl patch node $CONTROL_PLANE_NODE -p '{"metadata":{"labels":{"kubernetes.io/hostname":"k8s-control-plane"}}}'

# Rename worker nodes
WORKER_COUNT=1
for worker in "${WORKER_NODES[@]}"; do
    echo "[INFO] Renaming worker node $worker to k8s-worker-$WORKER_COUNT..."
    kubectl patch node $worker -p "{\"metadata\":{\"labels\":{\"kubernetes.io/hostname\":\"k8s-worker-$WORKER_COUNT\"}}}"
    ((WORKER_COUNT++))
done

echo ""
echo "[SUCCESS] Nodes renamed! New node list:"
kubectl get nodes

echo ""
echo "[INFO] You can now use commands like:"
echo "  kubectl drain k8s-worker-1"
echo "  kubectl describe node k8s-control-plane"