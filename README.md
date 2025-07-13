# k8s-dr-framework

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-1.20+-blue.svg)](https://kubernetes.io/)
[![Helm](https://img.shields.io/badge/Helm-3.0+-green.svg)](https://helm.sh/)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://docker.com/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/pesnik/k8s-dr-framework/pulls)

> **A comprehensive, Helm-driven framework for Kubernetes disaster recovery and data protection.**

This repository, authored by **[@pesnik](https://github.com/pesnik)**, contains a scalable and highly structured solution for managing critical data backups and supporting disaster recovery on Kubernetes.

While currently focused on robust, periodic database backups, this framework is designed to evolve into a full-fledged Disaster Recovery (DR) system for Kubernetes workloads, encompassing application configuration and persistent volume management.

## 🎯 Project Philosophy

This project is a testament to the **"Infrastructure as Code" (IaC)** philosophy. By treating disaster recovery operations as code, we achieve:

- **🛡️ Comprehensive Data Protection**: A reliable approach to safeguarding critical data across different resource types
- **⚡ Rapid Recovery**: Designed for quick and predictable restoration in disaster scenarios
- **🌍 Portability**: Cloud-agnostic and deployable on any Kubernetes cluster
- **🔧 Operational Excellence**: Maintainable and extensible using Helm and structured CI/CD

## ✨ Key Features

- **🎛️ Helm-Powered Architecture**: A core Helm chart (`dr-core`) designed to manage various backup job types from a single configuration
- **📦 Monorepo Structure**: Centralized management of configurations, scripts, and custom images
- **🔒 Isolated Operations**: All operational resources reside in a dedicated `backup-ops` namespace
- **🐳 Custom Backup Images**: Utilize tailored Docker images for specific backup and restore tasks
- **🚨 Disaster Recovery Focus**: Includes scripts and documentation (`docs/runbooks`) for restoration and verification
- **📊 Built-in Monitoring**: Prometheus metrics and Grafana dashboards for operational visibility
- **🔔 Multi-channel Notifications**: Slack, email, and webhook integrations for alerting

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                              k8s-dr-framework                                   │
│                                                                                 │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────────────────┐  │
│  │   PostgreSQL    │    │      MySQL      │    │   Config/PV Backups        │  │
│  │   Databases     │    │   Databases     │    │   (ConfigMaps, Secrets,     │  │
│  │                 │    │                 │    │    PVCs, etc.)              │  │
│  └─────────┬───────┘    └─────────┬───────┘    └─────────────┬───────────────┘  │
│            │                      │                          │                  │
│            └──────────────────────┼──────────────────────────┘                  │
│                                   │                                             │
│                                   ▼                                             │
│  ┌─────────────────────────────────────────────────────────────────────────────┐  │
│  │                          dr-core Helm Chart                                │  │
│  │                                                                             │  │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │  │
│  │  │  Database   │  │   Config    │  │     PV      │  │    Monitoring &    │  │  │
│  │  │  CronJobs   │  │  CronJobs   │  │  CronJobs   │  │   Notifications     │  │  │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────────────┘  │  │
│  └─────────────────────────────────────────────────────────────────────────────┘  │
│                                     │                                             │
│                                     ▼                                             │
│  ┌─────────────────────────────────────────────────────────────────────────────┐  │
│  │                        Storage Layer                                       │  │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │  │
│  │  │ Huawei OBS  │  │   AWS S3    │  │   MinIO     │  │    Other S3         │  │  │
│  │  │             │  │             │  │             │  │   Compatible        │  │  │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────────────┘  │  │
│  └─────────────────────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────────────────┘
```

## 📂 Repository Structure

This monorepo is meticulously organized to support a complete DevOps workflow:

```
k8s-dr-framework/
├── .github/                      # GitHub Actions workflows & issue templates
│   ├── workflows/
│   │   ├── ci.yml
│   │   ├── release.yml
│   │   └── security-scan.yml
│   └── ISSUE_TEMPLATE/
├── charts/                       # Main directory for all Helm charts
│   ├── dr-core/                  # The core chart for all backup types
│   │   ├── templates/
│   │   │   ├── _helpers.tpl
│   │   │   ├── rbac.yaml
│   │   │   ├── cronjob-database.yaml     # Reusable template for DB backups
│   │   │   ├── cronjob-config.yaml       # Template for config backups
│   │   │   ├── cronjob-pvc.yaml          # Template for PV backups
│   │   │   ├── configmap.yaml
│   │   │   ├── secret.yaml
│   │   │   └── servicemonitor.yaml
│   │   ├── Chart.yaml
│   │   ├── values.yaml
│   │   ├── values-staging.yaml
│   │   └── values-production.yaml
│   └── backup-monitoring/        # Helm chart for backup-specific monitoring
│       ├── templates/
│       │   ├── grafana-dashboard.yaml
│       │   ├── prometheus-rules.yaml
│       │   └── alertmanager-config.yaml
│       ├── Chart.yaml
│       └── values.yaml
├── scripts/                      # Standalone shell scripts for backup/restore logic
│   ├── databases/
│   │   ├── postgres/
│   │   │   ├── backup.sh
│   │   │   ├── restore.sh
│   │   │   └── verify.sh
│   │   ├── mysql/
│   │   │   ├── backup.sh
│   │   │   ├── restore.sh
│   │   │   └── verify.sh
│   │   └── mongodb/              # Future support
│   ├── configs/                  # Scripts for backing up/restoring non-database data
│   │   ├── manifest-backup.sh
│   │   ├── manifest-restore.sh
│   │   └── etcd-backup.sh
│   ├── volumes/                  # PVC and volume backup scripts
│   │   ├── pvc-backup.sh
│   │   ├── pvc-restore.sh
│   │   └── velero-integration.sh
│   └── utils/
│       ├── upload.sh
│       ├── notify.sh
│       ├── encryption.sh
│       └── validation.sh
├── docker/                       # Dockerfiles for custom backup images
│   ├── database-backup/          # A unified image for all DBs
│   │   ├── Dockerfile
│   │   ├── entrypoint.sh
│   │   └── requirements.txt
│   ├── config-backup/            # Image for ConfigMaps, Secrets etc.
│   │   ├── Dockerfile
│   │   └── entrypoint.sh
│   └── volume-backup/            # Image for PVC backups
│       ├── Dockerfile
│       └── entrypoint.sh
├── monitoring/                   # Monitoring and alerting configurations
│   ├── grafana/
│   │   ├── dashboards/
│   │   │   ├── backup-overview.json
│   │   │   └── disaster-recovery.json
│   │   └── provisioning/
│   ├── prometheus/
│   │   ├── rules/
│   │   │   ├── backup-alerts.yml
│   │   │   └── storage-alerts.yml
│   │   └── targets/
│   └── alertmanager/
│       └── config.yml
├── docs/                         # Comprehensive documentation
│   ├── runbooks/
│   │   ├── database-recovery.md
│   │   ├── full-cluster-restore.md
│   │   ├── pvc-recovery.md
│   │   └── emergency-procedures.md
│   ├── guides/
│   │   ├── getting-started.md
│   │   ├── configuration.md
│   │   ├── multi-cloud-setup.md
│   │   └── security-best-practices.md
│   ├── api/
│   │   ├── helm-values-reference.md
│   │   └── metrics-reference.md
│   ├── troubleshooting.md
│   ├── architecture.md
│   └── roadmap.md
├── examples/                     # Example configurations
│   ├── basic-setup/
│   ├── multi-cloud/
│   ├── enterprise/
│   └── disaster-recovery-drill/
├── tests/                        # Testing framework
│   ├── unit/
│   ├── integration/
│   └── e2e/
├── ci/                           # CI/CD pipeline definitions
│   ├── .gitlab-ci.yml
│   ├── .github-actions.yml
│   └── jenkins/
├── security/                     # Security configurations
│   ├── rbac/
│   ├── network-policies/
│   └── pod-security-policies/
├── CONTRIBUTING.md
├── SECURITY.md
├── CHANGELOG.md
└── README.md
```

## 🚀 Quick Start

### 1. Prerequisites

Ensure your Kubernetes cluster meets the following requirements:

- **Kubernetes**: 1.20+
- **Helm**: 3.0+
- **Storage**: Object storage (OBS, S3, MinIO, etc.)
- **RBAC**: Cluster-admin access for initial setup
- **Monitoring**: Prometheus (optional, for metrics)

### 2. Installation

```bash
# Clone the repository
git clone https://github.com/pesnik/k8s-dr-framework.git
cd k8s-dr-framework

# Create the backup operations namespace
kubectl create namespace backup-ops

# Install the framework
helm upgrade --install dr-core ./charts/dr-core \
  --namespace backup-ops \
  --values charts/dr-core/values-production.yaml \
  --create-namespace
```

### 3. Verification

```bash
# Check deployment status
kubectl get all -n backup-ops

# Verify backup jobs are scheduled
kubectl get cronjobs -n backup-ops

# Check recent backup runs
kubectl get jobs -n backup-ops --sort-by=.metadata.creationTimestamp
```

## ⚙️ Configuration

The framework is configured through a comprehensive `values.yaml` file that supports multiple backup types and storage providers:

### Core Configuration Structure

```yaml
# Global settings apply to all backup jobs
global:
  namespace: "backup-ops"
  image:
    repository: "ghcr.io/pesnik/k8s-dr-framework"
    tag: "latest"
    pullPolicy: "IfNotPresent"
  schedule: "0 2 * * *"  # Default: 2 AM daily
  retention:
    days: 30
  
# Storage configuration (multi-provider support)
storage:
  provider: "huawei-obs"  # aws-s3, minio, gcp-gcs
  credentialsSecret: "cloud-storage-credentials"
  encryption:
    enabled: true
    kmsKeyId: "your-kms-key-id"
  
# Database backup configuration
databaseBackups:
  enabled: true
  postgresql:
    instances:
      - name: "airflow"
        host: "airflow-postgres-service"
        port: 5432
        secretName: "airflow-db-credentials"
        databases: ["airflow"]
        schedule: "0 2 * * *"
      - name: "superset"
        host: "superset-postgres-service"
        port: 5432
        secretName: "superset-db-credentials"
        databases: ["superset"]
        
  mysql:
    instances:
      - name: "production-app"
        host: "mysql-primary-service"
        port: 3306
        secretName: "mysql-prod-credentials"
        databases: ["production"]
        schedule: "0 3 * * *"

# Kubernetes configuration backups
configBackups:
  enabled: true
  namespaces:
    - name: "default"
      resources: ["ConfigMap", "Secret"]
    - name: "critical-apps"
      resources: ["ConfigMap", "Secret", "Deployment", "Service"]
  
# Persistent Volume backups
pvBackups:
  enabled: true
  snapshots:
    - name: "airflow-pvc-snapshot"
      pvcName: "airflow-data-pvc"
      namespace: "airflow"
      schedule: "0 0 * * *"
      
# Monitoring and alerting
monitoring:
  enabled: true
  prometheus:
    serviceMonitor:
      enabled: true
      interval: "30s"
  grafana:
    dashboards:
      enabled: true
      
# Multi-channel notifications
notifications:
  enabled: true
  channels:
    - type: "slack"
      webhook: "https://hooks.slack.com/services/..."
    - type: "email"
      smtp:
        host: "smtp.company.com"
        port: 587
        username: "alerts@company.com"
    - type: "webhook"
      url: "https://api.company.com/alerts"
```

## 🔧 Advanced Features

### Multi-Cloud Support

Deploy backups across multiple cloud providers for maximum resilience:

```yaml
storage:
  providers:
    primary:
      type: "huawei-obs"
      bucket: "k8s-dr-primary"
      region: "cn-north-4"
    secondary:
      type: "aws-s3"
      bucket: "k8s-dr-secondary"
      region: "us-west-2"
    tertiary:
      type: "gcp-gcs"
      bucket: "k8s-dr-tertiary"
      region: "us-central1"
```

### Backup Verification

Built-in verification ensures backup integrity:

```yaml
verification:
  enabled: true
  schedule: "0 4 * * *"  # Verify backups at 4 AM
  methods:
    - "checksum"
    - "restore-test"
    - "schema-validation"
```

### Disaster Recovery Automation

Automated disaster recovery procedures:

```yaml
disasterRecovery:
  enabled: true
  automation:
    enabled: true
    triggers:
      - "health-check-failure"
      - "manual-trigger"
    procedures:
      - "validate-backups"
      - "create-recovery-plan"
      - "execute-restore"
      - "verify-recovery"
```

## 📊 Monitoring and Metrics

### Prometheus Metrics

The framework exposes comprehensive metrics:

```
# Backup job metrics
backup_job_success{database="airflow",type="postgresql"} 1
backup_job_duration_seconds{database="airflow",type="postgresql"} 45.2
backup_size_bytes{database="airflow",type="postgresql"} 1048576
backup_retention_days{database="airflow",type="postgresql"} 30

# Storage metrics
backup_storage_usage_bytes{provider="huawei-obs",bucket="k8s-dr-primary"} 5368709120
backup_storage_cost_usd{provider="huawei-obs",bucket="k8s-dr-primary"} 12.34

# Disaster recovery metrics
dr_rto_seconds{type="database"} 3600
dr_rpo_seconds{type="database"} 86400
dr_test_success{type="full-restore"} 1
```

### Grafana Dashboards

Pre-built dashboards for operational visibility:

- **Backup Overview**: Job success rates, storage usage, costs
- **Disaster Recovery**: RTO/RPO metrics, recovery test results
- **Performance**: Backup duration trends, storage growth
- **Alerting**: Active alerts, notification delivery status

## 🛠️ Manual Operations

### Trigger Manual Backup

```bash
# Database backup
kubectl create job --from=cronjob/postgres-backup-airflow \
  manual-backup-$(date +%Y%m%d-%H%M%S) -n backup-ops

# Configuration backup
kubectl create job --from=cronjob/config-backup-default \
  manual-config-backup-$(date +%Y%m%d-%H%M%S) -n backup-ops

# PVC backup
kubectl create job --from=cronjob/pvc-backup-airflow \
  manual-pvc-backup-$(date +%Y%m%d-%H%M%S) -n backup-ops
```

### Disaster Recovery Procedures

```bash
# List available backups
kubectl run backup-list --rm -it \
  --image=ghcr.io/pesnik/k8s-dr-framework:latest \
  --command -- /scripts/utils/list-backups.sh

# Execute full disaster recovery
kubectl run disaster-recovery --rm -it \
  --image=ghcr.io/pesnik/k8s-dr-framework:latest \
  --command -- /scripts/utils/disaster-recovery.sh \
  --backup-date="2024-03-15" \
  --recovery-type="full"

# Test disaster recovery (dry-run)
kubectl run dr-test --rm -it \
  --image=ghcr.io/pesnik/k8s-dr-framework:latest \
  --command -- /scripts/utils/disaster-recovery.sh \
  --backup-date="2024-03-15" \
  --recovery-type="full" \
  --dry-run
```

## 🔒 Security Features

### Encryption

- **At-rest encryption**: All backups encrypted using provider-managed keys
- **In-transit encryption**: TLS for all data transfers
- **Application-level encryption**: Additional encryption layer for sensitive data

### Access Control

- **RBAC**: Fine-grained permissions for backup operations
- **Network policies**: Restrict backup pod communications
- **Pod security policies**: Enforce security standards for backup pods

### Compliance

- **Audit logging**: All backup operations logged for compliance
- **Data retention**: Automated cleanup based on retention policies
- **Access logging**: Track all backup access and restoration activities

## 🧪 Testing Framework

### Unit Tests

```bash
# Run unit tests
./tests/unit/run-tests.sh

# Test specific component
./tests/unit/test-database-backup.sh postgres
```

### Integration Tests

```bash
# Run integration tests
./tests/integration/run-tests.sh

# Test backup-restore cycle
./tests/integration/test-backup-restore-cycle.sh
```

### End-to-End Tests

```bash
# Run full E2E tests
./tests/e2e/run-tests.sh

# Test disaster recovery
./tests/e2e/test-disaster-recovery.sh
```

## 🚧 Roadmap

### Phase 1: Core Functionality (Current)
- [x] Database backups (PostgreSQL, MySQL)
- [x] Configuration backups
- [x] Basic monitoring
- [x] Multi-cloud storage support

### Phase 2: Enhanced DR (Q2 2024)
- [ ] Automated disaster recovery
- [ ] Cross-cluster backup replication
- [ ] Advanced monitoring dashboards
- [ ] Performance optimization

### Phase 3: Enterprise Features (Q3 2024)
- [ ] Multi-tenancy support
- [ ] Advanced RBAC
- [ ] Compliance reporting
- [ ] Cost optimization

### Phase 4: ML/AI Integration (Q4 2024)
- [ ] Predictive backup scheduling
- [ ] Anomaly detection
- [ ] Automated recovery recommendations
- [ ] Intelligent retention policies

## 🤝 Contributing

We welcome contributions from the DevOps community! Please read our [Contributing Guidelines](CONTRIBUTING.md) for details on:

- **Code standards**: Coding conventions and best practices
- **Testing requirements**: Unit, integration, and E2E test coverage
- **Documentation**: Standards for documentation and examples
- **Review process**: Pull request and code review procedures

### Development Setup

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Set up development environment**: `./scripts/dev/setup.sh`
4. **Make your changes**
5. **Run tests**: `./scripts/dev/run-tests.sh`
6. **Submit a pull request**

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

Special thanks to:
- **Kubernetes community** for the robust platform
- **Helm maintainers** for the excellent package manager
- **Database communities** for reliable backup tools
- **Cloud providers** for storage solutions
- **Contributors** who make this project possible

## 📞 Support

- **Documentation**: [docs/](docs/)
- **Issues**: [GitHub Issues](https://github.com/pesnik/k8s-dr-framework/issues)
- **Discussions**: [GitHub Discussions](https://github.com/pesnik/k8s-dr-framework/discussions)
- **Security**: [Security Policy](SECURITY.md)
- **Community**: [Slack Channel](https://k8s-dr-framework.slack.com)

---

**Maintained by:** [@pesnik](https://github.com/pesnik)  
**License:** MIT  
**Version:** 1.0.0