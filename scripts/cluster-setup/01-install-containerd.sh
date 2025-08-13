#!/bin/bash
# 01-install-containerd.sh
# Installs containerd as the container runtime for Kubernetes.
# Usage: Run on all nodes.

set -e

# Install containerd
sudo apt-get update && sudo apt-get install -y containerd

# Configure containerd
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml

# Restart containerd
sudo systemctl restart containerd
sudo systemctl enable containerd

echo "[INFO] containerd installed and configured."
