
# AWS Infrastructure Setup


This guide explains how to provision the AWS resources required for your Kubernetes cluster. It covers EC2 instance setup, security groups, and user data scripts, with step-by-step instructions and explanations for each command.

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

## 1. EC2 Instance Provisioning

You need three Ubuntu 20.04 EC2 instances:
- 1× Control Plane (t3.small)
- 2× Worker Nodes (t3.micro)

**Steps:**
1. Log in to the AWS Console and navigate to EC2 > Instances.
2. Launch three new instances with the following settings:
   - **AMI:** Ubuntu Server 20.04 LTS
   - **Instance Type:** t3.small (control plane), t3.micro (workers)
   - **Key Pair:** Create or use an existing key for SSH access
   - **Network:** Default VPC or custom VPC
   - **Subnet:** Choose as per your architecture
   - **Storage:** At least 20GB per node

---

## 2. Security Groups

Create a security group to allow:
- SSH (port 22) from your IP
- Kubernetes API (port 6443) between nodes
- etcd (port 2379-2380) between control plane and etcd
- Flannel (port 8472/UDP)
- NodePort range (30000-32767)


**Example YAML:**

```yaml
# security-groups.yaml
# Use this as a reference for AWS Security Group rules
```

**How to use:**

You can use `security-groups.yaml` as a CloudFormation template to create the security group automatically:

1. Go to the AWS Console > CloudFormation > Create stack > With new resources (standard).
2. Upload the `security-groups.yaml` file.
3. Follow the prompts to create the stack. This will provision the security group with the required rules.

Alternatively, review the rules in the YAML and manually create a security group with the same ports in the EC2 console if you prefer a manual setup.

---


## 3. Instance Setup Scripts

You have two options for preparing your EC2 Ubuntu 20.04 instances for Kubernetes:

### Option 1: Automated Setup with User Data
- `user-data.sh`: Installs base packages, sets up users, and configures the system for Kubernetes automatically at instance launch.

**How to use:**
1. When launching a new EC2 instance, paste the contents of `user-data.sh` into the "User data" field in the AWS launch wizard.
2. Alternatively, SSH into the instance and run the script manually.

### Option 2: Manual Setup Script
- `ec2-setup.sh`: Prepares an EC2 instance for Kubernetes if you prefer to set up nodes after launch.

**How to use:**
1. SSH into your EC2 instance:
   ```sh
   ssh -i <your-key.pem> ubuntu@<instance-public-ip>
   ```
2. Upload the script:
   ```sh
   scp -i <your-key.pem> ec2-setup.sh ubuntu@<instance-public-ip>:/home/ubuntu/
   ```
3. Run the script:
   ```sh
   chmod +x ec2-setup.sh
   ./ec2-setup.sh
   ```

**What These Scripts Do:**

- Update the OS and install dependencies
- Disable swap (required for Kubernetes)
- Enable kernel modules for container networking
- Set sysctl parameters for Kubernetes networking
- (user-data.sh only) Set up a cluster admin user and hostname

---

**Next:** See [Kubeadm Installation](../../docs/01-cluster-setup/kubeadm-installation.md) to continue cluster setup.
