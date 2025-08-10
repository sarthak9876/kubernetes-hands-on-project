# Kubernetes Hands-On Learning Project 🚀

[![Kubernetes](https://img.shields.io/badge/Kubernetes-v1.28.0-blue.svg)](https://kubernetes.io/)
[![AWS](https://img.shields.io/badge/AWS-EC2-orange.svg)](https://aws.amazon.com/)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-20.04-orange.svg)](https://ubuntu.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/sarthak9876/kubernetes-hands-on-project/pulls)

> A comprehensive, production-ready Kubernetes learning project featuring a 3-tier web application deployed on a self-managed cluster built from scratch on AWS Ubuntu instances.

## 🎯 Project Overview

This repository documents my complete journey of building and managing a Kubernetes cluster from scratch using **kubeadm** on AWS EC2 Ubuntu instances, deploying a full-stack 3-tier application, and implementing DevOps best practices. The project serves as both a learning resource and a portfolio showcase demonstrating real-world Kubernetes skills.

### What Makes This Project Special

- **Built from Scratch**: No managed services - pure Kubernetes learning
- **Real Production Challenges**: Faced and solved actual deployment issues
- **Complete Documentation**: Every command, every troubleshooting step documented
- **3-Tier Architecture**: Database, API, and Frontend with proper service discovery
- **Production Ready**: Health checks, scaling, monitoring, and best practices

## 🏗️ Architecture Overview



```plaintext
┌─────────────────────────────────────────────────────────────┐
│                        AWS Cloud                            │
│  ┌─────────────────┐  ┌─────────────────┐  ┌──────────────┐ │
│  │  Control Plane  │  │   Worker Node 1 │  │ Worker Node 2│ │
│  │   (t3.small)    │  │   (t3.micro)    │  │  (t3.micro)  │ │
│  │ - API Server    │  │ - kubelet       │  │ - kubelet    │ │
│  │ - etcd          │  │ - kube-proxy    │  │ - kube-proxy │ │
│  │ - Controller    │  │ - Flannel CNI   │  │ - Flannel CNI│ │
│  │ - Scheduler     │  │ - App Pods      │  │ - App Pods   │ │
│  └─────────────────┘  └─────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────┘
```



### Application Architecture


```plaintext
┌─────────────┐    ┌─────────────┐    ┌─────────────────┐
│  Frontend   │    │   Backend   │    │    Database     │
│   (Nginx)   │◄──►│   (Flask)   │◄──►│    (MySQL)      │
│ - Static UI │    │ - REST API  │    │ - StatefulSet   │
│ - Reverse   │    │ - 5 Replicas│    │ - Persistent    │
│   Proxy     │    │ - ConfigMap │    │   Storage       │
│ - NodePort  │    │ - Secrets   │    │ - Health Checks │
└─────────────┘    └─────────────┘    └─────────────────┘
```



### Network Topology


```plaintext
┌───────────────┐      ┌───────────────┐      ┌───────────────┐      ┌───────────────┐
│  User         │ ---> │  Nginx        │ ---> │  Flask API    │ ---> │ MySQL DB      │
│ (Browser)     │      │ (NodePort)    │      │ (ClusterIP)   │      │ (StatefulSet) │
└───────────────┘      └───────────────┘      └───────────────┘      └───────────────┘
```




## 📁 Repository Structure


```text
kubernetes-hands-on-project/
├── README.md
├── LICENSE
├── .gitignore
├── docs/
│   ├── 01-cluster-setup/
│   │   ├── README.md
│   │   ├── aws-infrastructure.md
│   │   ├── kubeadm-installation.md
│   │   ├── networking-setup.md
│   │   ├── metrics-server.md
│   │   └── troubleshooting.md
│   ├── 02-application-deployment/
│   │   ├── README.md
│   │   ├── database-tier.md
│   │   ├── backend-tier.md
│   │   ├── frontend-tier.md
│   │   ├── service-discovery.md
│   │   └── testing-validation.md
│   ├── 03-cluster-upgrade/
│   │   ├── README.md
│   │   ├── upgrade-planning.md
│   │   ├── upgrade-procedure.md
│   │   └── rollback-strategy.md
│   ├── architecture/
│   │   ├── cluster-architecture.md
│   │   ├── application-architecture.md
│   │   └── network-topology.md
│   ├── troubleshooting/
│   │   ├── common-issues.md
│   │   ├── cluster-issues.md
│   │   └── application-issues.md
│   └── best-practices/
│       ├── security.md
│       ├── monitoring.md
│       ├── backup-recovery.md
│       └── production-readiness.md
├── infrastructure/
│   ├── aws/
│   │   ├── ec2-setup.sh
│   │   ├── security-groups.yaml
│   │   └── user-data.sh
│   ├── kubeadm/
│   │   ├── kubeadm-config.yaml
│   │   ├── flannel-config.yaml
│   │   └── metrics-server-config.yaml
│   └── storage/
│       ├── local-storage-class.yaml
│       └── pv-examples.yaml
├── application/
│   ├── database/
│   │   ├── mysql-secret.yaml
│   │   ├── mysql-configmap.yaml
│   │   ├── mysql-statefulset.yaml
│   │   ├── mysql-service.yaml
│   │   └── mysql-pvc.yaml
│   ├── backend/
│   │   ├── flask-app/
│   │   │   ├── app.py
│   │   │   ├── requirements.txt
│   │   │   ├── Dockerfile
│   │   │   └── config.py
│   │   ├── flask-deployment.yaml
│   │   ├── flask-service.yaml
│   │   ├── flask-configmap.yaml
│   │   └── flask-secret.yaml
│   ├── frontend/
│   │   ├── nginx-app/
│   │   │   ├── index.html
│   │   │   ├── style.css
│   │   │   ├── script.js
│   │   │   ├── nginx.conf
│   │   │   └── Dockerfile
│   │   ├── nginx-deployment.yaml
│   │   ├── nginx-service.yaml
│   │   └── nginx-configmap.yaml
│   └── monitoring/
│       ├── monitoring-namespace.yaml
│       ├── resource-quota.yaml
│       └── network-policies.yaml
├── scripts/
│   ├── cluster-setup/
│   │   ├── 00-prerequisites.sh
│   │   ├── 01-install-docker.sh
│   │   ├── 02-install-kubernetes.sh
│   │   ├── 03-init-cluster.sh
│   │   ├── 04-setup-networking.sh
│   │   └── 05-setup-metrics.sh
│   ├── application-deploy/
│   │   ├── deploy-database.sh
│   │   ├── deploy-backend.sh
│   │   ├── deploy-frontend.sh
│   │   └── validate-deployment.sh
│   ├── monitoring/
│   │   ├── health-check.sh
│   │   ├── resource-monitor.sh
│   │   └── load-test.sh
│   └── utilities/
│       ├── backup-etcd.sh
│       ├── cleanup.sh
│       └── reset-cluster.sh
├── images/
│   ├── architecture/
│   │   ├── cluster-overview.png
│   │   ├── application-flow.png
│   │   └── network-diagram.png
│   ├── screenshots/
│   │   ├── dashboard/
│   │   ├── monitoring/
│   │   └── application/
│   └── diagrams/
│       ├── deployment-process.png
│       └── upgrade-flow.png
├── examples/
│   ├── basic-pod.yaml
│   ├── service-examples.yaml
│   └── ingress-examples.yaml
└── tests/
    ├── unit/
    ├── integration/
    └── load/
        ├── artillery-config.json
        └── load-test-results.md
```


## 🚀 Quick Start Guide

### Prerequisites Checklist

Before you begin, make sure you have the following. Each item is critical for a successful, secure, and repeatable Kubernetes deployment:

- **AWS Account** with EC2 access (for provisioning cloud infrastructure)
- **3 Ubuntu 20.04 EC2 instances**:
  - 1× Control Plane: `t3.small` (2 vCPU, 2GB RAM) — runs the Kubernetes master components
  - 2× Worker Nodes: `t3.micro` (1 vCPU, 1GB RAM) — run your application workloads
- **SSH access** to all instances (for remote management and automation)
- **Security groups** configured for Kubernetes ports (to allow required traffic between nodes)
- **Basic Linux knowledge** (for troubleshooting and command-line operations)

### 🔧 Phase 1: Infrastructure Setup

#### Step 1: Prepare AWS Environment
```sh
# Clone this repository to get all manifests, scripts, and documentation
git clone https://github.com/sarthak9876/kubernetes-hands-on-project.git
cd kubernetes-hands-on-project

# (Optional) Make all prerequisite scripts executable
chmod +x scripts/00-prerequisites/*.sh

# Run the AWS instance setup script on all 3 EC2 instances
# This script will install base packages, set up users, and configure the system for Kubernetes
./scripts/00-prerequisites/aws-instance-setup.sh
```

#### Step 2: System Preparation
```sh
# Prepare each Ubuntu system for Kubernetes (run on all 3 instances)
# This script will update the OS, configure networking, and install essential tools
./scripts/00-prerequisites/ubuntu-system-prep.sh

# Validate that all prerequisites are met (run on all 3 instances)
# This checks for required kernel modules, swap status, and system settings
./scripts/00-prerequisites/validate-prerequisites.sh
```

### ⚙️ Phase 2: Kubernetes Cluster Setup

#### Step 3: Install Container Runtime & Kubernetes

> **Note:** This project supports both containerd (recommended) and Docker as container runtimes. Choose the runtime that best fits your needs. See the documentation for details.

```sh
# Install your chosen container runtime (run on all 3 instances)
# For containerd (recommended):
./scripts/01-cluster-setup/install-containerd.sh
# For Docker (legacy/optional):
# ./scripts/01-cluster-setup/install-docker.sh

# Install Kubernetes components (run on all 3 instances)
./scripts/01-cluster-setup/install-kubernetes.sh
```

#### Step 4: Initialize Control Plane
```sh
# Run ONLY on the control plane node
# This script initializes the Kubernetes control plane and outputs a join command for worker nodes
./scripts/01-cluster-setup/init-control-plane.sh

# Save the join command that appears — you'll need it for workers!
```

#### Step 5: Setup Worker Nodes
```sh
# Run on each worker node
# This script joins the node to the cluster using the join command from the control plane
./scripts/01-cluster-setup/join-worker-nodes.sh

# Note: Edit the script with the actual join command from step 4
```

#### Step 6: Configure Networking
```sh
# Run ONLY on the control plane node
# This script deploys the Flannel CNI for pod networking
./scripts/01-cluster-setup/setup-flannel-cni.sh

# Deploy the metrics server for resource monitoring
./scripts/01-cluster-setup/setup-metrics-server.sh

# Validate the cluster status and health
./scripts/01-cluster-setup/validate-cluster.sh
```

### 🏗️ Phase 3: Application Deployment

#### Step 7: Deploy Database Tier
```sh
# Create Kubernetes secrets and configmaps for the database
./scripts/02-application-deploy/create-secrets-configs.sh

# Deploy the MySQL database StatefulSet and service
./scripts/02-application-deploy/deploy-database.sh
```

#### Step 8: Deploy Backend Tier
```sh
# Deploy the Flask API backend (Deployment, Service, ConfigMap, Secret)
./scripts/02-application-deploy/deploy-backend.sh
```

#### Step 9: Deploy Frontend Tier
```sh
# Deploy the Nginx frontend (Deployment, Service, ConfigMap)
./scripts/02-application-deploy/deploy-frontend.sh

# Validate the complete application stack (frontend, backend, database)
./scripts/02-application-deploy/validate-application.sh
```

#### Step 10: Access Your Application
```sh
# Get the NodePort URL for the Nginx service
kubectl get svc nginx-service -o wide

# Access your application in a browser using:
# http://<public_IP>:<nodeport_port>
```

## 🎯 Key Learning Outcomes

### ✅ Infrastructure Skills
- [x] **AWS EC2 Management**: Instance creation, security groups, networking
- [x] **Linux System Administration**: Ubuntu server management, package installation
- [x] **Container Runtime**: Docker installation and configuration
- [x] **Kubernetes Installation**: Manual cluster setup with kubeadm

### ✅ Kubernetes Core Concepts
- [x] **Cluster Architecture**: Control plane and worker node roles
- [x] **Pod Management**: Deployments, StatefulSets, ReplicaSets
- [x] **Service Discovery**: ClusterIP, NodePort, load balancing
- [x] **Storage**: Persistent Volumes, Persistent Volume Claims
- [x] **Configuration**: ConfigMaps, Secrets, environment variables
- [x] **Networking**: CNI plugins, pod-to-pod communication

### ✅ Application Deployment
- [x] **Multi-tier Architecture**: Frontend, backend, database separation
- [x] **Container Images**: Building and deploying custom applications
- [x] **Health Checks**: Readiness and liveness probes
- [x] **Scaling**: Horizontal pod autoscaling, replica management
- [x] **Load Balancing**: Service mesh, traffic distribution

### ✅ DevOps Practices
- [x] **Infrastructure as Code**: YAML manifests, configuration management
- [x] **Automation**: Shell scripting, deployment automation
- [x] **Monitoring**: Metrics server, resource monitoring
- [x] **Troubleshooting**: Log analysis, debugging techniques
- [x] **Documentation**: Comprehensive project documentation

## 🛠️ Technology Stack

| Component | Technology | Version | Purpose |
|-----------|------------|---------|---------|
| **Orchestration** | Kubernetes | v1.28.0 | Container orchestration |
| **Container Runtime** | Docker | 20.10+ | Container execution |
| **Cloud Provider** | AWS EC2 | Ubuntu | Infrastructure hosting |
| **Operating System** | Ubuntu | 20.04 LTS | Base system |
| **Networking** | Flannel CNI | Latest | Pod networking |
| **Database** | MySQL | 8.0 | Data persistence |
| **Backend** | Python Flask | 2.3+ | REST API services |
| **Frontend** | Nginx | 1.18+ | Web server & reverse proxy |
| **Monitoring** | Metrics Server | Latest | Resource monitoring |
| **Storage** | hostPath | - | Local persistent storage |

## 📊 Project Highlights

### Performance Metrics
kubectl logs <pod_name> -n <namespace> --previous
kubectl get svc
kubectl exec <pod_name> -n <namespace> -it  -- nslookup 
kubectl describe node 
kubectl get events --sort-by=.metadata.creationTimestamp

- **Cluster Setup Time**: ~30 minutes (with automation)
- **Application Deployment**: ~10 minutes
- **Pod Startup Time**: Use the following command to check pod logs and startup times:
  ```sh
  kubectl logs <pod_name> -n <namespace> --previous
  ```

#### Service Debugging
```sh
# List all services and their endpoints
kubectl get svc
kubectl get endpoints
```

#### Network Debugging
```sh
# Run DNS/network checks from within a pod
kubectl exec <pod_name> -n <namespace> -it -- nslookup <service>
```

#### Resource Debugging
```sh
# Describe node details and view recent events
kubectl describe node
kubectl get events --sort-by=.metadata.creationTimestamp
```

# Emergency Procedures

kubectl rollout restart deployment <deployment_name> -n <namespace>
kubectl scale deployment <deployment_name> -n <namespace> --replicas=<replica_count> //can be used to scale up or scale down your application
kubectl delete pod <pod_name> --force --grace-period=0
kubectl top nodes                //Shows node resource usage

## Restart a Deployment
```sh
# Safely restart a deployment (e.g., after config changes)
kubectl rollout restart deployment <deployment_name> -n <namespace>
```

## Scale a Deployment
```sh
# Scale up or down your application by changing the replica count
kubectl scale deployment <deployment_name> -n <namespace> --replicas=<replica_count>
```

## Force Delete a Stuck Pod
```sh
# Forcefully remove a pod that is stuck or unresponsive
kubectl delete pod <pod_name> --force --grace-period=0
```

## Check Resource Usage
```sh
# View node and pod resource usage (requires metrics server)
kubectl top nodes
kubectl top pods
kubectl top pods --containers
```

## Check Cluster Status
```sh
# Run the cluster status utility script
./scripts/03-utilities/cluster-status.sh
```


## 🎓 Next Steps & Extensions

### Planned Enhancements
- [ ] **Cluster Upgrade**: Upgrading K8s cluster from v1.28.0 to a newer version while 3-tier application is running, demonstrating zero-downtime upgrade strategies used in production environments.
- [ ] **Helm Charts**: Package applications for easier deployment
- [ ] **CI/CD Pipeline**: Automated testing and deployment
- [ ] **Service Mesh**: Istio integration for advanced networking
- [ ] **Monitoring Stack**: Prometheus + Grafana setup
- [ ] **GitOps**: ArgoCD for declarative deployments
- [ ] **Multi-cluster**: Federation and cluster management

### Learning Path
1. **Complete this project** following all documentation
2. **Experiment with configurations** - modify replicas, resources
3. **Break things intentionally** - practice troubleshooting
4. **Implement monitoring** - add Prometheus and Grafana
5. **Add CI/CD** - integrate with GitHub Actions
6. **Explore service mesh** - install and configure Istio

## 🤝 Contributing

This project is designed for learning, and contributions are welcome!

### How to Contribute
1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Contribution Areas
- **Documentation improvements**
- **Script enhancements**
- **Additional troubleshooting scenarios**
- **Performance optimizations**
- **Security enhancements**
- **Monitoring additions**

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Kubernetes Community** for excellent documentation
- **AWS** for reliable cloud infrastructure
- **Ubuntu** for stable operating system
- **Open Source Projects** that made this possible
- **DevOps Community** for sharing knowledge and best practices

## 📞 Contact & Support

- [**GitHub Issues**: Report bugs or request features](https://github.com/sarthak9876/kubernetes-hands-on-project/issues)
- [**GitHub Discussions**: Community discussions](https://github.com/sarthak9876/kubernetes-hands-on-project/discussions)
- [**LinkedIn**: Connect with me](https://www.linkedin.com/in/sarthakvaish007)
- [**Email**: sarthakvaish31@gmail.com](mailto:sarthakvaish31@gmail.com)

## 🌟 Star History

If this project helped you learn Kubernetes, please consider giving it a star! ⭐

## 📈 Project Stats

- **Lines of Code** : 2000+ (YAML, Shell, Python)
- **Documentation Pages**: 20+
- **Scripts Created**: 15+
- **Issues Resolved**: 10+ (documented)
- **Time Investment**: 40+ hours

---

**Ready to start your Kubernetes journey?** 

👉 Begin with [Prerequisites Setup](docs/01-cluster-setup/README.md)

💡 **Tip**: Follow the documentation step-by-step for the best learning experience!

---
