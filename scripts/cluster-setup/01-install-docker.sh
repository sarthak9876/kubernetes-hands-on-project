#!/bin/bash
# 01-install-docker.sh
# Installs Docker CE on Ubuntu for Kubernetes.
# Usage: Run on all nodes (control plane + worker nodes).

set -e

echo "[INFO] Installing Docker CE..."

# Update package index
sudo apt-get update

# Install packages to allow apt to use a repository over HTTPS
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker's official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker CE
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add current user to docker group
sudo usermod -aG docker $USER

# Configure Docker daemon for Kubernetes
sudo mkdir -p /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

# Enable and start Docker
sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker

# Verify Docker installation
sudo docker run hello-world

echo "[INFO] Docker CE installed successfully!"
echo "[INFO] Please log out and log back in for group changes to take effect."
echo "[INFO] Or run: newgrp docker"