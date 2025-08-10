
# AWS Infrastructure Preparation

This guide provides a detailed, step-by-step process for provisioning AWS EC2 instances and networking for your Kubernetes cluster. Each step includes the reasoning behind the action, so you understand not just what to do, but why it matters for a production-grade setup.

---

## 1. Create AWS Account & Login

- **Why:** You need an AWS account to provision cloud resources. The AWS Console is the web interface for managing your infrastructure.
- **How:**
  - Sign up at [aws.amazon.com](https://aws.amazon.com/)
  - Log in to the AWS Management Console

## 2. Launch EC2 Instances

- **Why:** Kubernetes requires multiple nodes (VMs) for high availability and separation of control plane and workloads.
- **How:**
  - **Control Plane Node:**
    - Type: `t3.small` (2 vCPU, 2GB RAM) — meets minimum requirements for Kubernetes master
    - OS: Ubuntu 20.04 LTS (stable, widely supported)
  - **Worker Nodes:**
    - Type: `t3.micro` (1 vCPU, 1GB RAM)
    - OS: Ubuntu 20.04 LTS

### (Recommended) Create a Separate VPC and Subnet

- **Why:** Isolating your cluster in its own VPC and subnet improves security and makes network management easier.
- **How:**
  - In the AWS Console, go to VPC Dashboard
  - Create a new VPC (e.g., `k8s-cluster-vpc`)
  - Create a public subnet within this VPC (e.g., `k8s-public-subnet`)
  - Note the VPC and subnet IDs for later use

### Set Up Internet Gateway and Route Table

- **Why:** An Internet Gateway and proper routing allow your EC2 instances to access the internet (for updates, downloads) and be accessed remotely (SSH, API access).
- **How:**
  - Create a new Internet Gateway and attach it to your VPC
  - Go to Route Tables, select the route table for your subnet
  - Edit routes and add:
    - Destination: `0.0.0.0/0`
    - Target: your Internet Gateway ID

> **Tip:** Launch all cluster nodes in this VPC and subnet for isolation and security.

## 3. Configure Security Groups

- **Why:** Security groups act as virtual firewalls, controlling inbound and outbound traffic to your instances. Proper rules are essential for cluster communication and security.
- **How:**
  - Allow the following inbound ports:
    - SSH: `22` (for remote access)
    - Kubernetes API Server: `6443` (control plane)
    - etcd: `2379-2380` (control plane)
    - Kubelet: `10250` (all nodes)
    - Kube-scheduler: `10251` (all nodes)
    - Kube-controller-manager: `10252` (all nodes)
    - NodePort range: `30000-32767` (for services)
    - Allow all traffic between cluster nodes (recommended for learning)

## 4. Key Pair Setup

- **Why:** SSH key pairs provide secure, passwordless access to your EC2 instances.
- **How:**
  - Create (recommended) or use an existing SSH key pair in AWS
  - Download the `.pem` file for SSH access

## 5. Tagging & Organization

- **Why:** Tagging makes it easy to identify and manage your instances, especially in larger environments.
- **How:**
  - Tag instances for easy identification (e.g., `Name: k8s-control-plane`, `Name: k8s-worker-1`)

## 6. Initial SSH Access

- **Why:** You need to connect to each instance to configure the OS and install Kubernetes prerequisites.
- **How:**
  ```sh
  # Set correct permissions on your private key (required by SSH)
  chmod 400 <your-key>.pem

  # Connect to your instance (replace with your instance's public IP)
  ssh -i <your-key>.pem ubuntu@<instance-public-ip>
  ```

## 7. System Updates

- **Why:** Keeping your OS up-to-date ensures you have the latest security patches and bug fixes.
- **How:**
  ```sh
  # Update package lists and upgrade installed packages
  sudo apt update && sudo apt upgrade -y
  ```

## 8. Set Hostnames

- **Why:** Unique, descriptive hostnames make it easier to identify nodes in logs, monitoring, and troubleshooting.
- **How:**
  ```sh
  # Set hostname for each node
  sudo hostnamectl set-hostname k8s-control-plane   # On control plane
  sudo hostnamectl set-hostname k8s-worker-1       # On worker 1
  sudo hostnamectl set-hostname k8s-worker-2       # On worker 2
  ```

## 9. Update /etc/hosts file

- **Why:** Adding all nodes to `/etc/hosts` allows them to communicate using hostnames instead of IP addresses. This is important for Kubernetes internal communication and makes troubleshooting easier.
- **How:**
  ```sh
  # Edit the hosts file
  sudo nano /etc/hosts
  ```
  Add these lines (replace with your actual private IPs):
  ```sh
  <control-plane-private-ip>    k8s-control-plane
  <worker1-private-ip>          k8s-worker-1
  <worker2-private-ip>          k8s-worker-2
  ```
  Example:
  ```sh
  172.31.32.10    k8s-control-plane
  172.31.32.11    k8s-worker-1
  172.31.32.12    k8s-worker-2
  ```

---

## Reference
- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)
- [Ubuntu Cloud Images](https://cloud-images.ubuntu.com/)

## Next Steps
Proceed to [Kubeadm Installation & Initialization](kubeadm-installation.md).
