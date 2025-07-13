#!/bin/bash

set -e

echo "🧪 Testing configuration validation..."

# Test Helm chart validation
helm lint ../../charts/dr-core
echo "✅ Helm chart validation passed"

# Test values file validation
helm template test ../../charts/dr-core --values ../../charts/dr-core/values.yaml > /dev/null
echo "✅ Values file validation passed"

echo "✅ All configuration validation tests passed!"
