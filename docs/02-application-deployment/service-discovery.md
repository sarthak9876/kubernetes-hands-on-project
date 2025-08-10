# Service Discovery in Kubernetes

This guide explains how to expose and connect your application tiers (frontend, backend, database) using Kubernetes Services. **Make sure you have completed the [Frontend Tier Deployment](frontend-tier.md) first!**

---

## Why Service Discovery?
- **Connectivity:** Allows different application tiers to communicate reliably.
- **Abstraction:** Decouples service consumers from pod IPs, enabling scaling and rolling updates.
- **Security:** Controls access between components using service types and namespaces.

---

## 1. Expose Backend and Database with ClusterIP Services

**Why:** ClusterIP services provide stable internal endpoints for backend and database, accessible only within the cluster.

```sh
kubectl apply -f ../../application/backend/flask-service.yaml
kubectl apply -f ../../application/database/mysql-service.yaml
```

---

## 2. Expose Frontend with NodePort Service

**Why:** NodePort services make your frontend accessible from outside the cluster (e.g., your browser).

```sh
kubectl apply -f ../../application/frontend/nginx-service.yaml
```

---

## 3. Validate Service Endpoints

```sh
# List all services and their endpoints
kubectl get svc
kubectl get endpoints

# Test connectivity from within a pod
kubectl exec -it <pod-name> -- curl http://<service-name>:<port>
```

---

**Next:** [Testing & Validation](testing-validation.md)
