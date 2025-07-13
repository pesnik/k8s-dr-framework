#!/bin/bash
set -e

# Kubernetes Manifest Backup Script
echo "🚀 Starting Kubernetes manifest backup..."

# Validate required environment variables
: ${NAMESPACE:?"NAMESPACE is required"}
: ${RESOURCES:?"RESOURCES is required"}

BACKUP_DIR=${BACKUP_DIR:-"/tmp/backup"}
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="k8s-manifests_${NAMESPACE}_${TIMESTAMP}.tar.gz"

echo "📦 Backing up namespace: $NAMESPACE"
echo "🔧 Resources: $RESOURCES"

# Create backup directory
mkdir -p "$BACKUP_DIR/manifests/$NAMESPACE"

# Split resources by comma and backup each type
IFS=',' read -ra RESOURCE_ARRAY <<< "$RESOURCES"
for resource in "${RESOURCE_ARRAY[@]}"; do
    echo "📋 Backing up $resource resources..."
    kubectl get "$resource" -n "$NAMESPACE" -o yaml > "$BACKUP_DIR/manifests/$NAMESPACE/$resource.yaml"
done

# Create compressed archive
cd "$BACKUP_DIR"
tar -czf "$BACKUP_FILE" manifests/

echo "📊 Backup size: $(du -h $BACKUP_FILE | cut -f1)"
echo "✅ Kubernetes manifest backup completed: $BACKUP_FILE"

# Upload to storage (if configured)
if [[ -n "$STORAGE_PROVIDER" ]]; then
    echo "☁️ Uploading to storage..."
    /scripts/utils/upload.sh "$BACKUP_DIR/$BACKUP_FILE"
fi
