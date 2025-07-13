#!/bin/bash

set -e

echo "🚨 Starting Disaster Recovery Drill..."

# Set drill parameters
DRILL_DATE=$(date +%Y%m%d-%H%M%S)
BACKUP_DATE=${1:-$(date -d "1 day ago" +%Y-%m-%d)}
RECOVERY_TYPE=${2:-"full"}

echo "📋 Drill Parameters:"
echo "  - Drill ID: $DRILL_DATE"
echo "  - Backup Date: $BACKUP_DATE"
echo "  - Recovery Type: $RECOVERY_TYPE"

# Create drill namespace
kubectl create namespace dr-drill-$DRILL_DATE || true

# Execute recovery
kubectl run disaster-recovery-drill-$DRILL_DATE \
  --rm -it \
  --image=ghcr.io/pesnik/k8s-dr-framework:latest \
  --namespace=dr-drill-$DRILL_DATE \
  --command -- /scripts/utils/disaster-recovery.sh \
  --backup-date="$BACKUP_DATE" \
  --recovery-type="$RECOVERY_TYPE" \
  --drill-mode=true

echo "✅ Disaster Recovery Drill completed!"
