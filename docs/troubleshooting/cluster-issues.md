# Troubleshooting: Cluster Issues

This guide addresses problems affecting the entire Kubernetes cluster, such as node failures, networking, and control plane issues. Each section includes symptoms, causes, and solutions.

---

## 1. Node Not Ready

**Symptoms:**
- `kubectl get nodes` shows `NotReady` status.

**Possible Causes:**
- Kubelet not running
- Network plugin failure
- Resource exhaustion

**How to Fix:**

```sh
# Check kubelet status on the node
sudo systemctl status kubelet

# Check node events
kubectl describe node <node-name>

# Check CNI plugin pods
kubectl get pods -n kube-system
```

---

## 2. Control Plane Unreachable

**Symptoms:**
- `kubectl` commands time out
- Cluster API server not responding

**Possible Causes:**
- API server down
- etcd issues
- Firewall/security group blocking traffic

**How to Fix:**

```sh
# Check API server pod/container
sudo docker ps | grep kube-apiserver

# Check etcd status
sudo docker ps | grep etcd

# Check security group/firewall rules
```

---

**Next:** See [Common Issues](common-issues.md) for pod-level problems or [Application Issues](application-issues.md) for app-specific troubleshooting.
