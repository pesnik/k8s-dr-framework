# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

If you discover a security vulnerability in k8s-dr-framework, please report it responsibly:

1. **Do not** create a public GitHub issue
2. Email security concerns to: security@pesnik.dev
3. Include detailed information about the vulnerability
4. Provide steps to reproduce if possible

## Security Features

### Data Protection

- All backups are encrypted at rest
- In-transit encryption using TLS
- Support for customer-managed encryption keys
- Secure credential management using Kubernetes secrets

### Access Control

- RBAC implementation for fine-grained permissions
- Network policies to restrict pod communications
- Pod security policies for container security
- Service account isolation

### Monitoring

- Audit logging for all operations
- Security event monitoring
- Anomaly detection for unusual backup patterns
- Compliance reporting capabilities

## Security Best Practices

### Deployment

1. Use dedicated namespace for backup operations
2. Implement network policies
3. Regular security updates
4. Monitor backup job logs

### Credentials

1. Use Kubernetes secrets for sensitive data
2. Rotate credentials regularly
3. Implement least privilege access
4. Use service accounts with minimal permissions

### Storage

1. Enable encryption at rest
2. Use private storage buckets
3. Implement backup retention policies
4. Regular security audits

## Vulnerability Response

1. Acknowledgment within 24 hours
2. Initial assessment within 72 hours
3. Fix development and testing
4. Coordinated disclosure
5. Security advisory publication

## Security Updates

Security updates will be released as patch versions and announced through:

- GitHub Security Advisories
- Release notes
- Community channels

## Third-Party Dependencies

We regularly scan dependencies for vulnerabilities using:

- Dependabot alerts
- Trivy security scanner
- Snyk vulnerability scanning

## Compliance

The framework supports compliance requirements for:

- SOC 2 Type II
- ISO 27001
- GDPR data protection
- HIPAA (healthcare)
- PCI DSS (payment card industry)

For compliance questions, contact: compliance@pesnik.dev
