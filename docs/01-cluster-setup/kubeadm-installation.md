
# Kubeadm Installation & Initialization Guide

This guide provides a robust, production-grade process to install Kubernetes using kubeadm, supporting both **containerd** (recommended) and **Docker** as container runtimes. All steps are explained with best practices and troubleshooting tips. **Follow these instructions on all nodes unless specified.**

---

## 📋 Table of Contents

- [1. System Preparation](#1-system-preparation)
- [2. Choose & Install Container Runtime (containerd or Docker)](#2-choose--install-container-runtime-containerd-or-docker)
- [3. Install Kubernetes Components](#3-install-kubernetes-components)
- [4. Disable Swap & Configure Sysctl](#4-disable-swap--configure-sysctl)
- [5. Initialize Control Plane](#5-initialize-control-plane)
- [6. Set Up kubeconfig](#6-set-up-kubeconfig)
- [7. Install Pod Network Add-on](#7-install-pod-network-add-on)
- [8. Join Worker Nodes](#8-join-worker-nodes)
- [9. Validate Cluster](#9-validate-cluster)
- [10. Troubleshooting](#10-troubleshooting)

---

## 1. System Preparation

Update your system and install dependencies:

```sh
# Update the list of available packages and upgrade installed packages to the latest versions
sudo apt update && sudo apt upgrade -y
# Install essential tools for downloading, verifying, and installing packages
sudo apt install -y curl wget apt-transport-https ca-certificates gnupg lsb-release software-properties-common
```

### What each package does:





Keeping your system up-to-date and installing required dependencies is the foundation for a stable Kubernetes installation. These commands ensure your OS is current and has all the tools needed for secure package management and cluster setup.

**What each package does:**
- `curl`/`wget`: Download files and communicate with APIs
- `apt-transport-https`: Allow apt to download over HTTPS (required for secure repos)
- `ca-certificates`: Certificate authorities for SSL verification
- `gnupg`: Handle GPG keys for package verification
- `lsb-release`: Provide distribution information (used by some install scripts)
- `software-properties-common`: Adds useful tools for managing apt repositories

## 2. Choose & Install Container Runtime (containerd or Docker)

Kubernetes supports several container runtimes. **containerd** is recommended for new clusters due to its simplicity, performance, and upstream support. Docker is also supported for legacy compatibility.

Kubernetes supports several container runtimes. **containerd** is recommended for new clusters due to its simplicity, performance, and upstream support. Docker is also supported for legacy compatibility. The container runtime is the low-level component that actually runs your containers on each node. Choosing the right runtime is critical for stability and performance.

### Option A: Install containerd (Recommended)

```sh
# Install containerd
sudo apt install -y containerd

# Configure containerd with default config
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml

# Ensure SystemdCgroup is set (recommended for kubeadm)
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

# Restart and enable containerd
sudo systemctl restart containerd
sudo systemctl enable containerd
```
```sh
# Install containerd, a lightweight and high-performance container runtime
sudo apt install -y containerd

# Create the config directory if it doesn't exist
sudo mkdir -p /etc/containerd

# Generate the default containerd configuration file
sudo containerd config default | sudo tee /etc/containerd/config.toml

# Set SystemdCgroup to true for better compatibility and resource management with kubeadm
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

# Restart containerd to apply the new configuration
sudo systemctl restart containerd

# Enable containerd to start on boot
sudo systemctl enable containerd
```

### Option B: Install Docker (Legacy/Optional)

```sh
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
```
```sh
# Install Docker, a popular container runtime (legacy option)
sudo apt install -y docker.io

# Enable Docker to start on boot
sudo systemctl enable docker

# Start Docker service now
sudo systemctl start docker

# Add your user to the docker group to run docker commands without sudo (log out/in required)
sudo usermod -aG docker $USER
```
> **Note:** Log out and log back in for group changes to take effect if using Docker.

**_Tip:_** If you are unsure, use containerd for new clusters. For advanced use-cases (GPU, custom plugins), review [Kubernetes CRI docs](https://kubernetes.io/docs/setup/production-environment/container-runtimes/).

## 3. Install Kubernetes Components

Add Kubernetes apt repository and install kubeadm, kubelet, kubectl:

```sh
sudo mkdir -p /etc/apt/keyrings
curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" | \
  sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```
Adding the official Kubernetes repository ensures you get the latest, signed binaries directly from the Kubernetes maintainers. Holding the package versions prevents accidental upgrades that could break your cluster.

```sh
# Create a directory for apt keyrings if it doesn't exist
sudo mkdir -p /etc/apt/keyrings

# Download and add the Kubernetes GPG key for package verification
curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key

# Add the Kubernetes apt repository
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" | \
  sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update package lists to include Kubernetes packages
sudo apt update

# Install kubelet (node agent), kubeadm (cluster bootstrapper), and kubectl (CLI)
sudo apt install -y kubelet kubeadm kubectl

# Prevent these packages from being automatically upgraded (to avoid version skew)
sudo apt-mark hold kubelet kubeadm kubectl
```

## 4. Disable Swap & Configure Sysctl

Kubernetes requires swap to be disabled:

```sh
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab
```
Kubernetes requires swap to be disabled because the kubelet will refuse to start if swap is enabled. Disabling swap ensures predictable performance and resource management for containers. If swap is enabled, the kubelet will not register the node.

```sh
# Turn off swap immediately (until next reboot)
sudo swapoff -a

# Permanently disable swap by commenting out any swap entries in /etc/fstab
sudo sed -i '/ swap / s/^/#/' /etc/fstab
```

Enable required sysctl params for networking:

```sh
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system
```

## 5. Initialize Control Plane


**Run this ONLY on the control plane node.**

This step bootstraps your Kubernetes control plane. The `--pod-network-cidr` flag sets the pod network range (required for Flannel). The `--cri-socket` flag ensures kubeadm uses the correct container runtime socket for your environment.

```sh
# Initialize the Kubernetes control plane
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --cri-socket $(if systemctl is-active --quiet containerd; then echo "/run/containerd/containerd.sock"; else echo "/var/run/dockershim.sock"; fi)
```

- The `--cri-socket` flag ensures kubeadm uses the correct container runtime socket. For containerd, it is `/run/containerd/containerd.sock`. For Docker, it is `/var/run/dockershim.sock` (with cri-dockerd).
- Save the `kubeadm join ...` command output for worker nodes. This will be used to join worker nodes to the cluster.

## 6. Set Up kubeconfig


Configure kubectl for the current user (on control plane). This allows you to run `kubectl` commands as a non-root user, which is best practice for security and convenience.

```sh
# Create the kubeconfig directory if it doesn't exist
mkdir -p $HOME/.kube

# Copy the admin kubeconfig to your home directory
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

# Change ownership so your user can access the config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

## 7. Install Pod Network Add-on (Flannel)


**Run on control plane:**

Install a pod network add-on so that pods can communicate across nodes. Flannel is a simple and reliable choice for most clusters.

```sh
# Deploy Flannel CNI for pod networking
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
```

## 8. Join Worker Nodes


**Run on each worker node:**

This step securely connects each worker node to the control plane using the join command you saved earlier. The `--cri-socket` flag must match your chosen container runtime.

- Use the `kubeadm join ...` command from step 5. This securely connects the worker node to the control plane.
- Example:

```sh
# Join the cluster using the command provided by kubeadm init
sudo kubeadm join <control-plane-ip>:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash> --cri-socket <runtime-socket>
```

Replace `<runtime-socket>` with `/run/containerd/containerd.sock` for containerd, or `/var/run/dockershim.sock` for Docker.

## 9. Validate Cluster


On the control plane node, verify that all nodes have joined and pods are running as expected:

```sh
# List all nodes and their status
kubectl get nodes

# List all pods in all namespaces
kubectl get pods -A
```

- All nodes should be `Ready` and pods should be running. If not, check the troubleshooting section below.

## 10. Troubleshooting


- **Check kubelet status:**

  ```sh
  # Check if the kubelet service is running
  sudo systemctl status kubelet
  ```
- **View logs:**

  ```sh
  # View detailed logs for the kubelet service
  journalctl -xeu kubelet
  ```
- **Common issues:**
  - Pod network not set up: Ensure Flannel is applied and pods are running
  - Swap not disabled: Double-check swap status (swap must be off for kubelet to start)
  - Firewall/Security groups: Ensure required ports are open between nodes (see AWS security group settings)
  - Wrong CRI socket: Double-check the `--cri-socket` value matches your runtime (containerd or Docker)

---

**Next:** [Networking Setup (Flannel CNI)](networking-setup.md)

---

> For more details, see the [official kubeadm documentation](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)
