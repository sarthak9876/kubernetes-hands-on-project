#!/bin/bash
# deploy-database.sh
# Deploys the MySQL database tier in Kubernetes.
# Usage: Run on the control plane node after cluster setup.

set -e

NAMESPACE=database

# Create namespace if not exists
kubectl get ns $NAMESPACE || kubectl create ns $NAMESPACE

# Apply secrets, configmap, PVC, StatefulSet, and service
kubectl apply -f ../../application/database/mysql-secret.yaml -n $NAMESPACE
kubectl apply -f ../../application/database/mysql-configmap.yaml -n $NAMESPACE
kubectl apply -f ../../application/database/mysql-pvc.yaml -n $NAMESPACE
kubectl apply -f ../../application/database/mysql-statefulset.yaml -n $NAMESPACE
kubectl apply -f ../../application/database/mysql-service.yaml -n $NAMESPACE

echo "[INFO] MySQL database deployed in namespace $NAMESPACE."
