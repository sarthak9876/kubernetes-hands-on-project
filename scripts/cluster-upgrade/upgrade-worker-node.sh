#!/bin/bash
# upgrade-worker-node.sh
# Upgrades specified worker node
# Usage: ./upgrade-worker-node.sh <worker-number>

set -e

WORKER_NUM=$1

if [ -z "$WORKER_NUM" ]; then
    echo "Usage: $0 <worker-number>"
    echo "Example: $0 1  # upgrades worker-1"
    echo "Example: $0 2  # upgrades worker-2"
    exit 1
fi

# Source node aliases if available
[ -f ~/.k8s-node-aliases ] && source ~/.k8s-node-aliases

# Get worker node name
WORKER_NODES=($(kubectl get nodes --selector='!node-role.kubernetes.io/control-plane' -o jsonpath='{.items[*].metadata.name}'))
WORKER_INDEX=$((WORKER_NUM - 1))
WORKER_NODE=${WORKER_NODES[$WORKER_INDEX]}

if [ -z "$WORKER_NODE" ]; then
    echo "[ERROR] Worker node $WORKER_NUM not found"
    echo "Available workers: ${WORKER_NODES[@]}"
    exit 1
fi

echo "[INFO] Upgrading worker node $WORKER_NUM: $WORKER_NODE"

# Check application pods on this node
echo "[INFO] Checking pods on worker node $WORKER_NODE..."
kubectl get pods --all-namespaces --field-selector spec.nodeName=$WORKER_NODE

# Drain the worker node
echo "[INFO] Draining worker node $WORKER_NODE..."
kubectl drain $WORKER_NODE --ignore-daemonsets --delete-emptydir-data --force

# Wait a moment for pods to reschedule
echo "[INFO] Waiting for pods to reschedule..."
sleep 30

# Verify applications are still running on other nodes
echo "[INFO] Verifying applications are running on other nodes..."
kubectl get pods -A | grep -v $WORKER_NODE | grep Running

echo ""
echo "[INFO] Worker node $WORKER_NODE drained successfully!"
echo ""
echo "Now SSH to the worker node and run:"
echo ""
echo "# Unhold packages"
echo "sudo apt-mark unhold kubeadm kubelet kubectl"
echo ""
echo "# Get target version from control plane"
echo "TARGET_VERSION=\$(kubectl version --short | grep Server | awk '{print \$3}')"
echo "VERSION=\$(echo \$TARGET_VERSION | sed 's/v//')"
echo ""
echo "# Upgrade packages"
echo "sudo apt update"
echo "sudo apt install -y kubeadm=\${VERSION}-1.1 kubelet=\${VERSION}-1.1 kubectl=\${VERSION}-1.1"
echo ""
echo "# Upgrade node"
echo "sudo kubeadm upgrade node"
echo ""
echo "# Restart kubelet"
echo "sudo systemctl daemon-reload"
echo "sudo systemctl restart kubelet"
echo ""
echo "# Hold packages"
echo "sudo apt-mark hold kubeadm kubelet kubectl"
echo ""
echo "After upgrading on the worker node, press Enter to uncordon..."
read -p "Press Enter when worker upgrade is complete..."

# Uncordon the worker node
echo "[INFO] Uncordoning worker node $WORKER_NODE..."
kubectl uncordon $WORKER_NODE

# Wait for node to be ready
echo "[INFO] Waiting for worker node to be ready..."
kubectl wait --for=condition=Ready node/$WORKER_NODE --timeout=300s

# Verify upgrade
echo "[INFO] Verifying worker node upgrade..."
kubectl get nodes
kubectl describe node $WORKER_NODE | grep "Kubelet Version"

echo ""
echo "[SUCCESS] Worker node $WORKER_NUM upgraded successfully!"
echo ""
echo "Next steps:"
echo "1. Verify applications are scheduled back to this node"
echo "2. Repeat for remaining worker nodes"
echo "3. Run post-upgrade validation when all nodes are upgraded"