# Backend (Flask API) Deployment

This directory contains the Flask API backend and its Kubernetes deployment manifests.

## 📋 Prerequisites

Before deploying the backend, you need to build and push the container image to a Docker registry.

## 🐳 Building and Pushing Images

### For Docker Users

```bash
# Navigate to the Flask app directory
cd application/backend/flask-app/

# Build the image
docker build -t your-registry/flask-backend:v1.0 .

# Push to registry (replace with your registry)
docker push your-registry/flask-backend:v1.0

# Update the deployment manifest
# Edit flask-deployment.yaml and change:
# image: your-registry/flask-backend:v1.0
```

### For containerd Users

```bash
# Navigate to the Flask app directory
cd application/backend/flask-app/

# Build with buildctl (if using BuildKit)
sudo buildctl build --frontend dockerfile.v0 \
  --local dockerfile=. \
  --local context=. \
  --output type=image,name=your-registry/flask-backend:v1.0,push=true

# Alternative: Use Docker build then import to containerd
docker build -t flask-backend:v1.0 .
docker save flask-backend:v1.0 | sudo ctr -n k8s.io images import -

# Tag for registry
sudo ctr -n k8s.io images tag flask-backend:v1.0 your-registry/flask-backend:v1.0

# Push to registry
sudo ctr -n k8s.io images push your-registry/flask-backend:v1.0
```

## 🏷️ Container Registry Options

### Option 1: Docker Hub (Public)
```bash
# Login to Docker Hub
docker login

# Tag and push
docker tag flask-backend:v1.0 yourusername/flask-backend:v1.0
docker push yourusername/flask-backend:v1.0

# Update deployment manifest:
# image: yourusername/flask-backend:v1.0
```

### Option 2: Local Registry (Development)
```bash
# Start local registry
docker run -d -p 5000:5000 --name registry registry:2

# Tag and push
docker tag flask-backend:v1.0 localhost:5000/flask-backend:v1.0
docker push localhost:5000/flask-backend:v1.0

# Update deployment manifest:
# image: localhost:5000/flask-backend:v1.0
```

### Option 3: AWS ECR
```bash
# Login to ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 123456789012.dkr.ecr.us-east-1.amazonaws.com

# Tag and push
docker tag flask-backend:v1.0 123456789012.dkr.ecr.us-east-1.amazonaws.com/flask-backend:v1.0
docker push 123456789012.dkr.ecr.us-east-1.amazonaws.com/flask-backend:v1.0

# Update deployment manifest:
# image: 123456789012.dkr.ecr.us-east-1.amazonaws.com/flask-backend:v1.0
```

## ⚙️ Updating Deployment Manifests

After building and pushing your image, update the following files:

1. **flask-deployment.yaml** - Update the `image:` field
2. **flask-configmap.yaml** - Verify database connection settings
3. **flask-secret.yaml** - Ensure database credentials are correct

## 🚀 Deployment

Once images are ready and manifests are updated:

```bash
# Deploy the backend
./scripts/application-deploy/deploy-backend.sh

# Verify deployment
kubectl get pods -l app=flask
kubectl logs deployment/flask-backend
```

## 🔧 Configuration

The Flask backend connects to MySQL database using:
- **Host**: `mysql-service.default.svc.cluster.local`
- **Port**: `3306`
- **Database**: `kubernetes_db`
- **Credentials**: Stored in Kubernetes secrets

## 🐛 Troubleshooting

### Image Pull Errors
```bash
# Check if image exists in registry
docker pull your-registry/flask-backend:v1.0

# Check Kubernetes events
kubectl describe pod <flask-pod-name>

# Verify imagePullSecrets if using private registry
kubectl get secrets
```

### Database Connection Issues
```bash
# Check MySQL service
kubectl get svc mysql-service

# Test database connectivity from backend pod
kubectl exec -it <flask-pod> -- nslookup mysql-service

# Check configuration
kubectl get configmap flask-config -o yaml
kubectl get secret flask-secret -o yaml
```

## 📁 Files in this Directory

- `flask-app/` - Flask application source code
- `flask-deployment.yaml` - Kubernetes Deployment
- `flask-service.yaml` - Kubernetes Service
- `flask-configmap.yaml` - Configuration settings
- `flask-secret.yaml` - Database credentials
- `README.md` - This file

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
