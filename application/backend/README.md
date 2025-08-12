# Backend Tier: Flask API

This section contains manifests and configuration for deploying the Flask backend API in the `backend` namespace.

## Namespace
All resources here specify `namespace: backend` in their metadata for isolation and management.


## Typical Resources

- `flask-deployment.yaml`: Deploys the Flask API as a Deployment for stateless scaling.
  - **Deployment:** The recommended way to manage stateless application pods in Kubernetes. Deployments ensure the desired number of pod replicas are running, support rolling updates, and automatically replace failed pods. In a microservices architecture, Deployments make it easy to scale and update backend services independently.
- `flask-service.yaml`: Exposes the Flask API to other services in the cluster.
  - **Service:** Provides a stable network endpoint and load balances traffic to healthy backend pods. Services decouple the client from pod IPs, enabling seamless scaling and rolling updates. In this setup, the Service allows the frontend and other components to communicate with the backend API reliably.
- `flask-configmap.yaml`: Holds environment variables and configuration for the Flask app.
  - **ConfigMap:** Used to inject non-sensitive configuration (such as environment variables, feature flags, or app settings) into pods. This keeps configuration separate from code, making deployments more flexible and portable.
- `flask-secret.yaml`: Stores sensitive environment variables (e.g., database credentials) as a Kubernetes Secret.
  - **Secret:** Designed for storing sensitive data like passwords, API keys, or tokens. Secrets are mounted into pods as environment variables or files, keeping them out of source code and container images. Always use Secrets for confidential information.

## How These Resources Work Together

1. **ConfigMap** and **Secret** provide configuration and credentials to the Flask app securely and flexibly.
2. **Deployment** manages the lifecycle and scaling of Flask pods, ensuring high availability.
3. **Service** exposes the backend API to other services (like frontend or monitoring) within the cluster, providing a stable endpoint and load balancing.
4. **Namespace** (`backend`) keeps all backend resources logically grouped and isolated from other application tiers, supporting better security, access control, and troubleshooting.

This approach follows Kubernetes best practices for microservices, enabling independent scaling, secure configuration, and robust service discovery.

## Resource Explanations
- **Deployment:** Manages stateless application pods, supports rolling updates and scaling.
- **Service:** Provides stable networking and load balancing for accessing the backend pods.
- **ConfigMap:** Stores non-sensitive configuration data, decoupling config from code.
- **Secret:** Securely stores sensitive data, such as API keys or database passwords.
- **Namespace:** Logical partitioning for resource isolation and access control.

## How to Deploy
1. Ensure the `backend` namespace exists:
   ```sh
   kubectl get ns backend || kubectl create ns backend
   ```
2. Apply all manifests in this folder:
   ```sh
   kubectl apply -f .
   ```

## How to Verify
- Check pod status:
  ```sh
  kubectl get pods -n backend
  ```
- Check service:
  ```sh
  kubectl get svc -n backend
  ```

**Next:** See [Frontend Tier](../frontend/README.md) for UI deployment or [Database Tier](../database/README.md) for database setup.
