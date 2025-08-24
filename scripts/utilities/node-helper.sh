#!/bin/bash
# node-helper.sh
# Creates aliases and helper functions for easier node management
# Usage: Run on control plane node, then source the output

set -e

echo "[INFO] Creating node management helpers..."

# Get current node names and their roles
CONTROL_PLANE_NODE=$(kubectl get nodes --selector='node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].metadata.name}')
WORKER_NODES=($(kubectl get nodes --selector='!node-role.kubernetes.io/control-plane' -o jsonpath='{.items[*].metadata.name}'))

echo "[INFO] Control plane node: $CONTROL_PLANE_NODE"
echo "[INFO] Worker nodes: ${WORKER_NODES[@]}"

# Create aliases file
cat << EOF > ~/.k8s-node-aliases
#!/bin/bash
# Kubernetes Node Aliases
# Source this file: source ~/.k8s-node-aliases

# Node variables
export K8S_CONTROL_PLANE="$CONTROL_PLANE_NODE"
export K8S_WORKER_1="${WORKER_NODES[0]}"
export K8S_WORKER_2="${WORKER_NODES[1]:-}"

# Aliases for common operations
alias k8s-nodes="kubectl get nodes"
alias k8s-drain-control="kubectl drain \$K8S_CONTROL_PLANE --ignore-daemonsets"
alias k8s-drain-worker1="kubectl drain \$K8S_WORKER_1 --ignore-daemonsets"
alias k8s-drain-worker2="kubectl drain \$K8S_WORKER_2 --ignore-daemonsets"
alias k8s-uncordon-control="kubectl uncordon \$K8S_CONTROL_PLANE"
alias k8s-uncordon-worker1="kubectl uncordon \$K8S_WORKER_1"
alias k8s-uncordon-worker2="kubectl uncordon \$K8S_WORKER_2"

# Helper functions
k8s-show-nodes() {
    echo "Node Mappings:"
    echo "  Control Plane: \$K8S_CONTROL_PLANE"
    echo "  Worker 1: \$K8S_WORKER_1"
    echo "  Worker 2: \$K8S_WORKER_2"
    echo ""
    kubectl get nodes
}

k8s-upgrade-control() {
    echo "Upgrading control plane node: \$K8S_CONTROL_PLANE"
    kubectl drain \$K8S_CONTROL_PLANE --ignore-daemonsets --delete-local-data
    echo "Control plane drained. Proceed with upgrade on the node itself."
}

k8s-upgrade-worker() {
    local worker_num=\$1
    if [ "\$worker_num" = "1" ]; then
        echo "Upgrading worker 1: \$K8S_WORKER_1"
        kubectl drain \$K8S_WORKER_1 --ignore-daemonsets --delete-local-data
    elif [ "\$worker_num" = "2" ]; then
        echo "Upgrading worker 2: \$K8S_WORKER_2"
        kubectl drain \$K8S_WORKER_2 --ignore-daemonsets --delete-local-data
    else
        echo "Usage: k8s-upgrade-worker <1|2>"
        return 1
    fi
    echo "Worker drained. Proceed with upgrade on the node itself."
}

echo "Available commands:"
echo "  k8s-show-nodes          - Show node mappings"
echo "  k8s-drain-control       - Drain control plane"
echo "  k8s-drain-worker1       - Drain worker 1"
echo "  k8s-drain-worker2       - Drain worker 2"
echo "  k8s-uncordon-control    - Uncordon control plane"
echo "  k8s-uncordon-worker1    - Uncordon worker 1"
echo "  k8s-uncordon-worker2    - Uncordon worker 2"
echo "  k8s-upgrade-control     - Start control plane upgrade"
echo "  k8s-upgrade-worker <1|2> - Start worker upgrade"
EOF

echo ""
echo "[SUCCESS] Node aliases created!"
echo ""
echo "To use the aliases, run:"
echo "  source ~/.k8s-node-aliases"
echo ""
echo "Then you can use commands like:"
echo "  k8s-drain-worker1"
echo "  k8s-upgrade-control"
echo "  k8s-show-nodes"