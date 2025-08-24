#!/bin/bash
# 03-init-cluster.sh
# Initializes Kubernetes control plane using kubeadm.
# Usage: Run ONLY on the control plane node after installing container runtime.

set -e

echo "[INFO] Initializing Kubernetes control plane..."

# Detect container runtime
if systemctl is-active --quiet docker; then
    CONTAINER_RUNTIME="docker"
    echo "[INFO] Detected Docker as container runtime"
elif systemctl is-active --quiet containerd; then
    CONTAINER_RUNTIME="containerd"
    echo "[INFO] Detected containerd as container runtime"
else
    echo "[ERROR] No container runtime detected. Please install Docker or containerd first."
    exit 1
fi

# Initialize cluster with appropriate configuration
if [ "$CONTAINER_RUNTIME" = "docker" ]; then
    # Docker configuration
    sudo kubeadm init \
        --pod-network-cidr=10.244.0.0/16 \
        --cri-socket=unix:///var/run/dockershim.sock \
        --kubernetes-version=v1.28.0
elif [ "$CONTAINER_RUNTIME" = "containerd" ]; then
    # containerd configuration
    sudo kubeadm init \
        --pod-network-cidr=10.244.0.0/16 \
        --cri-socket=unix:///run/containerd/containerd.sock \
        --kubernetes-version=v1.28.0
fi

echo "[INFO] Control plane initialized successfully!"
echo ""
echo "IMPORTANT: Save the 'kubeadm join' command that appears above!"
echo "You'll need it to join worker nodes to the cluster."
echo ""
echo "Next steps:"
echo "1. Set up kubeconfig (run as regular user):"
echo "   mkdir -p \$HOME/.kube"
echo "   sudo cp -i /etc/kubernetes/admin.conf \$HOME/.kube/config"
echo "   sudo chown \$(id -u):\$(id -g) \$HOME/.kube/config"
echo ""
echo "2. Install CNI (Flannel): ./scripts/cluster-setup/04-setup-networking.sh"
