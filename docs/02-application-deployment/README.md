# Application Deployment Guide

Welcome to the Application Deployment section! This guide will walk you through deploying a production-grade, 3-tier application (database, backend, frontend) on your Kubernetes cluster. **Before proceeding, ensure you have completed all steps in the [Cluster Setup Guide](../01-cluster-setup/README.md).**

---

## Contents
- [Database Tier](database-tier.md): Deploy MySQL with persistent storage and secrets
- [Backend Tier](backend-tier.md): Deploy the Flask API backend
- [Frontend Tier](frontend-tier.md): Deploy the Nginx frontend
- [Service Discovery](service-discovery.md): Expose and connect services
- [Testing & Validation](testing-validation.md): Validate your deployment and troubleshoot

---

## Prerequisites
- Kubernetes cluster is up and running ([Cluster Setup Guide](../01-cluster-setup/README.md))
- `kubectl` is configured and working
- All nodes are `Ready` and networking is functional

---

## Roadmap
1. **Deploy the Database Tier** ([database-tier.md](database-tier.md))
2. **Deploy the Backend Tier** ([backend-tier.md](backend-tier.md))
3. **Deploy the Frontend Tier** ([frontend-tier.md](frontend-tier.md))
4. **Configure Service Discovery** ([service-discovery.md](service-discovery.md))
5. **Test and Validate** ([testing-validation.md](testing-validation.md))

---

> **Next:** [Database Tier Deployment](database-tier.md)
