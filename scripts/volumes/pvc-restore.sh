#!/bin/bash
set -e

# PVC Restore Script
echo "🔄 Starting PVC restore process..."

# Validate required environment variables
: ${PVC_NAME:?"PVC_NAME is required"}
: ${PVC_NAMESPACE:?"PVC_NAMESPACE is required"}
: ${BACKUP_FILE:?"BACKUP_FILE is required"}

echo "📦 Restoring PVC: $PVC_NAME"
echo "🏠 Namespace: $PVC_NAMESPACE"

# Download backup file if it's a remote URL
if [[ $BACKUP_FILE == http* ]]; then
    echo "📥 Downloading backup file..."
    curl -L "$BACKUP_FILE" -o /tmp/backup.tar.gz
    BACKUP_FILE="/tmp/backup.tar.gz"
fi

# Create restore pod
kubectl run pvc-restore-pod \
    --image=busybox \
    --rm -i --restart=Never \
    --overrides='{
        "apiVersion": "v1",
        "spec": {
            "containers": [{
                "name": "restore",
                "image": "busybox",
                "command": ["tar", "xzf", "/backup/'$(basename $BACKUP_FILE)'", "-C", "/data"],
                "volumeMounts": [
                    {"name": "data", "mountPath": "/data"},
                    {"name": "backup", "mountPath": "/backup"}
                ]
            }],
            "volumes": [
                {"name": "data", "persistentVolumeClaim": {"claimName": "'$PVC_NAME'"}},
                {"name": "backup", "hostPath": {"path": "'$(dirname $BACKUP_FILE)'"}}
            ]
        }
    }' \
    --namespace="$PVC_NAMESPACE"

echo "✅ PVC restore completed successfully"
