#!/bin/bash

set -e

echo "🧪 Testing monitoring integration..."

# Check if ServiceMonitor is created
kubectl get servicemonitor -n backup-ops dr-core-metrics

# Check if metrics endpoint is accessible
kubectl port-forward -n backup-ops svc/dr-core-metrics 8080:8080 &
PORT_FORWARD_PID=$!

sleep 5

# Test metrics endpoint
curl -s http://localhost:8080/metrics | grep -q "backup_job_success"

# Cleanup
kill $PORT_FORWARD_PID

echo "✅ Monitoring integration test passed!"
