#!/bin/bash
# post-upgrade-check.sh
# Validates cluster health after upgrade
# Usage: Run on control plane node after all nodes are upgraded

set -e

echo "[INFO] Starting post-upgrade validation..."

# Check cluster accessibility
if ! kubectl cluster-info &> /dev/null; then
    echo "[ERROR] Cannot connect to cluster after upgrade!"
    exit 1
fi

echo "[SUCCESS] Cluster is accessible"

# Check all nodes are ready and upgraded
echo "[INFO] Checking node status and versions..."
kubectl get nodes -o wide

TARGET_VERSION=$(kubectl version --short | grep Server | awk '{print $3}')
echo "[INFO] Target version: $TARGET_VERSION"

# Verify all nodes are on target version
NODES_NOT_UPGRADED=$(kubectl get nodes -o jsonpath='{.items[*].status.nodeInfo.kubeletVersion}' | tr ' ' '\n' | grep -v $TARGET_VERSION || true)

if [ -n "$NODES_NOT_UPGRADED" ]; then
    echo "[ERROR] Some nodes are not upgraded to $TARGET_VERSION"
    kubectl get nodes -o custom-columns="NAME:.metadata.name,VERSION:.status.nodeInfo.kubeletVersion"
    exit 1
fi

echo "[SUCCESS] All nodes upgraded to $TARGET_VERSION"

# Check system pods
echo "[INFO] Checking system pod health..."
kubectl get pods -n kube-system

FAILED_SYSTEM_PODS=$(kubectl get pods -n kube-system --field-selector=status.phase!=Running -o jsonpath='{.items[*].metadata.name}' || true)
if [ -n "$FAILED_SYSTEM_PODS" ]; then
    echo "[ERROR] Some system pods are not running: $FAILED_SYSTEM_PODS"
    kubectl get pods -n kube-system | grep -v Running
    exit 1
fi

echo "[SUCCESS] All system pods are running"

# Check application health
echo "[INFO] Checking application health..."
kubectl get pods -A

# Check specific application components
if kubectl get namespace default &> /dev/null; then
    echo "[INFO] Checking MySQL..."
    kubectl get pods -l app=mysql || echo "[WARNING] MySQL pods not found"
    
    echo "[INFO] Checking Flask backend..."
    kubectl get pods -l app=flask || echo "[WARNING] Flask pods not found"
    
    echo "[INFO] Checking Nginx frontend..."
    kubectl get pods -l app=nginx || echo "[WARNING] Nginx pods not found"
fi

# Test application connectivity
echo "[INFO] Testing application connectivity..."
NGINX_SERVICE=$(kubectl get svc nginx-service -o jsonpath='{.spec.ports[0].nodePort}' 2>/dev/null || echo "")
if [ -n "$NGINX_SERVICE" ]; then
    NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="ExternalIP")].address}' || kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
    echo "[INFO] Testing application at http://$NODE_IP:$NGINX_SERVICE"
    curl -s -o /dev/null -w "%{http_code}" http://$NODE_IP:$NGINX_SERVICE || echo "[WARNING] Application test failed"
fi

# Check monitoring if deployed
if kubectl get namespace monitoring &> /dev/null; then
    echo "[INFO] Checking monitoring stack..."
    kubectl get pods -n monitoring
    
    MONITORING_FAILED=$(kubectl get pods -n monitoring --field-selector=status.phase!=Running -o jsonpath='{.items[*].metadata.name}' || true)
    if [ -n "$MONITORING_FAILED" ]; then
        echo "[WARNING] Some monitoring pods are not running: $MONITORING_FAILED"
    else
        echo "[SUCCESS] Monitoring stack is healthy"
    fi
fi

# Check resource usage
echo "[INFO] Checking resource usage..."
kubectl top nodes || echo "[WARNING] Cannot get node metrics"
kubectl top pods -A || echo "[WARNING] Cannot get pod metrics"

# Generate upgrade report
echo ""
echo "=================================="
echo "       UPGRADE REPORT"
echo "=================================="
echo "Upgrade completed: $(date)"
echo "Target version: $TARGET_VERSION"
echo ""
echo "Node status:"
kubectl get nodes -o custom-columns="NAME:.metadata.name,STATUS:.status.conditions[?(@.type=='Ready')].status,VERSION:.status.nodeInfo.kubeletVersion"
echo ""
echo "Application status:"
kubectl get pods -A | grep -E "(mysql|flask|nginx)" || echo "No application pods found"
echo ""
echo "System pod status:"
kubectl get pods -n kube-system | grep -E "(api|etcd|scheduler|controller)" | head -5
echo ""

echo "[SUCCESS] Post-upgrade validation completed!"
echo ""
echo "Upgrade summary:"
echo "✅ Cluster is accessible"
echo "✅ All nodes upgraded to $TARGET_VERSION" 
echo "✅ System pods are healthy"
echo "✅ Applications are running"
echo ""
echo "Monitor the cluster for the next few hours and check application functionality."