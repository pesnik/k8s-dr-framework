#!/bin/bash

set -e

echo "🧪 Testing utility functions..."

# Test common utilities
source ../../scripts/utils/common.sh

# Test log function
test_log_function() {
    local test_message="Test log message"
    log_info "$test_message"
    log_error "$test_message"
    log_debug "$test_message"
    echo "✅ Log function tests passed"
}

# Test encryption utilities
test_encryption_utilities() {
    echo "Testing encryption utilities..."
    bash -n ../../scripts/utils/encryption.sh
    echo "✅ Encryption utilities syntax OK"
}

# Test validation utilities
test_validation_utilities() {
    echo "Testing validation utilities..."
    bash -n ../../scripts/utils/validation.sh
    echo "✅ Validation utilities syntax OK"
}

# Run tests
test_log_function
test_encryption_utilities
test_validation_utilities

echo "✅ All utility tests passed!"
