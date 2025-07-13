#!/bin/bash

set -e

echo "🧪 Testing backup-restore cycle..."

# Create test namespace
kubectl create namespace test-backup-restore || true

# Deploy test database
kubectl run test-postgres --image=postgres:13 --env="POSTGRES_PASSWORD=test123" -n test-backup-restore

# Wait for database to be ready
kubectl wait --for=condition=Ready pod/test-postgres -n test-backup-restore --timeout=120s

# Create test data
kubectl exec test-postgres -n test-backup-restore -- psql -U postgres -c "CREATE TABLE test_table (id INTEGER, name VARCHAR(50));"
kubectl exec test-postgres -n test-backup-restore -- psql -U postgres -c "INSERT INTO test_table VALUES (1, 'test_data');"

# Run backup
kubectl create job test-backup --from=cronjob/postgres-backup-test -n backup-ops

# Wait for backup to complete
kubectl wait --for=condition=Complete job/test-backup -n backup-ops --timeout=300s

# Simulate disaster (delete test data)
kubectl exec test-postgres -n test-backup-restore -- psql -U postgres -c "DROP TABLE test_table;"

# Run restore
kubectl run test-restore --rm -it --image=ghcr.io/pesnik/k8s-dr-framework:latest -- /scripts/databases/postgres/restore.sh

# Verify restore
kubectl exec test-postgres -n test-backup-restore -- psql -U postgres -c "SELECT * FROM test_table;"

# Cleanup
kubectl delete namespace test-backup-restore

echo "✅ Backup-restore cycle test passed!"
