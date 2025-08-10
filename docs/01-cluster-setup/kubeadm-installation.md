# Kubeadm Installation & Initialization Guide

This guide provides a step-by-step process to install Kubernetes components (kubeadm, kubelet, kubectl) and initialize your cluster using kubeadm. Follow these instructions **on all nodes** unless specified otherwise.

---

## 📋 Table of Contents
- [1. System Preparation](#1-system-preparation)
- [2. Install Docker](#2-install-docker)
- [3. Install Kubernetes Components](#3-install-kubernetes-components)
- [4. Disable Swap & Configure Sysctl](#4-disable-swap--configure-sysctl)
- [5. Initialize Control Plane](#5-initialize-control-plane)
- [6. Set Up kubeconfig](#6-set-up-kubeconfig)
- [7. Install Pod Network Add-on](#7-install-pod-network-add-on)
- [8. Join Worker Nodes](#8-join-worker-nodes)
- [9. Validate Cluster](#9-validate-cluster)
- [10. Troubleshooting](#10-troubleshooting)

---

## 1. System Preparation

Update your system and install dependencies:
```sh
sudo apt update && sudo apt upgrade -y
sudo apt install -y apt-transport-https ca-certificates curl
```

## 2. Install Docker

Install Docker (container runtime):
```sh
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
```
> **Note:** Log out and log back in for group changes to take effect.

## 3. Install Kubernetes Components

Add Kubernetes apt repository and install kubeadm, kubelet, kubectl:
```sh
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | \
  sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

## 4. Disable Swap & Configure Sysctl

Kubernetes requires swap to be disabled:
```sh
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab
```

Enable required sysctl params:
```sh
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system
```

## 5. Initialize Control Plane

**Run this ONLY on the control plane node:**
```sh
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```
- Save the `kubeadm join ...` command output for worker nodes.

## 6. Set Up kubeconfig

Configure kubectl for the ubuntu user (on control plane):
```sh
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

## 7. Install Pod Network Add-on (Flannel)

**Run on control plane:**
```sh
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
```

## 8. Join Worker Nodes

**Run on each worker node:**
- Use the `kubeadm join ...` command from step 5.
- Example:
```sh
sudo kubeadm join <control-plane-ip>:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash>
```

## 9. Validate Cluster

On the control plane node:
```sh
kubectl get nodes
kubectl get pods -A
```
- All nodes should be `Ready` and pods should be running.

## 10. Troubleshooting

- Check kubelet status:
  ```sh
  sudo systemctl status kubelet
  ```
- View logs:
  ```sh
  journalctl -xeu kubelet
  ```
- Common issues:
  - Pod network not set up: Ensure Flannel is applied and pods are running
  - Swap not disabled: Double-check swap status
  - Firewall/Security groups: Ensure required ports are open

---

**Next:** [Networking Setup (Flannel CNI)](networking-setup.md)

---

> For more details, see the [official kubeadm documentation](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)
