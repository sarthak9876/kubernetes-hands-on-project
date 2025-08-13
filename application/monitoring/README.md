# Monitoring Tier: Observability & Metrics

This section contains manifests and configuration for deploying monitoring tools in the `monitoring` namespace.

## What is Prometheus?
Prometheus is an open-source monitoring and alerting toolkit designed for reliability and scalability. It collects metrics from applications and infrastructure by scraping HTTP endpoints, stores them in a time-series database, and allows querying via PromQL. Prometheus is widely used in Kubernetes environments for:
- Collecting cluster and application metrics
- Alerting on system health and performance
- Visualizing trends and troubleshooting issues

## What is Grafana?
Grafana is an open-source analytics and visualization platform. It connects to data sources like Prometheus and displays metrics on customizable dashboards. Grafana is used for:
- Creating interactive dashboards for real-time monitoring
- Visualizing metrics, logs, and traces
- Sharing insights with teams and stakeholders

## What is a Resource Quota?
A ResourceQuota in Kubernetes restricts the total amount of compute resources (CPU, memory, pods, etc.) that can be consumed in a namespace. This prevents resource exhaustion and enforces fair usage among teams or applications. Example: limiting the number of pods or total memory in the `monitoring` namespace.

## What are Network Policies?
NetworkPolicies in Kubernetes control how pods communicate with each other and with resources outside the cluster. They define rules for ingress (incoming) and egress (outgoing) traffic, improving security and compliance. Example: allowing only monitoring tools to access application metrics endpoints.

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

## Directory Structure
```
monitoring/
├── grafana-deployment.yaml
├── grafana-service.yaml
├── monitoring-configmap.yaml
├── prometheus-deployment.yaml
├── prometheus-service.yaml
└── README.md
```

## Setup and Configuration

1. Create the monitoring namespace:
```bash
kubectl create namespace monitoring
```

2. Apply the manifests in order:
```bash
kubectl apply -f monitoring-namespace.yaml
kubectl apply -f resource-quota.yaml
kubectl apply -f network-policies.yaml
kubectl apply -f prometheus-configmap.yaml
kubectl apply -f prometheus-deployment.yaml
kubectl apply -f prometheus-service.yaml
kubectl apply -f grafana-deployment.yaml
kubectl apply -f grafana-service.yaml
```

3. Access the dashboards:
- **Prometheus UI:**
  - Get the NodePort using:
    ```bash
    kubectl get svc prometheus -n monitoring
    ```
  - Open your browser and navigate to `http://<NodeIP>:<NodePort>`
  - Use Prometheus to query metrics, explore targets, and set up alerts.
- **Grafana UI:**
  - Get the NodePort using:
    ```bash
    kubectl get svc grafana -n monitoring
    ```
  - Open your browser and navigate to `http://<NodeIP>:<NodePort>`
  - Default login: `admin` / `admin` (change after first login)
  - Add Prometheus as a data source and import dashboards for cluster and application metrics.

## Example Dashboards
- **Prometheus:**
  - Explore metrics with PromQL (e.g., `up`, `http_requests_total`)
  - View targets and scrape status
- **Grafana:**
  - Import Kubernetes cluster dashboards from the Grafana marketplace
  - Visualize pod CPU/memory, request rates, error rates, and more

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
