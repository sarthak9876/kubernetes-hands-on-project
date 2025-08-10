# Database Tier Deployment (MySQL)

This guide explains how to deploy the MySQL database tier in your Kubernetes cluster, with persistent storage, secrets, and best practices. **If you haven't completed the [Cluster Setup Guide](../01-cluster-setup/README.md), do that first!**

---

## Why a Separate Database Tier?
- **Separation of concerns:** Keeps data management isolated from application logic.
- **Persistence:** Ensures your data survives pod restarts and node failures.
- **Security:** Secrets and ConfigMaps keep credentials and configs out of your code.

---

## 1. Create Kubernetes Secrets and ConfigMaps

**Why:** Store sensitive data (passwords) and configuration separately from your application code.

```sh
# Create a secret for the MySQL root password
kubectl create secret generic mysql-root-pass --from-literal=password=<your-root-password> -n default

# Create a ConfigMap for MySQL configuration (optional)
kubectl create configmap mysql-config --from-file=my.cnf=./my.cnf -n default
```

---

## 2. Deploy Persistent Volume and Persistent Volume Claim

**Why:** Ensure MySQL data is stored on disk, not just in the pod, so it survives restarts.

- See the provided `mysql-pvc.yaml` and `local-storage-class.yaml` manifests in the `application/database/` and `infrastructure/storage/` directories.

```sh
kubectl apply -f ../../infrastructure/storage/local-storage-class.yaml
kubectl apply -f ../../application/database/mysql-pvc.yaml
```

---

## 3. Deploy MySQL StatefulSet and Service

**Why:** StatefulSets provide stable network IDs and persistent storage for databases.

```sh
kubectl apply -f ../../application/database/mysql-statefulset.yaml
kubectl apply -f ../../application/database/mysql-service.yaml
```

---

## 4. Validate MySQL Deployment

```sh
# Check pod status
kubectl get pods -l app=mysql

# Check persistent volume status
kubectl get pvc

# Connect to MySQL pod and test login
kubectl exec -it <mysql-pod-name> -- mysql -u root -p
```

---

**Next:** [Backend Tier Deployment](backend-tier.md)
