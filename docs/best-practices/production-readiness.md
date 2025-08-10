# Production Readiness

This guide lists key checks and best practices to ensure your Kubernetes cluster and workloads are ready for production. Each item includes the reasoning behind it and links to further reading.

---

## 1. Health Checks

- **Why:** Liveness and readiness probes ensure only healthy pods receive traffic.
- **How:** Define probes in your pod specs and monitor their status.

---

## 2. Resource Requests and Limits

- **Why:** Prevents resource contention and ensures fair scheduling.
- **How:** Set CPU and memory requests/limits for all pods.

---

## 3. Autoscaling

- **Why:** Automatically adjusts resources to match demand, improving reliability and cost-efficiency.
- **How:** Use Horizontal Pod Autoscaler and Cluster Autoscaler.

---

## 4. Disaster Recovery Plan

- **Why:** Be prepared for failures with tested backup and restore procedures.
- **How:** See [Backup & Recovery Best Practices](backup-recovery.md).

---

**Next:** See [Troubleshooting Common Issues](../01-cluster-setup/troubleshooting.md) for operational support.
