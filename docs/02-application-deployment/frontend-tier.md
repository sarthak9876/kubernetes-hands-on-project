# Frontend Tier Deployment (Nginx)

This guide explains how to deploy the Nginx frontend in your Kubernetes cluster, following best practices for configuration, service exposure, and validation. **Make sure you have completed the [Backend Tier Deployment](backend-tier.md) first!**

---

## Why a Separate Frontend Tier?
- **Performance:** Nginx efficiently serves static content and proxies API requests.
- **Security:** Isolates the public-facing layer from backend and database.
- **Flexibility:** Enables independent updates to UI without backend changes.

---

## 1. Build and Push the Nginx Docker Image

**Why:** Containerizing your frontend ensures consistent deployments and easy rollbacks.

```sh
# Build the Docker image (from the nginx-app directory)
docker build -t <your-dockerhub-username>/nginx-frontend:latest ./application/frontend/nginx-app

# Push the image to Docker Hub (or your registry)
docker push <your-dockerhub-username>/nginx-frontend:latest
```

---

## 2. Create Kubernetes ConfigMap

**Why:** Store Nginx configuration outside your image for flexibility.

```sh
kubectl apply -f ../../application/frontend/nginx-configmap.yaml
```

---

## 3. Deploy Nginx Deployment and Service

**Why:** Deployments manage pod replicas and rolling updates; Services expose your frontend to users.

```sh
kubectl apply -f ../../application/frontend/nginx-deployment.yaml
kubectl apply -f ../../application/frontend/nginx-service.yaml
```

---

## 4. Validate Frontend Deployment

```sh
# Check pod and service status
kubectl get pods -l app=nginx-frontend
kubectl get svc -l app=nginx-frontend

# Access the frontend in your browser using the NodePort IP and port
```

---

**Next:** [Service Discovery](service-discovery.md)
