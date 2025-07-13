# Getting Started with k8s-dr-framework

This guide will help you set up and configure the k8s-dr-framework for your Kubernetes cluster.

## Prerequisites

Before installing the framework, ensure you have:

1. **Kubernetes cluster** (version 1.20+)
2. **Helm 3.0+** installed
3. **kubectl** configured to access your cluster
4. **Object storage** (S3, OBS, MinIO, etc.)
5. **Cluster-admin** permissions

## Installation Steps

### 1. Prepare Your Environment

```bash
# Create namespace
kubectl create namespace backup-ops

# Create storage credentials secret
kubectl create secret generic cloud-storage-credentials \
  --from-literal=access-key="your-access-key" \
  --from-literal=secret-key="your-secret-key" \
  --namespace=backup-ops
```

### 2. Configure Values

Create a custom values file:

```yaml
# values-custom.yaml
global:
  namespace: backup-ops

storage:
  provider: aws-s3
  bucket: my-backup-bucket
  region: us-west-2
  credentialsSecret: cloud-storage-credentials

databaseBackups:
  enabled: true
  postgresql:
    instances:
      - name: myapp
        host: postgres-service
        port: 5432
        secretName: postgres-credentials
        databases: ["myapp"]
```

### 3. Install the Framework

```bash
helm upgrade --install dr-core ./charts/dr-core \
  --namespace backup-ops \
  --values values-custom.yaml
```

### 4. Verify Installation

```bash
# Check pods
kubectl get pods -n backup-ops

# Check cronjobs
kubectl get cronjobs -n backup-ops

# Check recent jobs
kubectl get jobs -n backup-ops
```

## Next Steps

- Configure monitoring: [Monitoring Guide](monitoring.md)
- Set up alerts: [Alerting Guide](alerting.md)
- Test disaster recovery: [DR Testing Guide](dr-testing.md)
