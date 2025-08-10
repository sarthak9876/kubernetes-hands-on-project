# Troubleshooting: Application Issues

This guide helps diagnose and resolve issues specific to deployed applications in your Kubernetes cluster. Each section includes symptoms, causes, and solutions.

---

## 1. Service Not Accessible

**Symptoms:**
- Application URL does not load
- `kubectl get svc` shows service, but no response

**Possible Causes:**
- Service type misconfiguration (e.g., ClusterIP vs NodePort)
- Network policy blocking traffic
- Pod not ready or not running

**How to Fix:**

```sh
# Check service type and endpoints
kubectl get svc
kubectl describe svc <service-name>

# Check pod status
kubectl get pods

# Check network policies
kubectl get networkpolicy
```

---

## 2. Application Fails Health Checks

**Symptoms:**
- Pod restarts or is not added to service endpoints
- Readiness/liveness probe failures

**Possible Causes:**
- Incorrect probe configuration
- Application not listening on expected port
- Startup delays

**How to Fix:**

```sh
# Check probe configuration in deployment YAML
# View pod logs for errors
kubectl logs <pod-name>

# Describe pod for events
kubectl describe pod <pod-name>
```

---

**Next:** See [Common Issues](common-issues.md) for general pod problems or [Cluster Issues](cluster-issues.md) for node/network troubleshooting.
