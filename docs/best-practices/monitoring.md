# Monitoring Best Practices

This guide covers best practices for monitoring your Kubernetes cluster and workloads. Each recommendation includes the reasoning behind it and practical tips.

---

## 1. Deploy Metrics Server

- **Why:** Enables resource usage metrics for nodes and pods, powering `kubectl top` and autoscaling.
- **How:** See [Metrics Server Installation](../01-cluster-setup/metrics-server.md).

---

## 2. Use Prometheus and Grafana

- **Why:** Prometheus collects detailed metrics; Grafana provides dashboards and alerting.
- **How:** Deploy using Helm charts or manifests. Integrate with Alertmanager for notifications.

---

## 3. Monitor Application Logs

- **Why:** Logs are essential for debugging and incident response.
- **How:** Use tools like EFK (Elasticsearch, Fluentd, Kibana) or Loki for log aggregation and search.

---

## 4. Set Up Alerts

- **Why:** Proactive alerting helps you respond to issues before they impact users.
- **How:** Define alert rules in Prometheus and configure notification channels.

---

**Next:** [Backup & Recovery Best Practices](backup-recovery.md)
