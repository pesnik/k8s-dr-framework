#!/bin/bash
set -e

# etcd Backup Script
echo "🚀 Starting etcd backup process..."

# Validate required environment variables
: ${ETCD_ENDPOINTS:?"ETCD_ENDPOINTS is required"}

BACKUP_DIR=${BACKUP_DIR:-"/tmp/backup"}
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="etcd_${TIMESTAMP}.db"

echo "📦 Backing up etcd cluster"
echo "🏠 Endpoints: $ETCD_ENDPOINTS"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Create etcd backup
etcdctl snapshot save "$BACKUP_DIR/$BACKUP_FILE" \
    --endpoints="$ETCD_ENDPOINTS" \
    --cacert="${ETCD_CA_FILE:-/etc/etcd/ca.crt}" \
    --cert="${ETCD_CERT_FILE:-/etc/etcd/server.crt}" \
    --key="${ETCD_KEY_FILE:-/etc/etcd/server.key}"

# Verify backup
etcdctl snapshot status "$BACKUP_DIR/$BACKUP_FILE" \
    --write-out=table

echo "📊 Backup size: $(du -h $BACKUP_DIR/$BACKUP_FILE | cut -f1)"
echo "✅ etcd backup completed: $BACKUP_FILE"

# Upload to storage (if configured)
if [[ -n "$STORAGE_PROVIDER" ]]; then
    echo "☁️ Uploading to storage..."
    /scripts/utils/upload.sh "$BACKUP_DIR/$BACKUP_FILE"
fi
