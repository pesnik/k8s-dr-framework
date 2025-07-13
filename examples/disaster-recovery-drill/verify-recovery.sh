#!/bin/bash

set -e

echo "�� Verifying Disaster Recovery..."

DRILL_NAMESPACE=${1:-"dr-drill-$(date +%Y%m%d)"}

# Run verification tests
kubectl run verify-recovery \
  --rm -it \
  --image=ghcr.io/pesnik/k8s-dr-framework:latest \
  --namespace=$DRILL_NAMESPACE \
  --command -- /scripts/utils/verify-recovery.sh

echo "✅ Recovery verification completed!"
