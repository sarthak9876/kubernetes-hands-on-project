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
kubectl cluster-info

# Deploy Flannel CNI (updated URL)
echo "[INFO] Deploying Flannel CNI..."
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

echo "[INFO] Flannel CNI deployed for pod networking."
echo "[INFO] Waiting for nodes to become ready..."
kubectl get nodes
