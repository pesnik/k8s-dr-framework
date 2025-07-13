# Helm Values Reference

This document provides a comprehensive reference for all configuration options available in the k8s-dr-framework Helm charts.

## Global Configuration

### global
- `namespace` (string): Target namespace for all resources
- `image.repository` (string): Container image repository
- `image.tag` (string): Container image tag
- `image.pullPolicy` (string): Image pull policy

### storage
- `provider` (string): Storage provider (huawei-obs, aws-s3, minio, gcp-gcs)
- `credentialsSecret` (string): Name of secret containing storage credentials
- `encryption.enabled` (boolean): Enable encryption at rest
- `encryption.kmsKeyId` (string): KMS key ID for encryption

## Database Backups

### databaseBackups.postgresql
- `instances` (array): List of PostgreSQL instances to backup
  - `name` (string): Instance name
  - `host` (string): Database host
  - `port` (integer): Database port
  - `secretName` (string): Secret containing database credentials
  - `databases` (array): List of databases to backup
  - `schedule` (string): Cron schedule for backups

### databaseBackups.mysql
- `instances` (array): List of MySQL instances to backup
  - Similar structure to PostgreSQL

## Configuration Backups

### configBackups
- `enabled` (boolean): Enable configuration backups
- `namespaces` (array): List of namespaces to backup
  - `name` (string): Namespace name
  - `resources` (array): List of resource types to backup

## Monitoring

### monitoring.prometheus
- `serviceMonitor.enabled` (boolean): Enable Prometheus ServiceMonitor
- `serviceMonitor.interval` (string): Scrape interval

### monitoring.grafana
- `dashboards.enabled` (boolean): Enable Grafana dashboards
