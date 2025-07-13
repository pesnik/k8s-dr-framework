# Security Best Practices

This guide outlines security best practices for the k8s-dr-framework.

## Encryption

### At-Rest Encryption

```yaml
storage:
  encryption:
    enabled: true
    kmsKeyId: "your-kms-key-id"
    algorithm: "AES256"
```

### In-Transit Encryption

- All data transfers use TLS 1.2+
- Certificate validation enabled
- Perfect Forward Secrecy (PFS) supported

## Access Control

### RBAC Configuration

```yaml
rbac:
  create: true
  rules:
    - apiGroups: [""]
      resources: ["secrets", "configmaps"]
      verbs: ["get", "list"]
    - apiGroups: ["batch"]
      resources: ["jobs", "cronjobs"]
      verbs: ["create", "get", "list", "watch"]
```

### Service Account

```yaml
serviceAccount:
  create: true
  name: backup-operator
  annotations:
    eks.amazonaws.com/role-arn: "arn:aws:iam::123456789012:role/backup-role"
```

## Network Security

### Network Policies

```yaml
networkPolicy:
  enabled: true
  ingress:
    - from:
      - namespaceSelector:
          matchLabels:
            name: monitoring
      ports:
      - protocol: TCP
        port: 8080
```

### Pod Security

```yaml
podSecurityContext:
  runAsNonRoot: true
  runAsUser: 1000
  fsGroup: 2000
  
securityContext:
  allowPrivilegeEscalation: false
  readOnlyRootFilesystem: true
  capabilities:
    drop:
    - ALL
```

## Secrets Management

### External Secrets

```yaml
externalSecrets:
  enabled: true
  secretStore:
    name: vault-secret-store
    kind: SecretStore
```

### Sealed Secrets

```yaml
sealedSecrets:
  enabled: true
  controller:
    name: sealed-secrets-controller
    namespace: kube-system
```

## Audit and Compliance

### Audit Logging

```yaml
audit:
  enabled: true
  webhook:
    url: "https://audit-collector.company.com/webhook"
```

### Compliance Scanning

```yaml
compliance:
  enabled: true
  standards:
    - PCI-DSS
    - SOC2
    - GDPR
```
