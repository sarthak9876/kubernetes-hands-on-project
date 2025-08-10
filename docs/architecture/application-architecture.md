# Application Architecture

This document describes the 3-tier application architecture deployed on your Kubernetes cluster. Understanding this structure helps with troubleshooting, scaling, and future enhancements.

---

## Tiers
- **Frontend (Nginx):** Serves static content and proxies API requests to the backend.
- **Backend (Flask API):** Handles business logic and communicates with the database.
- **Database (MySQL):** Stores persistent data, managed as a StatefulSet with persistent storage.

---

## Diagram

See [images/architecture/application-flow.png](../../images/architecture/application-flow.png) for a visual representation.

---

**Next:** [Network Topology](network-topology.md)
