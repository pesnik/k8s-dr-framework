# Multi-Cloud Setup Guide

This guide explains how to configure the k8s-dr-framework for multi-cloud disaster recovery.

## Overview

Multi-cloud setup provides:
- **Redundancy**: Backups stored across multiple cloud providers
- **Disaster Recovery**: Protection against provider-specific outages
- **Cost Optimization**: Leverage different pricing models
- **Compliance**: Meet regulatory requirements for data distribution

## Configuration

### Provider Configuration

```yaml
storage:
  providers:
    primary:
      type: aws-s3
      bucket: primary-dr-backups
      region: us-west-2
      credentialsSecret: aws-credentials
    
    secondary:
      type: huawei-obs
      bucket: secondary-dr-backups
      region: cn-north-4
      credentialsSecret: obs-credentials
    
    tertiary:
      type: gcp-gcs
      bucket: tertiary-dr-backups
      region: us-central1
      credentialsSecret: gcp-credentials
```

### Replication Strategy

```yaml
replication:
  strategy: "all-providers"  # Options: primary-only, primary-secondary, all-providers
  async: true
  verification:
    enabled: true
    schedule: "0 6 * * *"
```

## Best Practices

1. **Geographic Distribution**: Choose regions in different geographic areas
2. **Cost Optimization**: Use cheaper storage classes for secondary copies
3. **Network Considerations**: Account for data transfer costs
4. **Compliance**: Ensure data residency requirements are met
