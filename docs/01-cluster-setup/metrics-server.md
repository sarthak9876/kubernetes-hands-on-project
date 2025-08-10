# Metrics Server Installation

This guide explains how to install and validate the Kubernetes Metrics Server, which provides resource usage data for nodes and pods. Each step is explained with the reasoning behind it.

---

## Why Metrics Server?

The Metrics Server collects resource metrics (CPU, memory) from the kubelet on each node and makes them available via the Kubernetes API. This enables features like `kubectl top`, Horizontal Pod Autoscaling, and resource-based monitoring.

---

## 1. Deploy Metrics Server

**Run this command on the control plane node:**

```sh
# Apply the official Metrics Server manifest
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

- **Why:** This deploys the Metrics Server as a Deployment in the `kube-system` namespace, along with required RBAC roles and service accounts.

---

## 2. Patch Metrics Server Deployment (if needed)

Some cloud environments (including AWS) require Metrics Server to be started with extra arguments to allow insecure TLS (for self-signed kubelet certs):

```sh
kubectl -n kube-system edit deployment metrics-server
```

- Add the following to the `args` section under `spec.template.spec.containers`:
  - `--kubelet-insecure-tls`
  - `--kubelet-preferred-address-types=InternalIP,Hostname,ExternalIP`

- **Why:** This allows Metrics Server to collect metrics from all nodes, even if they use self-signed certificates or have multiple network interfaces.

---

## 3. Validate Metrics Server

```sh
# Check that metrics-server pods are running
kubectl get pods -n kube-system | grep metrics-server

# View node and pod metrics
kubectl top nodes
kubectl top pods --all-namespaces
```

- **Why:** These commands confirm that Metrics Server is running and collecting data. If you see metrics, your setup is working.

---

## Troubleshooting

- If you see `metrics not available`, check:
  - Metrics Server pod logs: `kubectl logs <metrics-server-pod> -n kube-system`
  - Network policies or firewalls blocking port 10250
  - Deployment arguments (see step 2)

---

**Next:** [Troubleshooting Common Issues](troubleshooting.md)
