# Cluster Setup Guide

This section provides a step-by-step guide to building a Kubernetes cluster from scratch on AWS, following best practices for production-grade deployments.

## Contents
- [AWS Infrastructure Preparation](aws-infrastructure.md)
- [Kubeadm Installation & Initialization](kubeadm-installation.md)
- [Networking Setup (Flannel CNI)](networking-setup.md)
- [Metrics Server Installation](metrics-server.md)
- [Troubleshooting Common Issues](troubleshooting.md)

---

## Overview
This guide walks you through:
- Provisioning AWS EC2 instances for control plane and worker nodes
- Installing Kubernetes components using kubeadm
- Configuring networking with Flannel CNI
- Setting up resource monitoring with Metrics Server
- Validating cluster health and connectivity
- Troubleshooting common setup issues

## Prerequisites
- AWS account with EC2 access
- Basic Linux and networking knowledge
- SSH access to all nodes

## Cluster Topology
- **Control Plane:** 1× t3.small (2 vCPU, 2GB RAM)
- **Worker Nodes:** 2× t3.micro (1 vCPU, 1GB RAM)

## Quick Start
1. Prepare AWS infrastructure ([details](aws-infrastructure.md))
2. Install kubeadm and initialize cluster ([details](kubeadm-installation.md))
3. Set up networking ([details](networking-setup.md))
4. Install Metrics Server ([details](metrics-server.md))
5. Validate and troubleshoot ([details](troubleshooting.md))

---

For detailed instructions, see the individual guides above.
