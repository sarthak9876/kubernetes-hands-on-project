# Cluster Architecture

This document provides a high-level overview of the Kubernetes cluster architecture used in this project. Understanding the architecture is essential for troubleshooting, scaling, and extending your cluster.

---

## Components
- **Control Plane Node:** Runs the Kubernetes API server, scheduler, controller manager, and etcd. Responsible for cluster management and orchestration.
- **Worker Nodes:** Run application workloads (pods) and node-level agents (kubelet, kube-proxy, CNI plugin).
- **Pod Network (CNI):** Flannel provides pod-to-pod communication across nodes.
- **Persistent Storage:** Local storage class and persistent volumes for stateful workloads.

---

## Diagram

See [images/architecture/cluster-overview.png](../../images/architecture/cluster-overview.png) for a visual representation.

---

**Next:** [Application Architecture](application-architecture.md)
