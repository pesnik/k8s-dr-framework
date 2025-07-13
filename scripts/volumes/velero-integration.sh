#!/bin/bash
set -e

# Velero Integration Script
echo "🚀 Starting Velero backup integration..."

# Validate required environment variables
: ${BACKUP_NAME:?"BACKUP_NAME is required"}

NAMESPACE=${NAMESPACE:-"default"}
INCLUDE_RESOURCES=${INCLUDE_RESOURCES:-""}
EXCLUDE_RESOURCES=${EXCLUDE_RESOURCES:-""}

echo "📦 Creating Velero backup: $BACKUP_NAME"
echo "🏠 Namespace: $NAMESPACE"

# Build velero command
VELERO_CMD="velero backup create $BACKUP_NAME --include-namespaces $NAMESPACE"

if [[ -n "$INCLUDE_RESOURCES" ]]; then
    VELERO_CMD="$VELERO_CMD --include-resources $INCLUDE_RESOURCES"
fi

if [[ -n "$EXCLUDE_RESOURCES" ]]; then
    VELERO_CMD="$VELERO_CMD --exclude-resources $EXCLUDE_RESOURCES"
fi

# Execute backup
eval "$VELERO_CMD"

# Wait for backup completion
echo "⏳ Waiting for backup to complete..."
velero backup wait "$BACKUP_NAME"

# Check backup status
BACKUP_STATUS=$(velero backup get "$BACKUP_NAME" -o json | jq -r '.status.phase')
echo "📊 Backup status: $BACKUP_STATUS"

if [[ "$BACKUP_STATUS" == "Completed" ]]; then
    echo "✅ Velero backup completed successfully"
else
    echo "❌ Velero backup failed"
    exit 1
fi
