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
kubectl label node $CONTROL_PLANE_NODE node-role.kubernetes.io/control-plane=k8s-control-plane --overwrite
kubectl annotate node $CONTROL_PLANE_NODE node.alpha.kubernetes.io/display-name=k8s-control-plane --overwrite

# Rename worker nodes
WORKER_COUNT=1
for worker in "${WORKER_NODES[@]}"; do
    echo "[INFO] Renaming worker node $worker to k8s-worker-$WORKER_COUNT..."
    kubectl label node $worker node-role.kubernetes.io/worker=k8s-worker-$WORKER_COUNT --overwrite
    kubectl annotate node $worker node.alpha.kubernetes.io/display-name=k8s-worker-$WORKER_COUNT --overwrite
    ((WORKER_COUNT++))
done

echo ""
echo "[INFO] Creating node aliases for easier reference..."

# Create a helper function to use friendly names
cat << 'EOF' > /tmp/node-aliases.sh
#!/bin/bash
# Node aliases for easier kubectl commands

alias kubectl-drain-control-plane="kubectl drain $CONTROL_PLANE_NODE"
alias kubectl-drain-worker-1="kubectl drain ${WORKER_NODES[0]}"
alias kubectl-drain-worker-2="kubectl drain ${WORKER_NODES[1]:-notfound}"

echo "Available aliases:"
echo "  kubectl-drain-control-plane"
echo "  kubectl-drain-worker-1" 
echo "  kubectl-drain-worker-2"
echo ""
echo "Or use the actual node names:"
echo "  Control plane: $CONTROL_PLANE_NODE"
echo "  Worker 1: ${WORKER_NODES[0]}"
echo "  Worker 2: ${WORKER_NODES[1]:-notfound}"
EOF

source /tmp/node-aliases.sh

echo ""
echo "[SUCCESS] Nodes renamed! New node list:"
kubectl get nodes

echo ""
echo "[INFO] You can now use commands like:"
echo "  kubectl drain k8s-worker-1"
echo "  kubectl describe node k8s-control-plane"

