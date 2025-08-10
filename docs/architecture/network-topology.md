# Network Topology

This document explains the network topology of your Kubernetes cluster and application, including how traffic flows between users, services, and pods.

---

## Flow
- **User → Nginx (NodePort):** External users access the application via the Nginx NodePort service.
- **Nginx → Flask API (ClusterIP):** Nginx proxies API requests to the backend using internal service discovery.
- **Flask API → MySQL (ClusterIP):** Backend connects to the database using a stable internal endpoint.

---

## Diagram

See [images/architecture/network-diagram.png](../../images/architecture/network-diagram.png) for a visual representation.

---

**Next:** [Best Practices](../best-practices/production-readiness.md)
