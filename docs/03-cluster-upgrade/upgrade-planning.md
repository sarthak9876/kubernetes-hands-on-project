# Upgrade Planning

This guide explains how to plan a safe, zero-downtime Kubernetes cluster upgrade. **Complete all application deployment and validation steps before starting.**

---

## Why Plan Your Upgrade?
- **Minimize risk:** Identify and mitigate potential issues before they impact production.
- **Backup:** Ensure you can recover from any failure.
- **Communication:** Notify stakeholders and schedule a maintenance window if needed.

---

## 1. Review Current Cluster State

```sh
# Check current Kubernetes version
kubectl version --short

# List all nodes and their versions
kubectl get nodes -o wide

# Check running workloads
kubectl get pods -A
```

---

## 2. Backup etcd and Application Data

**Why:** Backups allow you to recover from failed upgrades or data loss.

```sh
# Backup etcd (run on control plane)
ETCDCTL_API=3 etcdctl snapshot save /tmp/etcd-backup.db \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key
```

---

## 3. Notify Stakeholders and Schedule Maintenance
- Communicate upgrade plans and expected impact
- Schedule a maintenance window if required

---

**Next:** [Upgrade Procedure](upgrade-procedure.md)
