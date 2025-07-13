#!/bin/bash

set -e

echo "🧪 Testing monitoring and alerting..."

# Create a failing backup job to trigger alerts
kubectl create job failing-backup --from=cronjob/postgres-backup-test -n backup-ops
kubectl patch job failing-backup -n backup-ops --patch='{"spec":{"template":{"spec":{"containers":[{"name":"backup","command":["sh","-c","exit 1"]}]}}}}'

# Wait for job to fail
kubectl wait --for=condition=Failed job/failing-backup -n backup-ops --timeout=300s

# Check if alert was triggered (this would depend on your alerting setup)
echo "Manual verification required: Check if backup failure alert was triggered"

# Cleanup
kubectl delete job failing-backup -n backup-ops

echo "✅ Monitoring and alerting test completed!"
