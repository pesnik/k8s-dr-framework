#!/bin/bash
set -euo pipefail

# PostgreSQL restore script
source /scripts/utils/common.sh

DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-5432}
DB_NAME=${DB_NAME:-postgres}
DB_USER=${DB_USER:-postgres}
BACKUP_FILE=${1:-}

if [ -z "${BACKUP_FILE}" ]; then
    log_error "Backup file not specified"
    exit 1
fi

log_info "Starting PostgreSQL restore for database: ${DB_NAME}"

# Download backup from storage
/scripts/utils/download.sh "${BACKUP_FILE}" "/tmp/${BACKUP_FILE}"

# Restore database
pg_restore -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d "${DB_NAME}" \
  --verbose --clean --if-exists "/tmp/${BACKUP_FILE}"

if [ $? -eq 0 ]; then
    log_info "Database restore completed successfully"
    rm -f "/tmp/${BACKUP_FILE}"
else
    log_error "Database restore failed"
    exit 1
fi
