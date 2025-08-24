#!/bin/bash
# 06-troubleshoot-cluster.sh
# Diagnoses and fixes common cluster issues after CNI installation.
# Usage: Run on control plane node when cluster is not responding.

set -e

echo "[INFO] Starting cluster troubleshooting..."

# Check if running as regular user
if [ "$EUID" -eq 0 ]; then
    echo "[ERROR] Do not run this script as root. Run as regular user with sudo access."
    exit 1
fi

# Function to check service status
check_service() {
    local service=$1
    echo "[INFO] Checking $service status..."
    sudo systemctl status $service --no-pager || true
    echo ""
}

# Function to restart kubelet
restart_kubelet() {
    echo "[INFO] Restarting kubelet..."
    sudo systemctl daemon-reload
    sudo systemctl restart kubelet
    sleep 10
    sudo systemctl status kubelet --no-pager
}

# 1. Check container runtime
echo "=== Container Runtime Check ==="
if systemctl is-active --quiet docker; then
    check_service docker
elif systemctl is-active --quiet containerd; then
    check_service containerd
else
    echo "[ERROR] No container runtime is running!"
    exit 1
fi

# 2. Check kubelet
echo "=== Kubelet Check ==="
check_service kubelet

# 3. Check if kubeconfig exists
echo "=== Kubeconfig Check ==="
if [ ! -f $HOME/.kube/config ]; then
    echo "[INFO] Setting up kubeconfig..."
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    echo "[INFO] Kubeconfig set up successfully."
else
    echo "[INFO] Kubeconfig exists."
fi

# 4. Try to connect to cluster
echo "=== Cluster Connectivity Check ==="
if kubectl cluster-info &> /dev/null; then
    echo "[INFO] Cluster is accessible."
    kubectl get nodes
    kubectl get pods -A
else
    echo "[WARNING] Cannot connect to cluster. Attempting recovery..."
    
    # Restart kubelet
    restart_kubelet
    
    # Wait and try again
    sleep 30
    if kubectl cluster-info &> /dev/null; then
        echo "[INFO] Cluster recovered after kubelet restart."
        kubectl get nodes
    else
        echo "[ERROR] Cluster still not accessible. Manual intervention required."
        echo ""
        echo "Manual recovery steps:"
        echo "1. Check kubelet logs: sudo journalctl -u kubelet -f"
        echo "2. Check API server logs: sudo crictl logs \$(sudo crictl ps --name kube-apiserver -q)"
        echo "3. Check etcd logs: sudo crictl logs \$(sudo crictl ps --name etcd -q)"
        echo "4. If all else fails, reset and reinitialize:"
        echo "   sudo kubeadm reset"
        echo "   ./scripts/cluster-setup/03-init-cluster.sh"
        exit 1
    fi
fi

# 5. Check for problem pods
echo "=== Problem Pods Check ==="
echo "Checking for CrashLoopBackOff or Pending pods..."
kubectl get pods -A | grep -E "(CrashLoopBackOff|Pending|Error|ImagePullBackOff)" || echo "No problem pods found."

# 6. Check Flannel specifically
echo "=== Flannel Check ==="
if kubectl get ns kube-flannel &> /dev/null; then
    echo "Flannel namespace exists. Checking pods..."
    kubectl get pods -n kube-flannel
    
    # Check if Flannel pods are running
    if kubectl get pods -n kube-flannel | grep -q "Running"; then
        echo "[INFO] Flannel pods are running."
    else
        echo "[WARNING] Flannel pods not running. Checking logs..."
        kubectl logs -n kube-flannel -l app=flannel --tail=50 || true
    fi
else
    echo "[WARNING] Flannel not installed. Installing..."
    kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
fi

echo ""
echo "=== Troubleshooting Summary ==="
echo "Current cluster status:"
kubectl get nodes 2>/dev/null || echo "Cannot get nodes - cluster not accessible"
echo ""
echo "If issues persist, check the logs mentioned above or reset the cluster."