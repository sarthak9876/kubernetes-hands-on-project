#!/bin/bash
# deploy-backend.sh
# Deploys the Flask backend tier in Kubernetes.
# Usage: Run on the control plane node after database deployment.

set -e

NAMESPACE=backend

# Create namespace if not exists
kubectl get ns $NAMESPACE || kubectl create ns $NAMESPACE

# Apply secrets, configmap, deployment, and service
kubectl apply -f ../../application/backend/flask-secret.yaml -n $NAMESPACE
kubectl apply -f ../../application/backend/flask-configmap.yaml -n $NAMESPACE
kubectl apply -f ../../application/backend/flask-deployment.yaml -n $NAMESPACE
kubectl apply -f ../../application/backend/flask-service.yaml -n $NAMESPACE

echo "[INFO] Flask backend deployed in namespace $NAMESPACE."
