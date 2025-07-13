# PVC Recovery Runbook

This runbook provides procedures for recovering Persistent Volume Claims from backups.

## Overview

PVC recovery involves:
1. Identifying the backup to restore
2. Creating a new PVC (if needed)
3. Restoring data from backup
4. Verifying data integrity

## Recovery Procedures

### 1. List Available PVC Backups

```bash
kubectl run pvc-list --rm -it \
  --image=ghcr.io/pesnik/k8s-dr-framework:latest \
  --command -- /scripts/volumes/list-pvc-backups.sh \
  --namespace=production
```

### 2. Prepare Target PVC

```bash
# Create new PVC if needed
kubectl apply -f - <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: app-data-restored
  namespace: production
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 100Gi
  storageClassName: fast-ssd
