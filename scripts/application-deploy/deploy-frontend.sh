#!/bin/bash
# deploy-frontend.sh
# Deploys the Nginx frontend tier in Kubernetes.
# Usage: Run on the control plane node after backend deployment.

set -e

NAMESPACE=frontend

# Create namespace if not exists
kubectl get ns $NAMESPACE || kubectl create ns $NAMESPACE

# Apply configmap, deployment, and service
kubectl apply -f ../../application/frontend/nginx-configmap.yaml -n $NAMESPACE
kubectl apply -f ../../application/frontend/nginx-deployment.yaml -n $NAMESPACE
kubectl apply -f ../../application/frontend/nginx-service.yaml -n $NAMESPACE

echo "[INFO] Nginx frontend deployed in namespace $NAMESPACE."
