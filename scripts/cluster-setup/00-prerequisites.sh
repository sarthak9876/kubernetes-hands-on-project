#!/bin/bash
# 00-prerequisites.sh
# Prepares Ubuntu system for Kubernetes installation.
# Usage: Run on all nodes before installing container runtime.

set -e

echo "[INFO] Preparing system for Kubernetes..."

# Update system packages
sudo apt-get update && sudo apt-get upgrade -y

# Install basic tools
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    gnupg \
    lsb-release

# Disable swap (required for Kubernetes)
echo "[INFO] Disabling swap..."
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Load required kernel modules
echo "[INFO] Loading kernel modules..."
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Set up required sysctl params (persist across reboots)
echo "[INFO] Setting up network parameters..."
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

# Create directory for container runtime sockets
sudo mkdir -p /run/containerd

echo "[INFO] System preparation completed!"
echo "[INFO] Next steps:"
echo "1. Install container runtime: Docker OR containerd"
echo "2. Install Kubernetes components"


