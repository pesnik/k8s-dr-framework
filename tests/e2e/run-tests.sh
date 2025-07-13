#!/bin/bash

set -e

echo "🧪 Running E2E tests..."

# Test full disaster recovery
echo "Testing full disaster recovery..."
./test-disaster-recovery.sh

# Test multi-cloud failover
echo "Testing multi-cloud failover..."
./test-multi-cloud-failover.sh

# Test monitoring and alerting
echo "Testing monitoring and alerting..."
./test-monitoring-alerting.sh

echo "✅ All E2E tests passed!"
