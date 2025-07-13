#!/bin/bash

set -e

echo "🧪 Testing multi-cloud failover..."

# Test primary storage failure simulation
echo "Simulating primary storage failure..."

# Switch to secondary storage
kubectl patch configmap dr-core-config -n backup-ops --patch='{"data":{"storage.provider":"aws-s3"}}'

# Run backup with secondary storage
kubectl create job failover-backup --from=cronjob/postgres-backup-test -n backup-ops

# Wait for backup
kubectl wait --for=condition=Complete job/failover-backup -n backup-ops --timeout=300s

# Restore primary storage
kubectl patch configmap dr-core-config -n backup-ops --patch='{"data":{"storage.provider":"huawei-obs"}}'

echo "✅ Multi-cloud failover test passed!"
