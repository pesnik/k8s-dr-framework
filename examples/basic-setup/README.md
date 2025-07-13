# Basic Setup Example

This example demonstrates a minimal configuration for the k8s-dr-framework.

## Prerequisites

- Kubernetes cluster
- AWS S3 bucket
- PostgreSQL database
- Slack webhook (optional)

## Installation

1. Create AWS credentials secret:
```bash
kubectl create secret generic aws-credentials \
  --from-literal=access-key="YOUR_ACCESS_KEY" \
  --from-literal=secret-key="YOUR_SECRET_KEY" \
  --namespace=backup-ops
```

2. Create PostgreSQL credentials secret:
```bash
kubectl create secret generic postgres-credentials \
  --from-literal=username="postgres" \
  --from-literal=password="YOUR_PASSWORD" \
  --namespace=backup-ops
```

3. Install the framework:
```bash
helm install dr-core ../../charts/dr-core \
  --namespace backup-ops \
  --create-namespace \
  --values values.yaml
```

## Verification

```bash
# Check backup jobs
kubectl get cronjobs -n backup-ops

# Check recent backups
kubectl get jobs -n backup-ops
```
