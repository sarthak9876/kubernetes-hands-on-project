# Security Best Practices

This guide outlines essential security best practices for Kubernetes clusters and workloads. Each recommendation includes the reasoning behind it and links to further reading.

---

## 1. Use RBAC for Access Control

- **Why:** Role-Based Access Control (RBAC) restricts what users and service accounts can do in the cluster, reducing the risk of accidental or malicious actions.
- **How:** Define roles and role bindings for least-privilege access.

---

## 2. Isolate Workloads with Namespaces

- **Why:** Namespaces provide logical separation for different teams, environments, or applications.
- **How:** Deploy workloads in dedicated namespaces and use network policies to restrict traffic.

---

## 3. Use Network Policies

- **Why:** Network policies control which pods can communicate, reducing the blast radius of a compromise.
- **How:** Define ingress and egress rules for sensitive workloads.

---

## 4. Store Secrets Securely

- **Why:** Kubernetes Secrets are base64-encoded by default, not encrypted. Use external secret managers or enable encryption at rest.
- **How:** Integrate with tools like AWS Secrets Manager, HashiCorp Vault, or enable encryption in kube-apiserver.

---

## 5. Keep Components Up-to-Date

- **Why:** Security patches are released frequently for Kubernetes and container runtimes.
- **How:** Regularly upgrade your cluster and monitor for CVEs.

---

**Next:** [Monitoring Best Practices](monitoring.md)
