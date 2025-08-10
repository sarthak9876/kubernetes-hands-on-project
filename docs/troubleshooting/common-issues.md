# Troubleshooting: Common Issues

This guide covers frequent issues encountered in Kubernetes clusters and how to resolve them. Each problem includes symptoms, root causes, and step-by-step solutions.

---

## 1. Pods Stuck in Pending State

**Symptoms:**
- `kubectl get pods` shows pods stuck in `Pending`.

**Possible Causes:**
- Insufficient resources on nodes
- No matching node selector/taint toleration
- PersistentVolumeClaims not bound

**How to Fix:**

```sh
# Check node resources
kubectl describe nodes

# Check pod events for scheduling errors
kubectl describe pod <pod-name>

# Check PVC status
kubectl get pvc
```

---

## 2. CrashLoopBackOff Errors

**Symptoms:**
- Pod restarts repeatedly with `CrashLoopBackOff` status.

**Possible Causes:**
- Application errors or misconfiguration
- Missing environment variables or secrets
- Failing readiness/liveness probes

**How to Fix:**

```sh
# View pod logs
kubectl logs <pod-name>

# Describe pod for events
kubectl describe pod <pod-name>

# Check probe configuration in deployment YAML
```

---

**Next:** See [Cluster Issues](cluster-issues.md) for node/network problems or [Application Issues](application-issues.md) for app-specific troubleshooting.
