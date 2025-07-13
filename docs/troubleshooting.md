# Troubleshooting Guide

## Common Issues

### Backup Job Failures
- **Symptoms**: CronJob pods failing
- **Diagnosis**: `kubectl logs -n backup-ops <pod-name>`
- **Solutions**: Check credentials, storage connectivity, resource limits

### Storage Issues
- **Symptoms**: Upload failures, authentication errors
- **Diagnosis**: Test storage connectivity manually
- **Solutions**: Verify credentials, check bucket permissions

### Monitoring Issues
- **Symptoms**: Missing metrics, alert failures
- **Diagnosis**: Check ServiceMonitor, Prometheus targets
- **Solutions**: Verify RBAC, endpoint connectivity

## Debug Commands
```bash
# Check backup job status
kubectl get cronjobs -n backup-ops

# View recent job logs
kubectl logs -n backup-ops -l app.kubernetes.io/name=dr-core

# Test storage connectivity
kubectl run debug-storage --rm -it --image=ghcr.io/pesnik/k8s-dr-framework:latest -- /scripts/utils/test-storage.sh
```

## Recovery Procedures
Refer to the runbooks in `docs/runbooks/` for specific recovery scenarios.
