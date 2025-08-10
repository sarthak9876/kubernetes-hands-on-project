
# Cluster Setup Guide

This section provides a step-by-step, production-grade guide to building a Kubernetes cluster from scratch on AWS. Each step is explained with the reasoning behind it, so you understand not just what to do, but why it matters for a robust, secure, and maintainable cluster.

---

## Contents

- [AWS Infrastructure Preparation](aws-infrastructure.md): Provision cloud resources, networking, and security groups
- [Kubeadm Installation & Initialization](kubeadm-installation.md): Install Kubernetes components and bootstrap the cluster
- [Networking Setup (Flannel CNI)](networking-setup.md): Enable pod-to-pod communication
- [Metrics Server Installation](metrics-server.md): Set up resource monitoring for your cluster
- [Troubleshooting Common Issues](troubleshooting.md): Diagnose and resolve common setup problems

---

## Overview

This guide walks you through:
- **Provisioning AWS EC2 instances** for control plane and worker nodes (for high availability and separation of duties)
- **Installing Kubernetes components** using kubeadm (for a repeatable, best-practice installation)
- **Configuring networking** with Flannel CNI (to enable pod communication across nodes)
- **Setting up resource monitoring** with Metrics Server (for visibility into cluster health and scaling)
- **Validating cluster health and connectivity** (to ensure your setup is working as expected)
- **Troubleshooting common setup issues** (to help you quickly resolve problems)

## Prerequisites

Before you begin, ensure you have:
- **AWS account with EC2 access** (to provision infrastructure)
- **Basic Linux and networking knowledge** (for troubleshooting and command-line operations)
- **SSH access to all nodes** (for remote management and automation)

## Cluster Topology

- **Control Plane:** 1× t3.small (2 vCPU, 2GB RAM) — runs Kubernetes master components
- **Worker Nodes:** 2× t3.micro (1 vCPU, 1GB RAM) — run your application workloads

## Quick Start

Each step below links to a detailed guide with commands and explanations:

1. **Prepare AWS infrastructure:** [See details](aws-infrastructure.md)
	- Launch EC2 instances, configure networking, and set up security groups
2. **Install kubeadm and initialize cluster:** [See details](kubeadm-installation.md)
	- Install container runtime, Kubernetes components, and bootstrap the control plane
3. **Set up networking:** [See details](networking-setup.md)
	- Deploy Flannel CNI for pod networking
4. **Install Metrics Server:** [See details](metrics-server.md)
	- Enable resource monitoring for scaling and troubleshooting
5. **Validate and troubleshoot:** [See details](troubleshooting.md)
	- Check node and pod status, and resolve common issues

---

For detailed, step-by-step instructions and the reasoning behind each action, see the individual guides above.
