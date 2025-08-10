# Backend Tier Deployment (Flask API)

This guide explains how to deploy the Flask API backend in your Kubernetes cluster, following best practices for configuration, secrets, and service exposure. **Make sure you have completed the [Database Tier Deployment](database-tier.md) first!**

---

## Why a Separate Backend Tier?
- **Scalability:** Allows you to scale API independently from frontend and database.
- **Security:** Isolates business logic and API endpoints from the public internet.
- **Maintainability:** Enables independent updates and rollbacks.

---

## 1. Build and Push the Flask Docker Image

**Why:** Containerizing your backend ensures consistency across environments.

```sh
# Build the Docker image (from the flask-app directory)
docker build -t <your-dockerhub-username>/flask-api:latest ./application/backend/flask-app

# Push the image to Docker Hub (or your registry)
docker push <your-dockerhub-username>/flask-api:latest
```

---

## 2. Create Kubernetes Secrets and ConfigMaps

**Why:** Store sensitive data (API keys, DB credentials) and configuration outside your code.

```sh
kubectl apply -f ../../application/backend/flask-secret.yaml
kubectl apply -f ../../application/backend/flask-configmap.yaml
```

---

## 3. Deploy Flask Deployment and Service

**Why:** Deployments manage pod replicas and rolling updates; Services expose your API to other components.

```sh
kubectl apply -f ../../application/backend/flask-deployment.yaml
kubectl apply -f ../../application/backend/flask-service.yaml
```

---

## 4. Validate Backend Deployment

```sh
# Check pod and service status
kubectl get pods -l app=flask-api
kubectl get svc -l app=flask-api

# Test API endpoint (replace <node-ip> and <nodeport>)
curl http://<node-ip>:<nodeport>/health
```

---

**Next:** [Frontend Tier Deployment](frontend-tier.md)
