#!/bin/bash

set -e

echo "🧪 Running integration tests..."

# Test backup-restore cycle
echo "Testing backup-restore cycle..."
./test-backup-restore-cycle.sh

# Test monitoring integration
echo "Testing monitoring integration..."
./test-monitoring-integration.sh

# Test storage integration
echo "Testing storage integration..."
./test-storage-integration.sh

echo "✅ All integration tests passed!"
