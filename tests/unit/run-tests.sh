#!/bin/bash

set -e

echo "🧪 Running unit tests..."

# Test database backup scripts
echo "Testing database backup scripts..."
./test-database-backup.sh postgres
./test-database-backup.sh mysql

# Test utility functions
echo "Testing utility functions..."
./test-utils.sh

# Test configuration validation
echo "Testing configuration validation..."
./test-config-validation.sh

echo "✅ All unit tests passed!"
