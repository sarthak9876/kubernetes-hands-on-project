# AWS Infrastructure Preparation

This guide covers the steps to provision AWS EC2 instances for your Kubernetes cluster, including recommended instance types, networking, and security group setup.

## Steps

### 1. Create AWS Account & Login
- Sign up at [aws.amazon.com](https://aws.amazon.com/)
- Log in to the AWS Management Console

### 2. Launch EC2 Instances
- **Control Plane Node:**
  - Type: `t3.small` (2 vCPU, 2GB RAM) - Control plane requires 1.5 GB memory and 2 CPU minimum
  - OS: Ubuntu 20.04 LTS
- **Worker Nodes:**
  - Type: `t3.micro` (1 vCPU, 1GB RAM)
  - OS: Ubuntu 20.04 LTS
### (Recommended) Create a Separate VPC and Subnet
- In the AWS Console, go to VPC Dashboard
- Create a new VPC (e.g., `k8s-cluster-vpc`)
- Create a public subnet within this VPC (e.g., `k8s-public-subnet`)
- Note the VPC and subnet IDs for later use

### Set Up Internet Gateway and Route Table
- Create a new Internet Gateway and attach it to your VPC
- Go to Route Tables, select the route table for your subnet
- Edit routes and add:
  - Destination: `0.0.0.0/0`
  - Target: your Internet Gateway ID
- This allows your EC2 instances to access the internet and be accessed remotely

Recommended: Launch all cluster nodes in this VPC and subnet for isolation and security

### 3. Configure Security Groups
- Allow the following inbound ports:
  - SSH: `22` (for remote access)
  - Kubernetes API Server: `6443` (control plane)
  - etcd: `2379-2380` (control plane)
  - Kubelet: `10250` (all nodes)
  - Kube-scheduler: `10251` (all nodes)
  - Kube-controller-manager: `10252` (all nodes)
  - NodePort range: `30000-32767` (for services)
  - etcd server client API - '2379-2380'
  - Allow all traffic between cluster nodes (recommended for learning)

### 4. Key Pair Setup
- Create(recommended) or use an existing SSH key pair
- Download the `.pem` file for SSH access

### 5. Tagging & Organization
- Tag instances for easy identification (e.g., `Name: k8s-control-plane`, `Name: k8s-worker-1`)

### 6. Initial SSH Access
- Connect to each instance:
  ```sh
  chmod 400 <your-key>.pem //to make sure your key is secure
  ssh -i <your-key>.pem ubuntu@<instance-public-ip>
  ```

### 7. System Updates
- Update packages on all nodes:
  ```sh
  sudo apt update && sudo apt upgrade -y
  ```

---

## Reference
- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)
- [Ubuntu Cloud Images](https://cloud-images.ubuntu.com/)

## Next Steps
Proceed to [Kubeadm Installation & Initialization](kubeadm-installation.md).
