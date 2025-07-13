#!/bin/bash

set -e

echo "🧪 Testing storage integration..."

# Test storage connectivity
kubectl run test-storage --rm -it --image=ghcr.io/pesnik/k8s-dr-framework:latest -- /scripts/utils/test-storage.sh

# Test file upload/download
kubectl run test-upload --rm -it --image=ghcr.io/pesnik/k8s-dr-framework:latest -- /scripts/utils/upload.sh test-file.txt

kubectl run test-download --rm -it --image=ghcr.io/pesnik/k8s-dr-framework:latest -- /scripts/utils/download.sh test-file.txt

echo "✅ Storage integration test passed!"
