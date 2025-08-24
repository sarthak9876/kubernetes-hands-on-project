#!/bin/bash
# 01-install-containerd.sh
# Installs containerd as container runtime for Kubernetes.
# Usage: Run on all nodes (control plane + worker nodes).

set -e

echo "[INFO] Installing containerd..."

# Update package index
sudo apt-get update

# Install packages to allow apt to use a repository over HTTPS
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker's official GPG key (for containerd)
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install containerd
sudo apt-get update
sudo apt-get install -y containerd.io

# Configure containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml

# Enable SystemdCgroup for Kubernetes
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

# Enable and start containerd
sudo systemctl enable containerd
sudo systemctl daemon-reload
sudo systemctl restart containerd

# Verify containerd installation
sudo ctr version

echo "[INFO] containerd installed and configured successfully!"
echo "[INFO] SystemdCgroup enabled for Kubernetes compatibility."
