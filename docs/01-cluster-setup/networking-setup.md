# Networking Setup (Flannel CNI)

This guide explains how to set up pod networking in your Kubernetes cluster using the Flannel CNI plugin. Each step is explained with the reasoning behind it, so you understand both the how and the why.

---

## Why Pod Networking Matters

Kubernetes uses an overlay network to allow pods running on different nodes to communicate with each other. Without a CNI (Container Network Interface) plugin, pods can only communicate within the same node. Flannel is a simple, reliable CNI that works well for most clusters.

---

## 1. Install Flannel CNI

**Run this command on the control plane node:**

```sh
# Apply the Flannel manifest to deploy the CNI plugin
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
```

- **Why:** This command deploys Flannel as a DaemonSet, ensuring every node gets a Flannel pod to manage networking. The manifest also creates the necessary RBAC roles and configmaps.

---

## 2. Verify Flannel Deployment

```sh
# Check that all Flannel pods are running
kubectl get pods -n kube-system -l app=flannel
```

- **Why:** All Flannel pods should be in the `Running` state. If not, check pod logs for errors (e.g., resource limits, CNI misconfiguration).

---

## 3. Validate Pod-to-Pod Networking

```sh
# Deploy a test pod
kubectl run -it --rm --restart=Never busybox --image=busybox -- sh
# Inside the pod, try to ping another pod's IP
ping <other-pod-ip>
```

- **Why:** This confirms that pods on different nodes can communicate, which is essential for most applications.

---

## Troubleshooting

- If Flannel pods are not running, check:
  - Node taints (are your nodes `Ready`?)
  - CNI config in `/etc/cni/net.d/`
  - Pod logs: `kubectl logs <flannel-pod> -n kube-system`
- For advanced networking (e.g., Calico, Cilium), see the Kubernetes CNI documentation.

---

**Next:** [Metrics Server Installation](metrics-server.md)
