#!/bin/bash
# 00-prerequisites.sh
# This script checks and installs basic prerequisites for Kubernetes cluster setup on Ubuntu.
# Usage: Run on all nodes before starting cluster setup.

set -e

# Update system
sudo apt-get update && sudo apt-get upgrade -y

# Install essential packages
sudo apt-get install -y curl wget apt-transport-https ca-certificates gnupg lsb-release

# Disable swap (required for Kubernetes)
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

# Enable required kernel modules
sudo modprobe overlay
sudo modprobe br_netfilter

# Set sysctl params for Kubernetes networking
sudo tee /etc/sysctl.d/k8s.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system

# Print completion message
echo "[INFO] Prerequisites installed and system prepared for Kubernetes."


