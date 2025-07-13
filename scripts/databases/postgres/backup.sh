#!/bin/bash
set -euo pipefail

# PostgreSQL backup script
source /scripts/utils/common.sh

DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-5432}
DB_NAME=${DB_NAME:-postgres}
DB_USER=${DB_USER:-postgres}
BACKUP_PREFIX=${BACKUP_PREFIX:-postgres}
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_PREFIX}_${DB_NAME}_${TIMESTAMP}.sql"

log_info "Starting PostgreSQL backup for database: ${DB_NAME}"

# Create backup
pg_dump -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d "${DB_NAME}" \
  --verbose --no-owner --no-acl --format=custom > "/tmp/${BACKUP_FILE}"

if [ $? -eq 0 ]; then
    log_info "Database backup completed successfully"
    
    # Upload to storage
    /scripts/utils/upload.sh "/tmp/${BACKUP_FILE}" "${BACKUP_FILE}"
    
    # Clean up local file
    rm -f "/tmp/${BACKUP_FILE}"
    
    log_info "Backup uploaded and cleaned up"
else
    log_error "Database backup failed"
    exit 1
fi
