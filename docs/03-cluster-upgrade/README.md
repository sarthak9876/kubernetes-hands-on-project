# Cluster Upgrade Guide

This section provides a step-by-step, production-grade guide to upgrading your Kubernetes cluster with zero-downtime strategies. **Before proceeding, ensure you have completed all application deployment and validation steps.**

---

## Contents
- [Upgrade Planning](upgrade-planning.md): Assess risks, backup, and prepare for upgrade
- [Upgrade Procedure](upgrade-procedure.md): Perform the upgrade with best practices
- [Rollback Strategy](rollback-strategy.md): Safely revert if issues occur

---

## Prerequisites
- All application tiers are deployed and validated ([Application Deployment Guide](../02-application-deployment/README.md))
- Backups of etcd and application data are available
- Maintenance window is scheduled (for production)

---

## Roadmap
1. **Plan the Upgrade** ([upgrade-planning.md](upgrade-planning.md))
2. **Perform the Upgrade** ([upgrade-procedure.md](upgrade-procedure.md))
3. **Rollback if Needed** ([rollback-strategy.md](rollback-strategy.md))

---

> **Next:** [Upgrade Planning](upgrade-planning.md)
