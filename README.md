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

Before starting, ensure you have:

- **AWS Account** with EC2 access
- **3 Ubuntu 20.04 EC2 instances**:
  - 1× Control Plane: `t3.small` (2 vCPU, 2GB RAM)
  - 2× Worker Nodes: `t3.micro` (1 vCPU, 1GB RAM)
- **SSH access** to all instances
- **Security groups** configured for K8s ports
- **Basic Linux knowledge**

### 🔧 Phase 1: Infrastructure Setup

#### Step 1: Prepare AWS Environment
```
# Clone this repository
git clone https://github.com/sarthak9876/kubernetes-hands-on-project.git
cd kubernetes-hands-on-project

# Make scripts executable
chmod +x scripts/cluster-setup/*.sh
```

#### Step 2: System Preparation
```bash
# Run prerequisites on all 3 instances
./scripts/cluster-setup/00-prerequisites.sh
```

### ⚙️ Phase 2: Kubernetes Cluster Setup

#### Step 3: Install Container Runtime & Kubernetes
```bash
# Option A: Install Docker (recommended for learning)
./scripts/cluster-setup/01-install-docker.sh

# Option B: Install containerd (production recommended)
./scripts/cluster-setup/01-install-containerd.sh

# Install Kubernetes components on all 3 instances
./scripts/cluster-setup/02-install-kubernetes.sh
```

**⚠️ Important:** 
- Choose either Docker OR containerd, not both
- All scripts automatically detect your container runtime choice
- Docker is easier for learning (has Docker CLI for debugging)
- containerd is more production-ready (lighter weight, CRI-compliant)

#### Step 4: Initialize Control Plane
```bash
# Run ONLY on control plane node
./scripts/cluster-setup/03-init-cluster.sh

# IMPORTANT: Save the join command output - you'll need it for workers!
# Example: kubeadm join 10.0.1.4:6443 --token abc123...
```

#### Step 5: Setup Networking (Control Plane)
```bash
# Run ONLY on control plane node (after step 4)
./scripts/cluster-setup/04-setup-networking.sh

# This will:
# - Set up kubeconfig for your user
# - Install Flannel CNI
# - Make nodes ready
```

#### Step 6: Join Worker Nodes
```bash
# Run on EACH worker node (use the join command from step 4)
# Example:
sudo kubeadm join 10.0.1.4:6443 --token abc123.def456ghi789 \
    --discovery-token-ca-cert-hash sha256:xyz789...

# After joining, verify on control plane:
kubectl get nodes
```

#### Step 7: Setup Metrics Server
```bash
# Run ONLY on control plane node
./scripts/cluster-setup/05-setup-metrics.sh
```

#### Step 8: Validate Cluster
```bash
# Check cluster status
kubectl get nodes
kubectl get pods -A
kubectl cluster-info
```

### 🏗️ Phase 3: Application Deployment

**⚠️ Important Prerequisites:**
Before deploying applications, you need to build and push container images to a Docker registry. The deployment manifests reference these images.

**📋 Image Building Requirements:**
- **Backend (Flask)**: Build from `application/backend/flask-app/`
- **Frontend (Nginx)**: Build from `application/frontend/nginx-app/`
- **Database (MySQL)**: Uses official MySQL image (no build required)

**🔗 For detailed instructions on building and pushing images:**
- **Docker users**: See [Backend Image Guide](application/backend/README.md) and [Frontend Image Guide](application/frontend/README.md)
- **containerd users**: See [containerd Image Building](docs/02-application-deployment/README.md#image-building-with-containerd)
- **Registry setup**: See [Container Registry Setup](docs/02-application-deployment/README.md#container-registry-setup)

#### Step 9: Deploy Database Tier
```bash
# Create namespace and deploy MySQL
./scripts/application-deploy/deploy-database.sh
```

#### Step 10: Deploy Backend Tier
```bash
# Deploy Flask API
./scripts/application-deploy/deploy-backend.sh
```

#### Step 11: Deploy Frontend Tier
```bash
# Deploy Nginx frontend
./scripts/application-deploy/deploy-frontend.sh

# Validate complete application
./scripts/application-deploy/validate-deployment.sh
```

#### Step 12: Access Your Application
```bash
# Get the NodePort URL
kubectl get svc nginx-service -o wide

# Access via: http://<public_IP>:<nodeport_port>
```

### 📊 Phase 4: Monitoring Setup (Required for Cluster Upgrade)

#### Step 13: Deploy Monitoring Stack
```bash
# Deploy Prometheus and Grafana for monitoring
./scripts/monitoring/deploy-monitoring.sh

# Verify monitoring deployment
kubectl get pods -n monitoring
```

#### Step 14: Configure Alerts and Dashboards
```bash
# Set up monitoring dashboards
./scripts/monitoring/setup-dashboards.sh

# Access Grafana: http://<public_IP>:<grafana-nodeport>
```

### 🔄 Phase 5: Zero-Downtime Cluster Upgrade

#### Step 15: Pre-Upgrade Validation
```bash
# Validate cluster health before upgrade
./scripts/cluster-upgrade/pre-upgrade-check.sh

# Set up node aliases for easier management
./scripts/utilities/node-helper.sh
source ~/.k8s-node-aliases
```

#### Step 16: Upgrade Control Plane
```bash
# Upgrade control plane from v1.28.0 to v1.29.x
./scripts/cluster-upgrade/upgrade-control-plane.sh v1.29.0
```

#### Step 17: Upgrade Worker Nodes
```bash
# Upgrade worker nodes one by one (zero downtime)
./scripts/cluster-upgrade/upgrade-worker-node.sh 1
./scripts/cluster-upgrade/upgrade-worker-node.sh 2
```

#### Step 18: Post-Upgrade Validation
```bash
# Validate upgrade and application health
./scripts/cluster-upgrade/post-upgrade-check.sh
```

## 🚨 Troubleshooting

### Control Plane "NotReady" State
If your control plane node shows "NotReady":

```bash
# Check kubelet status
sudo systemctl status kubelet

# Check for CNI installation
kubectl get pods -n kube-system

# If no CNI pods, install Flannel:
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

# Wait for all system pods to be running
kubectl get pods -n kube-system --watch
```

### Common Issues
- **Connection refused**: Ensure kubeconfig is set up correctly
- **Nodes NotReady**: CNI (Flannel) must be installed
- **Pods pending**: Check node resources and taints

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

### ✅ Production Operations
- [x] **Zero-Downtime Cluster Upgrade**: Upgrading from v1.28.0 to v1.29.x
- [x] **Monitoring & Alerting**: Prometheus and Grafana deployment
- [x] **Node Management**: Draining, cordoning, and upgrade procedures
- [x] **Health Validation**: Pre and post-upgrade checks
- [x] **Rollback Strategies**: Safe rollback procedures for failed upgrades

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
- **Cluster Setup Time**: ~30 minutes (with automation)
- **Application Deployment**: ~10 minutes
- **Pod Startup Time**: 
```
kubectl logs <pod_name> -n <namespace> --previous
```
# Service debugging
```
kubectl get svc
kubectl get endpoints
```

# Network debugging
```
kubectl exec <pod_name> -n <namespace> -it  -- nslookup 
```

# Resource debugging
```
kubectl describe node 
kubectl get events --sort-by=.metadata.creationTimestamp
```

# Emergency Procedures

## Restart deployment
```
kubectl rollout restart deployment <deployment_name> -n <namespace>
```
## Scale deployment
```
kubectl scale deployment <deployment_name> -n <namespace> --replicas=<replica_count> //can be used to scale up or scale down your application
```
## Force delete stuck pod
```
kubectl delete pod <pod_name> --force --grace-period=0
```
## Resource usage
```
kubectl top nodes                //Shows node resource usage
kubectl top pods                 //Shows pod resource usage
kubectl top pods --containers    //Shows container-level usage
```

# Check cluster status
./scripts/03-utilities/cluster-status.sh


## 🎓 Next Steps & Extensions

### Planned Enhancements
- [ ] **Helm Charts**: Package applications for easier deployment
- [ ] **CI/CD Pipeline**: Automated testing and deployment
- [ ] **Service Mesh**: Istio integration for advanced networking
- [ ] **GitOps**: ArgoCD for declarative deployments
- [ ] **Multi-cluster**: Federation and cluster management
- [ ] **Advanced Security**: RBAC, Pod Security Standards, Network Policies

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

👉 Begin with [Prerequisites Setup](docs/01-prerequisites/README.md)

💡 **Tip**: Follow the documentation step-by-step for the best learning experience!

---
