
# Kubeadm & Cluster Configuration


This guide documents the configuration files and manifests used for setting up your Kubernetes cluster with kubeadm. Each file is explained in detail.

---

## Namespaces for Resource Isolation

Namespaces are used in Kubernetes to logically isolate and group resources, making it easier to manage, secure, and access workloads. Using namespaces is a best practice for production clusters, as it:
- Prevents naming conflicts between resources
- Enables resource quotas and access control per environment or team
- Makes it easier to monitor and troubleshoot applications

**How to create namespaces:**

Apply the provided `namespaces.yaml` manifest (see the `infrastructure/storage` folder) to create the recommended namespaces:

```sh
kubectl apply -f ../storage/namespaces.yaml
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

## 1. kubeadm-config.yaml

Defines cluster-wide settings for kubeadm initialization, including networking, API server, and etcd configuration.

**Key Sections:**
- `apiVersion`, `kind`, `metadata`: Standard Kubernetes manifest fields
- `networking`: Pod subnet, service subnet
- `apiServer`, `controllerManager`, `scheduler`: Extra args and settings

**Example:**

```yaml
# kubeadm-config.yaml
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
networking:
  podSubnet: 10.244.0.0/16
```

---

## 2. flannel-config.yaml

Manifest for deploying Flannel CNI plugin for pod networking.

**How to use:**
- Apply after cluster initialization:

```sh
kubectl apply -f flannel-config.yaml
```

---

## 3. metrics-server-config.yaml

Manifest for deploying the Kubernetes Metrics Server for resource monitoring.

**How to use:**
- Apply after networking is set up:

```sh
kubectl apply -f metrics-server-config.yaml
```

---

**Next:** See [Cluster Setup Guide](../../docs/01-cluster-setup/README.md) for step-by-step instructions.
