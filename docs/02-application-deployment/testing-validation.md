# Testing & Validation

This guide explains how to validate your application deployment, test connectivity between tiers, and troubleshoot common issues. **Make sure you have completed the [Service Discovery](service-discovery.md) steps first!**

---

## Why Test and Validate?
- **Reliability:** Ensures all components are running and communicating as expected.
- **Troubleshooting:** Quickly identify and resolve issues before going to production.
- **Confidence:** Provides assurance that your deployment is correct and ready for users.

---

## 1. Check Pod and Service Status

```sh
# List all pods and their status
kubectl get pods -A

# List all services and their endpoints
kubectl get svc -A
kubectl get endpoints -A
```

---

## 2. Test Application End-to-End

```sh
# Access the frontend in your browser using the NodePort IP and port
# Example: http://<node-ip>:<nodeport>

# Test backend API from within a pod
kubectl exec -it <frontend-pod> -- curl http://flask-service:5000/health

# Test database connectivity from backend pod
kubectl exec -it <backend-pod> -- mysql -h mysql-service -u root -p
```

---

## 3. Troubleshooting Tips
- Use `kubectl describe` to get detailed info on pods, services, and PVCs
- Use `kubectl logs` to view pod logs
- Check events for recent errors: `kubectl get events --sort-by=.metadata.creationTimestamp`
- Use `journalctl` for systemd service logs (e.g., kubelet)

---

**Next:** [Cluster Upgrade Guide](../03-cluster-upgrade/README.md)
