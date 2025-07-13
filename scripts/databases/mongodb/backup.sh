#!/bin/bash
set -euo pipefail

# MongoDB backup script
source /scripts/utils/common.sh

DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-27017}
DB_NAME=${DB_NAME:-admin}
DB_USER=${DB_USER:-admin}
BACKUP_PREFIX=${BACKUP_PREFIX:-mongodb}
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/tmp/${BACKUP_PREFIX}_${DB_NAME}_${TIMESTAMP}"

log_info "Starting MongoDB backup for database: ${DB_NAME}"

# Create backup directory
mkdir -p "${BACKUP_DIR}"

# Create backup using mongodump
mongodump --host "${DB_HOST}:${DB_PORT}" --db "${DB_NAME}" \
  --username "${DB_USER}" --password "${MONGO_PASSWORD}" \
  --out "${BACKUP_DIR}"

if [ $? -eq 0 ]; then
    log_info "Database backup completed successfully"
    
    # Create tar archive
    tar -czf "${BACKUP_DIR}.tar.gz" -C "/tmp" "$(basename "${BACKUP_DIR}")"
    
    # Upload to storage
    /scripts/utils/upload.sh "${BACKUP_DIR}.tar.gz" "$(basename "${BACKUP_DIR}").tar.gz"
    
    # Clean up local files
    rm -rf "${BACKUP_DIR}" "${BACKUP_DIR}.tar.gz"
    
    log_info "Backup uploaded and cleaned up"
else
    log_error "Database backup failed"
    exit 1
fi
