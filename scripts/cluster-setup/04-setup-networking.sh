#!/bin/bash
# 04-setup-networking.sh
# Deploys Flannel CNI for pod networking in Kubernetes.
# Usage: Run ONLY on the control plane node after cluster initialization.

set -e

# Check if running as regular user (not root)
if [ "$EUID" -eq 0 ]; then
    echo "[ERROR] Do not run this script as root. Run as regular user with sudo access."
    exit 1
fi

# Set up kubeconfig for regular user (if not already done)
if [ ! -f $HOME/.kube/config ]; then
    echo "[INFO] Setting up kubeconfig for regular user..."
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    echo "[INFO] Kubeconfig set up successfully."
fi

# Check if cluster is accessible
echo "[INFO] Checking cluster connectivity..."
if ! kubectl cluster-info &> /dev/null; then
    echo "[ERROR] Cannot connect to cluster. Checking kubelet status..."
    sudo systemctl status kubelet --no-pager
    echo "[ERROR] Please ensure cluster is properly initialized before running this script."
    exit 1
fi

# Check current node status
echo "[INFO] Current node status:"
kubectl get nodes -o wide

# Deploy Flannel CNI (updated URL)
echo "[INFO] Deploying Flannel CNI..."
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

# Wait for Flannel pods to be created
echo "[INFO] Waiting for Flannel pods to be created..."
sleep 30

# Check Flannel pod status
echo "[INFO] Checking Flannel pod status..."
kubectl get pods -n kube-flannel

# Wait for nodes to become ready (with timeout)
echo "[INFO] Waiting for nodes to become ready (this may take a few minutes)..."
kubectl wait --for=condition=Ready nodes --all --timeout=300s || {
    echo "[WARNING] Nodes not ready after 5 minutes. Checking pod status..."
    kubectl get pods -A
    echo ""
    echo "Troubleshooting steps:"
    echo "1. Check kubelet logs: sudo journalctl -u kubelet -f"
    echo "2. Check container runtime: sudo systemctl status docker (or containerd)"
    echo "3. Check Flannel logs: kubectl logs -n kube-flannel -l app=flannel"
    exit 1
}
