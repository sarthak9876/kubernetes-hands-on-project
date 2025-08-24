#!/bin/bash
# set-node-names.sh
# Sets meaningful hostnames for Kubernetes nodes before cluster setup
# Usage: Run on each node BEFORE installing Kubernetes

set -e

# Check if node type is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <node-type>"
    echo "Examples:"
    echo "  $0 control-plane"
    echo "  $0 worker-1"
    echo "  $0 worker-2"
    exit 1
fi

NODE_TYPE=$1
NEW_HOSTNAME="k8s-${NODE_TYPE}"

echo "[INFO] Setting hostname to: ${NEW_HOSTNAME}"

# Set the hostname
sudo hostnamectl set-hostname ${NEW_HOSTNAME}

# Update /etc/hosts
echo "[INFO] Updating /etc/hosts..."
sudo sed -i "/127.0.1.1/c\127.0.1.1 ${NEW_HOSTNAME}" /etc/hosts

# Verify the change
echo "[INFO] New hostname: $(hostname)"
echo "[INFO] Please reboot or restart your session for full effect."

echo "[SUCCESS] Hostname set to ${NEW_HOSTNAME}"
echo "[INFO] After reboot, proceed with Kubernetes installation."