# Database Tier: MySQL

This section contains manifests and configuration for deploying the MySQL database in the `database` namespace.

## Namespace
All resources here should specify `namespace: database` in their metadata for isolation and management.

## Typical Resources

- `mysql-secret.yaml`: Stores database credentials as a Kubernetes Secret.
  - **Secret:** A Kubernetes object for storing sensitive data (like passwords) securely. Secrets are base64-encoded and can be mounted as environment variables or files in pods.
- `mysql-configmap.yaml`: Holds MySQL configuration settings.
  - **ConfigMap:** Used to store non-sensitive configuration data as key-value pairs. ConfigMaps decouple configuration from container images, making applications more portable.
- `mysql-statefulset.yaml`: Deploys MySQL as a StatefulSet for stable storage and identity.
  - **StatefulSet:** Manages stateful applications, providing stable network identities and persistent storage for each replica. Ideal for databases like MySQL.
- `mysql-service.yaml`: Exposes MySQL to other services in the cluster.
  - **Service:** An abstraction that defines a logical set of pods and a policy by which to access them. Services enable communication between components and can be ClusterIP, NodePort, LoadBalancer, or Headless (as used here for StatefulSet).
- `mysql-pvc.yaml`: PersistentVolumeClaim for MySQL data storage.
  - **PersistentVolumeClaim (PVC):** A request for storage by a user. PVCs bind to PersistentVolumes (PVs) and provide durable storage for pods, ensuring data persists across pod restarts.

**Other Kubernetes Concepts Used:**
- **Namespace:** Logical partitioning of cluster resources for isolation and management. All resources here use the `database` namespace.

These resources work together to provide a secure, stable, and persistent MySQL deployment in Kubernetes.

## How to Deploy
1. Ensure the `database` namespace exists:
   ```sh
   kubectl get ns database || kubectl create ns database
   ```
2. Apply all manifests in this folder:
   ```sh
   kubectl apply -f .
   ```

## How to Verify
- Check pod status:
  ```sh
  kubectl get pods -n database
  ```
- Check service:
  ```sh
  kubectl get svc -n database
  ```
- Check PVC:
  ```sh
  kubectl get pvc -n database
  ```

**Next:** See [Backend Tier](../backend/README.md) for API deployment.
