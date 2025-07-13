# Contributing to k8s-dr-framework

Thank you for your interest in contributing to k8s-dr-framework! This document provides guidelines and instructions for contributing to the project.

## Code of Conduct

This project adheres to a Code of Conduct. By participating, you are expected to uphold this code.

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in [Issues](https://github.com/pesnik/k8s-dr-framework/issues)
2. If not, create a new issue using the bug report template
3. Provide detailed information about the bug and steps to reproduce

### Suggesting Features

1. Check if the feature has already been suggested
2. Create a new issue using the feature request template
3. Describe the feature and its use case clearly

### Pull Requests

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes
4. Add tests for your changes
5. Ensure all tests pass
6. Update documentation if necessary
7. Submit a pull request

## Development Setup

### Prerequisites

- Kubernetes cluster (1.20+)
- Helm 3.0+
- Docker
- kubectl
- Go 1.19+ (for testing)

### Local Development

```bash
# Clone the repository
git clone https://github.com/pesnik/k8s-dr-framework.git
cd k8s-dr-framework

# Set up development environment
./scripts/dev/setup.sh

# Run tests
./scripts/dev/run-tests.sh

# Lint code
./scripts/dev/lint.sh
```

## Coding Standards

### Shell Scripts

- Use `#!/bin/bash` shebang
- Use `set -e` for error handling
- Follow Google Shell Style Guide
- Add proper error handling and logging

### Helm Charts

- Follow Helm best practices
- Use semantic versioning
- Include comprehensive documentation
- Test templates thoroughly

### Docker

- Use multi-stage builds when appropriate
- Follow security best practices
- Minimize image size
- Use specific base image tags

## Testing

### Unit Tests

- Write unit tests for all new functions
- Ensure 80%+ code coverage
- Use descriptive test names

### Integration Tests

- Test complete backup/restore workflows
- Verify multi-cloud functionality
- Test error scenarios

### End-to-End Tests

- Test in real Kubernetes environments
- Verify disaster recovery procedures
- Test monitoring and alerting

## Documentation

- Update README.md for new features
- Add runbook entries for operational procedures
- Include configuration examples
- Write clear, concise documentation

## Review Process

1. All PRs require review from maintainers
2. Tests must pass
3. Documentation must be updated
4. Code must follow project standards

## Release Process

1. Update version in Chart.yaml
2. Update CHANGELOG.md
3. Create release tag
4. GitHub Actions will handle Docker image builds and Helm chart packaging

## Getting Help

- Join our [Slack channel](https://k8s-dr-framework.slack.com)
- Check [GitHub Discussions](https://github.com/pesnik/k8s-dr-framework/discussions)
- Review existing [Issues](https://github.com/pesnik/k8s-dr-framework/issues)

Thank you for contributing to k8s-dr-framework!
