#!/bin/bash
# 03-init-cluster.sh
# Initializes the Kubernetes control plane using kubeadm.
# Usage: Run ONLY on the control plane node.

set -e

# Initialize cluster
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

# Set up kubeconfig for the current user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "[INFO] Control plane initialized. Save the join command for worker nodes!"
