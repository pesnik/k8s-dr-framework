# Configuration Guide

This guide covers advanced configuration options for the k8s-dr-framework.

## Storage Configuration

### Multi-Cloud Setup

```yaml
storage:
  providers:
    primary:
      type: aws-s3
      bucket: primary-backups
      region: us-west-2
    secondary:
      type: huawei-obs
      bucket: secondary-backups
      region: cn-north-4
```

### Encryption

```yaml
storage:
  encryption:
    enabled: true
    kmsKeyId: "arn:aws:kms:us-west-2:123456789012:key/12345678-1234-1234-1234-123456789012"
    algorithm: "AES256"
```

## Database Configuration

### PostgreSQL Advanced Options

```yaml
databaseBackups:
  postgresql:
    instances:
      - name: production
        host: postgres-primary
        port: 5432
        secretName: postgres-creds
        databases: ["app", "analytics"]
        options:
          compression: gzip
          parallelJobs: 4
          excludeTables:
            - temp_data
            - cache_table
```

### MySQL Configuration

```yaml
databaseBackups:
  mysql:
    instances:
      - name: wordpress
        host: mysql-service
        port: 3306
        secretName: mysql-creds
        databases: ["wordpress"]
        options:
          singleTransaction: true
          routines: true
          triggers: true
```

## Retention Policies

```yaml
retention:
  daily: 7
  weekly: 4
  monthly: 12
  yearly: 5
```

## Notification Configuration

```yaml
notifications:
  channels:
    - type: slack
      webhook: "https://hooks.slack.com/services/..."
      channel: "#alerts"
    - type: email
      smtp:
        host: smtp.company.com
        port: 587
        username: alerts@company.com
        password: secretRef:smtp-password
      to: ["admin@company.com"]
```
