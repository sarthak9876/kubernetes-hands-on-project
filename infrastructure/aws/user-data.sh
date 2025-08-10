#!/bin/bash
# user-data.sh: Bootstrap script for AWS EC2 Ubuntu 20.04 nodes
# Purpose: Installs base packages, sets up users, and configures the system for Kubernetes

set -e

# Update system and install dependencies
apt-get update && apt-get upgrade -y
apt-get install -y curl apt-transport-https ca-certificates software-properties-common

# Set up a new user for cluster administration (optional)
useradd -m -s /bin/bash k8sadmin || true
usermod -aG sudo k8sadmin

# Enable passwordless sudo for k8sadmin
if ! grep -q 'k8sadmin ALL=(ALL) NOPASSWD:ALL' /etc/sudoers; then
  echo 'k8sadmin ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
fi

# Disable swap (required for Kubernetes)
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

# Set hostname (optional, replace NODE_TYPE as needed)
hostnamectl set-hostname <NODE_TYPE>-node-$(date +%s)

# Print completion message
echo "User data script completed. Ready for Kubernetes setup."
