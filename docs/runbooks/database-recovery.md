# Database Recovery Runbook

This runbook provides step-by-step procedures for recovering databases from backups.

## Pre-Recovery Checklist

- [ ] Identify the backup to restore from
- [ ] Verify backup integrity
- [ ] Prepare target database instance
- [ ] Notify stakeholders
- [ ] Document the incident

## PostgreSQL Recovery

### 1. List Available Backups

```bash
kubectl run backup-list --rm -it \
  --image=ghcr.io/pesnik/k8s-dr-framework:latest \
  --command -- /scripts/databases/postgres/list-backups.sh \
  --database=myapp
```

### 2. Restore Database

```bash
kubectl run postgres-restore --rm -it \
  --image=ghcr.io/pesnik/k8s-dr-framework:latest \
  --command -- /scripts/databases/postgres/restore.sh \
  --database=myapp \
  --backup-date=2024-03-15 \
  --target-host=postgres-service \
  --target-port=5432
```

### 3. Verify Recovery

```bash
kubectl run postgres-verify --rm -it \
  --image=ghcr.io/pesnik/k8s-dr-framework:latest \
  --command -- /scripts/databases/postgres/verify.sh \
  --database=myapp \
  --host=postgres-service
```

## MySQL Recovery

### 1. List Available Backups

```bash
kubectl run backup-list --rm -it \
  --image=ghcr.io/pesnik/k8s-dr-framework:latest \
  --command -- /scripts/databases/mysql/list-backups.sh \
  --database=wordpress
```

### 2. Restore Database

```bash
kubectl run mysql-restore --rm -it \
  --image=ghcr.io/pesnik/k8s-dr-framework:latest \
  --command -- /scripts/databases/mysql/restore.sh \
  --database=wordpress \
  --backup-date=2024-03-15 \
  --target-host=mysql-service \
  --target-port=3306
```

## Troubleshooting

### Common Issues

1. **Connection Timeout**
   - Check network connectivity
   - Verify service endpoints
   - Review firewall rules

2. **Authentication Failed**
   - Verify credentials in secret
   - Check database user permissions
   - Confirm secret is in correct namespace

3. **Backup Not Found**
   - Check backup retention policy
   - Verify storage connectivity
   - Review backup job logs

### Emergency Contacts

- **Database Team**: db-team@company.com
- **Platform Team**: platform@company.com
- **On-Call**: +1-555-0123
