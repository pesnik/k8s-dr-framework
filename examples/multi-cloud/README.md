# Multi-Cloud Backup Setup

This example demonstrates how to configure the k8s-dr-framework for multi-cloud disaster recovery.

## Configuration
The setup includes:
- Primary storage: Huawei OBS
- Secondary storage: AWS S3
- Tertiary storage: Google Cloud Storage

## Usage
```bash
helm upgrade --install dr-core ../../charts/dr-core \
  --namespace backup-ops \
  --values values.yaml \
  --create-namespace
```
