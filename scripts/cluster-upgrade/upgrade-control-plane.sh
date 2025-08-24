#!/bin/bash
# upgrade-control-plane.sh
# Upgrades control plane to specified version
# Usage: ./upgrade-control-plane.sh v1.29.0

set -e

TARGET_VERSION=$1

if [ -z "$TARGET_VERSION" ]; then
    echo "Usage: $0 <target-version>"
    echo "Example: $0 v1.29.0"
    exit 1
fi

echo "[INFO] Starting control plane upgrade to $TARGET_VERSION..."

# Source node aliases if available
[ -f ~/.k8s-node-aliases ] && source ~/.k8s-node-aliases

# Get control plane node name
CONTROL_PLANE_NODE=$(kubectl get nodes --selector='node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].metadata.name}')

echo "[INFO] Control plane node: $CONTROL_PLANE_NODE"

# Check if applications are running
echo "[INFO] Checking application status before upgrade..."
kubectl get pods -A | grep -v kube-system | grep Running

# Start monitoring (if available)
if kubectl get namespace monitoring &> /dev/null; then
    echo "[INFO] Monitoring available. Monitor dashboard during upgrade."
fi

# Drain control plane (but allow system pods)
echo "[INFO] Draining control plane node..."
kubectl drain $CONTROL_PLANE_NODE --ignore-daemonsets --delete-emptydir-data --force

# Unhold kubeadm
echo "[INFO] Unholding kubeadm package..."
sudo apt-mark unhold kubeadm

# Upgrade kubeadm
echo "[INFO] Upgrading kubeadm..."
VERSION=$(echo $TARGET_VERSION | sed 's/v//')
sudo apt update
sudo apt install -y kubeadm=${VERSION}-1.1

# Check upgrade plan
echo "[INFO] Checking upgrade plan..."
sudo kubeadm upgrade plan

# Apply upgrade
echo "[INFO] Applying upgrade to $TARGET_VERSION..."
sudo kubeadm upgrade apply $TARGET_VERSION -y

# Upgrade kubelet and kubectl
echo "[INFO] Upgrading kubelet and kubectl..."
sudo apt-mark unhold kubelet kubectl
sudo apt install -y kubelet=${VERSION}-1.1 kubectl=${VERSION}-1.1
sudo apt-mark hold kubeadm kubelet kubectl

# Restart kubelet
sudo systemctl daemon-reload
sudo systemctl restart kubelet

# Uncordon control plane
echo "[INFO] Uncordoning control plane node..."
kubectl uncordon $CONTROL_PLANE_NODE

# Wait for control plane to be ready
echo "[INFO] Waiting for control plane to be ready..."
kubectl wait --for=condition=Ready node/$CONTROL_PLANE_NODE --timeout=300s

# Verify upgrade
echo "[INFO] Verifying control plane upgrade..."
kubectl get nodes
kubectl version --short

echo ""
echo "[SUCCESS] Control plane upgraded to $TARGET_VERSION!"
echo ""
echo "Next steps:"
echo "1. Verify applications are still running"
echo "2. Upgrade worker nodes one by one"
echo "3. Run post-upgrade validation"