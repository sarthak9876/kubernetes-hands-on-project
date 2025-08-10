# Rollback Strategy

This guide explains how to safely roll back your Kubernetes cluster if an upgrade fails or causes issues. **Complete [Upgrade Procedure](upgrade-procedure.md) first!**

---

## Why Have a Rollback Plan?
- **Minimize downtime:** Quickly restore service if something goes wrong.
- **Protect data:** Ensure you can recover from failed upgrades or data loss.
- **Confidence:** Enables safe experimentation with upgrades.

---

## 1. Restore etcd from Backup

```sh
# Stop kube-apiserver (on control plane)
sudo systemctl stop kubelet
sudo docker stop $(sudo docker ps -q --filter ancestor=k8s.gcr.io/kube-apiserver)

# Restore etcd snapshot
ETCDCTL_API=3 etcdctl snapshot restore /tmp/etcd-backup.db \
  --data-dir /var/lib/etcd-from-backup

# Update etcd manifest to use restored data dir (edit /etc/kubernetes/manifests/etcd.yaml)
# Change --data-dir to /var/lib/etcd-from-backup

# Restart kubelet
sudo systemctl start kubelet
```

---

## 2. Revert Node Upgrades (if needed)
- Downgrade kubeadm, kubelet, and kubectl to previous versions
- Restart services and validate cluster health

---

## 3. Validate Rollback

```sh
# Check node and component versions
kubectl get nodes -o wide
kubectl version --short

# Check workloads
kubectl get pods -A
```

---

**Next:** Review [Best Practices](../best-practices/production-readiness.md) for future upgrades.
