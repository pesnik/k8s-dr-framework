#!/bin/bash
set -euo pipefail

# PostgreSQL backup verification script
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

log_info "Verifying PostgreSQL backup: ${BACKUP_FILE}"

# Download and verify backup
/scripts/utils/download.sh "${BACKUP_FILE}" "/tmp/${BACKUP_FILE}"

# Check if backup is valid
pg_restore --list "/tmp/${BACKUP_FILE}" > /dev/null 2>&1

if [ $? -eq 0 ]; then
    log_info "Backup verification successful"
    rm -f "/tmp/${BACKUP_FILE}"
else
    log_error "Backup verification failed"
    exit 1
fi
