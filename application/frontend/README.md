# Frontend (Nginx) Deployment

This directory contains the Nginx frontend and its Kubernetes deployment manifests.

## 📋 Prerequisites

Before deploying the frontend, you need to build and push the container image to a Docker registry.

## 🐳 Building and Pushing Images

### For Docker Users

```bash
# Navigate to the Nginx app directory
cd application/frontend/nginx-app/

# Build the image
docker build -t your-registry/nginx-frontend:v1.0 .

# Push to registry (replace with your registry)
docker push your-registry/nginx-frontend:v1.0

# Update the deployment manifest
# Edit nginx-deployment.yaml and change:
# image: your-registry/nginx-frontend:v1.0
```

### For containerd Users

```bash
# Navigate to the Nginx app directory
cd application/frontend/nginx-app/

# Build with buildctl (if using BuildKit)
sudo buildctl build --frontend dockerfile.v0 \
  --local dockerfile=. \
  --local context=. \
  --output type=image,name=your-registry/nginx-frontend:v1.0,push=true

# Alternative: Use Docker build then import to containerd
docker build -t nginx-frontend:v1.0 .
docker save nginx-frontend:v1.0 | sudo ctr -n k8s.io images import -

# Tag for registry
sudo ctr -n k8s.io images tag nginx-frontend:v1.0 your-registry/nginx-frontend:v1.0

# Push to registry
sudo ctr -n k8s.io images push your-registry/nginx-frontend:v1.0
```

## 🏷️ Container Registry Options

### Option 1: Docker Hub (Public)
```bash
# Login to Docker Hub
docker login

# Tag and push
docker tag nginx-frontend:v1.0 yourusername/nginx-frontend:v1.0
docker push yourusername/nginx-frontend:v1.0

# Update deployment manifest:
# image: yourusername/nginx-frontend:v1.0
```

### Option 2: Local Registry (Development)
```bash
# Start local registry (if not running)
docker run -d -p 5000:5000 --name registry registry:2

# Tag and push
docker tag nginx-frontend:v1.0 localhost:5000/nginx-frontend:v1.0
docker push localhost:5000/nginx-frontend:v1.0

# Update deployment manifest:
# image: localhost:5000/nginx-frontend:v1.0
```

### Option 3: AWS ECR
```bash
# Login to ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 123456789012.dkr.ecr.us-east-1.amazonaws.com

# Tag and push
docker tag nginx-frontend:v1.0 123456789012.dkr.ecr.us-east-1.amazonaws.com/nginx-frontend:v1.0
docker push 123456789012.dkr.ecr.us-east-1.amazonaws.com/nginx-frontend:v1.0

# Update deployment manifest:
# image: 123456789012.dkr.ecr.us-east-1.amazonaws.com/nginx-frontend:v1.0
```

## ⚙️ Updating Deployment Manifests

After building and pushing your image, update the following files:

1. **nginx-deployment.yaml** - Update the `image:` field
2. **nginx-configmap.yaml** - Verify Nginx configuration
3. **nginx-service.yaml** - Ensure NodePort configuration is correct

## 🚀 Deployment

Once images are ready and manifests are updated:

```bash
# Deploy the frontend
./scripts/application-deploy/deploy-frontend.sh

# Verify deployment
kubectl get pods -l app=nginx
kubectl get svc nginx-service
```

## 🔧 Configuration

The Nginx frontend is configured to:
- **Serve static files** from `/usr/share/nginx/html/`
- **Reverse proxy** API requests to Flask backend
- **Expose service** via NodePort for external access
- **Backend URL**: `http://flask-service.default.svc.cluster.local:5000`

## 🌐 Accessing the Application

After deployment, access the application via:

```bash
# Get NodePort
kubectl get svc nginx-service

# Access via browser
# http://<node-external-ip>:<nodeport>
```

## 🐛 Troubleshooting

### Image Pull Errors
```bash
# Check if image exists in registry
docker pull your-registry/nginx-frontend:v1.0

# Check Kubernetes events
kubectl describe pod <nginx-pod-name>

# Check logs
kubectl logs deployment/nginx-frontend
```

### Service Access Issues
```bash
# Check service status
kubectl get svc nginx-service -o wide

# Check endpoints
kubectl get endpoints nginx-service

# Test internal connectivity
kubectl run debug --image=busybox -it --rm -- wget -O- http://nginx-service
```

### Backend Connection Issues
```bash
# Test backend connectivity from frontend pod
kubectl exec -it <nginx-pod> -- curl http://flask-service:5000/health

# Check Nginx configuration
kubectl exec -it <nginx-pod> -- cat /etc/nginx/nginx.conf

# Check ConfigMap
kubectl get configmap nginx-config -o yaml
```

## 📁 Files in this Directory

- `nginx-app/` - Nginx application files (HTML, CSS, JS, config)
- `nginx-deployment.yaml` - Kubernetes Deployment
- `nginx-service.yaml` - Kubernetes Service (NodePort)
- `nginx-configmap.yaml` - Nginx configuration
- `README.md` - This file

## 🔗 Frontend Features

The frontend provides:
- **Modern UI** for the 3-tier application
- **Real-time load balancing** visualization
- **API interaction** with Flask backend
- **Responsive design** for different screen sizes
- **Health monitoring** dashboard

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
