# Monitoring Tier: Observability & Metrics

This section contains manifests and configuration for deploying monitoring tools in the `monitoring` namespace.

## Namespace
All resources here specify `namespace: monitoring` in their metadata for isolation and management.

## Typical Resources
- `prometheus-deployment.yaml`: Deploys Prometheus for metrics collection.
- `prometheus-service.yaml`: Exposes Prometheus UI and API.
- `grafana-deployment.yaml`: Deploys Grafana for dashboard visualization.
- `grafana-service.yaml`: Exposes Grafana web UI.
- `monitoring-configmap.yaml`: Holds configuration for Prometheus and Grafana.

## Resource Explanations
- **Deployment:** Manages stateless pods for Prometheus and Grafana, supports scaling and rolling updates.
- **Service:** Provides stable networking and access to monitoring UIs and APIs.
- **ConfigMap:** Stores configuration files for Prometheus scrape targets and Grafana dashboards.
- **Namespace:** Logical partitioning for resource isolation and access control.

## How to Deploy
1. Ensure the `monitoring` namespace exists:
   ```sh
   kubectl get ns monitoring || kubectl create ns monitoring
   ```
2. Apply all manifests in this folder:
   ```sh
   kubectl apply -f .
   ```

## How to Verify
- Check pod status:
  ```sh
  kubectl get pods -n monitoring
  ```
- Check services:
  ```sh
  kubectl get svc -n monitoring
  ```
- Access Prometheus and Grafana UIs using the NodePort or LoadBalancer IPs.

**Next:** Integrate application and cluster metrics for full observability.
