
# Storage Configuration


This guide explains the storage resources and configuration files used in your Kubernetes cluster. Each file is described with its purpose and usage.

---

## Namespaces for Resource Isolation

Namespaces are used in Kubernetes to logically isolate and group resources, making it easier to manage, secure, and access workloads. Using namespaces is a best practice for production clusters, as it:
- Prevents naming conflicts between resources
- Enables resource quotas and access control per environment or team
- Makes it easier to monitor and troubleshoot applications

**How to create namespaces:**

Apply the provided `namespaces.yaml` manifest to create the recommended namespaces:

```sh
kubectl apply -f namespaces.yaml
```

**Expected output:**

```
namespace/database created
namespace/backend created
namespace/frontend created
namespace/monitoring created
```

All application resources (Deployments, Services, ConfigMaps, etc.) should specify the appropriate `namespace` in their manifests. Cluster-scoped resources (like StorageClass and PersistentVolume) do not use namespaces.

---

---

## 1. local-storage-class.yaml

Defines a StorageClass for local persistent volumes.

**Purpose:**
- Allows dynamic provisioning of local storage for pods.


**How to use:**

```sh
kubectl apply -f local-storage-class.yaml
```

**How to check if the StorageClass was created:**

```sh
kubectl get storageclass
```

**Expected output:**

```
NAME            PROVISIONER                    AGE
local-storage   kubernetes.io/no-provisioner   10s
```

---

## 2. pv-examples.yaml

Provides example PersistentVolume (PV) definitions for static provisioning.

**Purpose:**
- Demonstrates how to manually create PVs for use by PersistentVolumeClaims (PVCs).


**How to use:**

```sh
kubectl apply -f pv-examples.yaml
```

**How to check if the PersistentVolumes were created:**

```sh
kubectl get pv
```

**Expected output:**

```
NAME         CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS    REASON   AGE
local-pv-1   5Gi        RWO            Retain           Available           local-storage            10s
local-pv-2   5Gi        RWO            Retain           Available           local-storage            10s
```

---

**Next:** See [Application Deployment Guide](../../docs/02-application-deployment/README.md) for using storage in workloads.
