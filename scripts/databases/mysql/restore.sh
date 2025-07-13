#!/bin/bash
set -euo pipefail

# MySQL restore script
source /scripts/utils/common.sh

DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-3306}
DB_NAME=${DB_NAME:-mysql}
DB_USER=${DB_USER:-root}
BACKUP_FILE=${1:-}

if [ -z "${BACKUP_FILE}" ]; then
    log_error "Backup file not specified"
    exit 1
fi

log_info "Starting MySQL restore for database: ${DB_NAME}"

# Download backup from storage
/scripts/utils/download.sh "${BACKUP_FILE}" "/tmp/${BACKUP_FILE}"

# Decompress if needed
if [[ "${BACKUP_FILE}" == *.gz ]]; then
    gunzip "/tmp/${BACKUP_FILE}"
    BACKUP_FILE="${BACKUP_FILE%.gz}"
fi

# Restore database
mysql -h "${DB_HOST}" -P "${DB_PORT}" -u "${DB_USER}" -p"${MYSQL_PASSWORD}" \
  "${DB_NAME}" < "/tmp/${BACKUP_FILE}"

if [ $? -eq 0 ]; then
    log_info "Database restore completed successfully"
    rm -f "/tmp/${BACKUP_FILE}"
else
    log_error "Database restore failed"
    exit 1
fi
