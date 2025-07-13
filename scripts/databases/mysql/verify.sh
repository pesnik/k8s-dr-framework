#!/bin/bash
set -euo pipefail

# MySQL backup verification script
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

log_info "Verifying MySQL backup: ${BACKUP_FILE}"

# Download and verify backup
/scripts/utils/download.sh "${BACKUP_FILE}" "/tmp/${BACKUP_FILE}"

# Decompress if needed
if [[ "${BACKUP_FILE}" == *.gz ]]; then
    gunzip "/tmp/${BACKUP_FILE}"
    BACKUP_FILE="${BACKUP_FILE%.gz}"
fi

# Check if backup is valid SQL
if grep -q "CREATE TABLE\|INSERT INTO\|DROP TABLE" "/tmp/${BACKUP_FILE}"; then
    log_info "Backup verification successful"
    rm -f "/tmp/${BACKUP_FILE}"
else
    log_error "Backup verification failed"
    exit 1
fi
