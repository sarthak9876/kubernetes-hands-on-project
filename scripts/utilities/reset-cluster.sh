#!/bin/bash
# reset-cluster.sh
# Resets the Kubernetes cluster by removing all cluster state and configuration.
# Usage: Run on any node to reset its Kubernetes state.

set -e

sudo kubeadm reset -f
sudo rm -rf $HOME/.kube
sudo rm -rf /etc/kubernetes
sudo rm -rf /var/lib/etcd
sudo rm -rf /var/lib/kubelet
sudo rm -rf /var/lib/cni
sudo rm -rf /etc/cni

echo "[INFO] Node reset complete. You may need to rejoin the cluster."
