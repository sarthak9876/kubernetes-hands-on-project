# Upgrade Procedure

This guide explains how to safely upgrade your Kubernetes cluster using kubeadm, with zero-downtime strategies and best practices. **Complete [Upgrade Planning](upgrade-planning.md) first!**

---

## 1. Upgrade Control Plane Components

```sh
# Drain the control plane node (cordon and evict pods)
kubectl drain <control-plane-node> --ignore-daemonsets --delete-local-data

# Upgrade kubeadm
sudo apt update && sudo apt install -y kubeadm

# Plan the upgrade (see available versions)
sudo kubeadm upgrade plan

# Apply the upgrade
sudo kubeadm upgrade apply v1.29.0  # Replace with your target version

# Upgrade kubelet and kubectl
sudo apt install -y kubelet kubectl
sudo systemctl restart kubelet

# Uncordon the control plane node
kubectl uncordon <control-plane-node>
```

---

## 2. Upgrade Worker Nodes (One at a Time)

```sh
# Drain the worker node
kubectl drain <worker-node> --ignore-daemonsets --delete-local-data

# Upgrade kubeadm, kubelet, and kubectl
sudo apt update && sudo apt install -y kubeadm kubelet kubectl
sudo kubeadm upgrade node
sudo systemctl restart kubelet

# Uncordon the worker node
kubectl uncordon <worker-node>
```

---

## 3. Validate the Upgrade

```sh
# Check node and component versions
kubectl get nodes -o wide
kubectl version --short

# Check workloads
kubectl get pods -A
```

---

**Next:** [Rollback Strategy](rollback-strategy.md)
