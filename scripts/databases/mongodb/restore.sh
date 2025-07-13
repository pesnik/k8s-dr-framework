#!/bin/bash
set -euo pipefail

# MongoDB restore script
source /scripts/utils/common.sh

DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-27017}
DB_NAME=${DB_NAME:-admin}
DB_USER=${DB_USER:-admin}
BACKUP_FILE=${1:-}

if [ -z "${BACKUP_FILE}" ]; then
    log_error "Backup file not specified"
    exit 1
fi

log_info "Starting MongoDB restore for database: ${DB_NAME}"

# Download backup from storage
/scripts/utils/download.sh "${BACKUP_FILE}" "/tmp/${BACKUP_FILE}"

# Extract backup
tar -xzf "/tmp/${BACKUP_FILE}" -C "/tmp"
BACKUP_DIR="/tmp/$(basename "${BACKUP_FILE}" .tar.gz)"

# Restore database using mongorestore
mongorestore --host "${DB_HOST}:${DB_PORT}" --db "${DB_NAME}" \
  --username "${DB_USER}" --password "${MONGO_PASSWORD}" \
  --drop "${BACKUP_DIR}/${DB_NAME}"

if [ $? -eq 0 ]; then
    log_info "Database restore completed successfully"
    rm -rf "${BACKUP_DIR}" "/tmp/${BACKUP_FILE}"
else
    log_error "Database restore failed"
    exit 1
fi
