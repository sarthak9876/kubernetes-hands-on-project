#!/bin/bash
# ec2-setup.sh: Manual setup script for AWS EC2 Ubuntu 20.04 nodes
# Purpose: Prepares an EC2 instance for Kubernetes installation

set -e

# Update system and install dependencies
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y curl apt-transport-https ca-certificates software-properties-common

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
echo "EC2 instance setup complete. Ready for Kubernetes installation."
