# Full Cluster Restore Runbook

This runbook covers the complete disaster recovery process for a Kubernetes cluster.

## Pre-Disaster Preparation

### 1. Backup Verification

```bash
# Verify all backups are current
kubectl get jobs -n backup-ops --sort-by=.metadata.creationTimestamp

# Check backup status
kubectl logs -n backup-ops job/postgres-backup-myapp

# Verify storage connectivity
kubectl run storage-test --rm -it \
  --image=ghcr.io/pesnik/k8s-dr-framework:latest \
  --command -- /scripts/utils/test-storage.sh
```

### 2. Recovery Planning

- [ ] Identify critical applications
- [ ] Determine recovery order
- [ ] Prepare new cluster (if needed)
- [ ] Gather all credentials
- [ ] Notify stakeholders

## Disaster Recovery Process

### Phase 1: Infrastructure

1. **Provision New Cluster**
   ```bash
   # Create new cluster (cloud-specific)
   eksctl create cluster --name=recovery-cluster --region=us-west-2
   
   # Install k8s-dr-framework
   helm install dr-core ./charts/dr-core \
     --namespace backup-ops \
     --create-namespace
   ```

2. **Restore Network Policies**
   ```bash
   kubectl apply -f security/network-policies/
   ```

### Phase 2: Data Recovery

1. **Restore Databases**
   ```bash
   # PostgreSQL
   kubectl run postgres-restore --rm -it \
     --image=ghcr.io/pesnik/k8s-dr-framework:latest \
     --command -- /scripts/databases/postgres/restore.sh \
     --database=myapp \
     --backup-date=2024-03-15
   
   # MySQL
   kubectl run mysql-restore --rm -it \
     --image=ghcr.io/pesnik/k8s-dr-framework:latest \
     --command -- /scripts/databases/mysql/restore.sh \
     --database=wordpress \
     --backup-date=2024-03-15
   ```

2. **Restore Configurations**
   ```bash
   kubectl run config-restore --rm -it \
     --image=ghcr.io/pesnik/k8s-dr-framework:latest \
     --command -- /scripts/configs/manifest-restore.sh \
     --namespace=production \
     --backup-date=2024-03-15
   ```

3. **Restore Persistent Volumes**
   ```bash
   kubectl run pvc-restore --rm -it \
     --image=ghcr.io/pesnik/k8s-dr-framework:latest \
     --command -- /scripts/volumes/pvc-restore.sh \
     --pvc=app-data \
     --namespace=production \
     --backup-date=2024-03-15
   ```

### Phase 3: Application Recovery

1. **Deploy Applications**
   ```bash
   # Deploy in dependency order
   helm install myapp ./charts/myapp --namespace production
   helm install monitoring ./charts/monitoring --namespace monitoring
   ```

2. **Verify Application Health**
   ```bash
   kubectl get pods -A
   kubectl get svc -A
   kubectl get ingress -A
   ```

### Phase 4: Verification

1. **Data Integrity Check**
   ```bash
   kubectl run data-verify --rm -it \
     --image=ghcr.io/pesnik/k8s-dr-framework:latest \
     --command -- /scripts/utils/verify-data-integrity.sh
   ```

2. **Functional Testing**
   ```bash
   # Run smoke tests
   kubectl run smoke-tests --rm -it \
     --image=myapp:test \
     --command -- /tests/smoke.sh
   ```

## Post-Recovery Tasks

1. **Update DNS Records**
2. **Restart Backup Jobs**
3. **Enable Monitoring**
4. **Notify Stakeholders**
5. **Document Lessons Learned**

## Recovery Time Objectives (RTO)

- **Database Recovery**: 30 minutes
- **Application Recovery**: 1 hour
- **Full Cluster Recovery**: 4 hours

## Recovery Point Objectives (RPO)

- **Database Backups**: 24 hours
- **Configuration Backups**: 12 hours
- **Volume Backups**: 24 hours
