# Backup & Recovery Best Practices

This guide explains how to back up and recover your Kubernetes cluster and workloads. Each recommendation includes the reasoning behind it and practical steps.

---

## 1. Backup etcd Regularly

- **Why:** etcd stores all cluster state. Regular backups protect against data loss and failed upgrades.
- **How:** Use `etcdctl snapshot save` and store backups securely.

---

## 2. Backup Persistent Volumes

- **Why:** Application data stored in PVs must be backed up to prevent loss.
- **How:** Use tools like Velero or cloud provider snapshots.

---

## 3. Test Your Recovery Process

- **Why:** Backups are only useful if you can restore them. Regular testing ensures reliability.
- **How:** Periodically perform restore drills in a test environment.

---

**Next:** [Production Readiness](production-readiness.md)
