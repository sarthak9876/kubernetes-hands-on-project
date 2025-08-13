# Frontend Tier: Nginx Web UI

This section contains manifests and configuration for deploying the Nginx-based frontend in the `frontend` namespace.

## Namespace
All resources here specify `namespace: frontend` in their metadata for isolation and management.

## Typical Resources
- `nginx-deployment.yaml`: Deploys the Nginx web server as a Deployment for stateless scaling.
- `nginx-service.yaml`: Exposes the Nginx frontend to users and other services in the cluster.
- `nginx-configmap.yaml`: Holds Nginx configuration files and environment variables.
- `nginx-app/`: Contains the static website files and Dockerfile for building the frontend image.

## Resource Explanations
- **Deployment:** Manages stateless Nginx pods, supports rolling updates and scaling.
- **Service:** Provides stable networking and load balancing for accessing the frontend pods. Typically exposed via NodePort or LoadBalancer for external access.
- **ConfigMap:** Stores Nginx configuration and static files, decoupling config from code.
- **Namespace:** Logical partitioning for resource isolation and access control.

## How to Deploy
1. Ensure the `frontend` namespace exists:
   ```sh
   kubectl get ns frontend || kubectl create ns frontend
   ```
2. Apply all manifests in this folder:
   ```sh
   kubectl apply -f .
   ```

## How to Verify
- Check pod status:
  ```sh
  kubectl get pods -n frontend
  ```
- Check service:
  ```sh
  kubectl get svc -n frontend
  ```

**Next:** See [Backend Tier](../backend/README.md) for API deployment or [Database Tier](../database/README.md) for database setup.
