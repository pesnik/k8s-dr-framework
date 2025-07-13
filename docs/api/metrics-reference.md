# Metrics Reference

This document describes all metrics exposed by the k8s-dr-framework.

## Backup Job Metrics

### backup_job_success
- Type: Gauge
- Description: Indicates if the last backup job was successful (1) or failed (0)
- Labels: database, type, namespace

### backup_job_duration_seconds
- Type: Histogram
- Description: Duration of backup jobs in seconds
- Labels: database, type, namespace

### backup_size_bytes
- Type: Gauge
- Description: Size of backup in bytes
- Labels: database, type, namespace

## Storage Metrics

### backup_storage_usage_bytes
- Type: Gauge
- Description: Total storage usage in bytes
- Labels: provider, bucket, region

### backup_storage_cost_usd
- Type: Gauge
- Description: Estimated storage cost in USD
- Labels: provider, bucket, region

## Disaster Recovery Metrics

### dr_rto_seconds
- Type: Gauge
- Description: Recovery Time Objective in seconds
- Labels: type, namespace

### dr_rpo_seconds
- Type: Gauge
- Description: Recovery Point Objective in seconds
- Labels: type, namespace

### dr_test_success
- Type: Gauge
- Description: Indicates if the last DR test was successful
- Labels: type, namespace
