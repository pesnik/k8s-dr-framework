#!/bin/bash
set -euo pipefail

# MySQL backup script
source /scripts/utils/common.sh

DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-3306}
DB_NAME=${DB_NAME:-mysql}
DB_USER=${DB_USER:-root}
BACKUP_PREFIX=${BACKUP_PREFIX:-mysql}
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_PREFIX}_${DB_NAME}_${TIMESTAMP}.sql"

log_info "Starting MySQL backup for database: ${DB_NAME}"

# Create backup
mysqldump -h "${DB_HOST}" -P "${DB_PORT}" -u "${DB_USER}" -p"${MYSQL_PASSWORD}" \
  --single-transaction --routines --triggers "${DB_NAME}" > "/tmp/${BACKUP_FILE}"

if [ $? -eq 0 ]; then
    log_info "Database backup completed successfully"
    
    # Compress backup
    gzip "/tmp/${BACKUP_FILE}"
    BACKUP_FILE="${BACKUP_FILE}.gz"
    
    # Upload to storage
    /scripts/utils/upload.sh "/tmp/${BACKUP_FILE}" "${BACKUP_FILE}"
    
    # Clean up local file
    rm -f "/tmp/${BACKUP_FILE}"
    
    log_info "Backup uploaded and cleaned up"
else
    log_error "Database backup failed"
    exit 1
fi
