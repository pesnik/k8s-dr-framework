#!/bin/bash
set -e

# Kubernetes Manifest Restore Script
echo "🔄 Starting Kubernetes manifest restore..."

# Validate required environment variables
: ${NAMESPACE:?"NAMESPACE is required"}
: ${BACKUP_FILE:?"BACKUP_FILE is required"}

echo "📦 Restoring to namespace: $NAMESPACE"

# Download backup file if it's a remote URL
if [[ $BACKUP_FILE == http* ]]; then
    echo "📥 Downloading backup file..."
    curl -L "$BACKUP_FILE" -o /tmp/backup.tar.gz
    BACKUP_FILE="/tmp/backup.tar.gz"
fi

# Extract backup
RESTORE_DIR="/tmp/restore"
mkdir -p "$RESTORE_DIR"
cd "$RESTORE_DIR"
tar -xzf "$BACKUP_FILE"

# Apply manifests
echo "🔄 Applying manifests..."
for manifest in manifests/$NAMESPACE/*.yaml; do
    if [[ -f "$manifest" ]]; then
        echo "📋 Applying $(basename $manifest)..."
        kubectl apply -f "$manifest" -n "$NAMESPACE"
    fi
done

echo "✅ Kubernetes manifest restore completed"
