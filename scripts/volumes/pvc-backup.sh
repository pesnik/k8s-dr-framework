#!/bin/bash
set -e

# PVC Backup Script
echo "🚀 Starting PVC backup process..."

# Validate required environment variables
: ${PVC_NAME:?"PVC_NAME is required"}
: ${PVC_NAMESPACE:?"PVC_NAMESPACE is required"}

BACKUP_DIR=${BACKUP_DIR:-"/tmp/backup"}
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="pvc_${PVC_NAME}_${TIMESTAMP}.tar.gz"

echo "📦 Backing up PVC: $PVC_NAME"
echo "🏠 Namespace: $PVC_NAMESPACE"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Create backup pod
kubectl run pvc-backup-pod \
    --image=busybox \
    --rm -i --restart=Never \
    --overrides='{
        "apiVersion": "v1",
        "spec": {
            "containers": [{
                "name": "backup",
                "image": "busybox",
                "command": ["tar", "czf", "/backup/'$BACKUP_FILE'", "/data"],
                "volumeMounts": [
                    {"name": "data", "mountPath": "/data"},
                    {"name": "backup", "mountPath": "/backup"}
                ]
            }],
            "volumes": [
                {"name": "data", "persistentVolumeClaim": {"claimName": "'$PVC_NAME'"}},
                {"name": "backup", "hostPath": {"path": "'$BACKUP_DIR'"}}
            ]
        }
    }' \
    --namespace="$PVC_NAMESPACE"

echo "📊 Backup size: $(du -h $BACKUP_DIR/$BACKUP_FILE | cut -f1)"
echo "✅ PVC backup completed: $BACKUP_FILE"

# Upload to storage (if configured)
if [[ -n "$STORAGE_PROVIDER" ]]; then
    echo "☁️ Uploading to storage..."
    /scripts/utils/upload.sh "$BACKUP_DIR/$BACKUP_FILE"
fi
