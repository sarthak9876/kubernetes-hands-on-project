#!/bin/bash
# backup-etcd.sh
# Backs up the etcd database from the Kubernetes control plane.
# Usage: Run on the control plane node. Requires etcdctl installed.

set -e

BACKUP_DIR="/var/backups/etcd"
TIMESTAMP=$(date +%Y%m%d%H%M%S)
BACKUP_FILE="$BACKUP_DIR/etcd-snapshot-$TIMESTAMP.db"

sudo mkdir -p $BACKUP_DIR
sudo etcdctl snapshot save $BACKUP_FILE \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key

sudo chown $(id -u):$(id -g) $BACKUP_FILE

echo "[INFO] etcd backup saved to $BACKUP_FILE"
