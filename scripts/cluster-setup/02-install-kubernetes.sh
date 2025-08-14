#!/bin/bash
# 02-install-kubernetes.sh
# Installs kubeadm, kubelet, and kubectl on Ubuntu (version 1.28.x pinned).
# Usage: Run on all nodes.

set -e

# Add Kubernetes apt repository
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | \
  sudo tee /etc/apt/sources.list.d/kubernetes.list

# Install Kubernetes components (version 1.28.x)
K8S_VERSION=1.28.0-00
sudo apt-get update
sudo apt-get install -y kubelet=$K8S_VERSION kubeadm=$K8S_VERSION kubectl=$K8S_VERSION

# Hold the installed version to prevent automatic upgrades
sudo apt-mark hold kubelet kubeadm kubectl

echo "[INFO] Kubernetes components v$K8S_VERSION installed and held."

# During cluster upgrade, run:
# sudo apt-mark unhold kubelet kubeadm kubectl
# sudo apt-get install -y kubelet=<new-version> kubeadm=<new-version> kubectl=<new-version>
# sudo apt-mark hold kubelet kubeadm kubectl
