#!/bin/bash
# pre-upgrade-check.sh
# Validates cluster health before upgrade
# Usage: Run on control plane node before starting upgrade

set -e

echo "[INFO] Starting pre-upgrade validation..."

# Check if cluster is accessible
if ! kubectl cluster-info &> /dev/null; then
    echo "[ERROR] Cannot connect to cluster. Aborting upgrade."
    exit 1
fi

echo "[SUCCESS] Cluster is accessible"

# Check node status
echo "[INFO] Checking node status..."
if kubectl get nodes | grep -q "NotReady"; then
    echo "[ERROR] Some nodes are NotReady. Fix before upgrading."
    kubectl get nodes
    exit 1
fi

echo "[SUCCESS] All nodes are Ready"

# Check system pods
echo "[INFO] Checking system pod health..."
if kubectl get pods -n kube-system | grep -E "(Error|CrashLoopBackOff|Pending)"; then
    echo "[WARNING] Some system pods have issues. Review before upgrading."
    kubectl get pods -n kube-system | grep -E "(Error|CrashLoopBackOff|Pending)"
else
    echo "[SUCCESS] All system pods are healthy"
fi

# Check application pods
echo "[INFO] Checking application pod health..."
if kubectl get pods -A | grep -E "(Error|CrashLoopBackOff|Pending)"; then
    echo "[WARNING] Some application pods have issues."
    kubectl get pods -A | grep -E "(Error|CrashLoopBackOff|Pending)"
else
    echo "[SUCCESS] All application pods are healthy"
fi

# Check etcd health
echo "[INFO] Checking etcd health..."
kubectl get pods -n kube-system | grep etcd

# Backup etcd
echo "[INFO] Creating etcd backup..."
ETCDCTL_API=3 etcdctl snapshot save /tmp/etcd-backup-$(date +%Y%m%d-%H%M%S).db \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key || echo "[WARNING] etcd backup failed"

# Check current versions
echo "[INFO] Current cluster versions:"
kubectl version --short
kubectl get nodes -o wide

# Check for monitoring
echo "[INFO] Checking monitoring stack..."
if kubectl get namespace monitoring &> /dev/null; then
    echo "[SUCCESS] Monitoring namespace exists"
    kubectl get pods -n monitoring
else
    echo "[WARNING] Monitoring not deployed. Consider deploying before upgrade."
fi

echo ""
echo "[INFO] Pre-upgrade validation completed!"
echo ""
echo "Recommendations before upgrade:"
echo "1. Ensure monitoring is deployed"
echo "2. Take application backups"
echo "3. Notify users of potential brief downtime"
echo "4. Have rollback plan ready"
echo ""
echo "Ready to proceed with upgrade? (y/n)"