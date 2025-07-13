#!/bin/bash
set -euo pipefail

# MongoDB backup verification script
source /scripts/utils/common.sh

BACKUP_FILE=${1:-}

if [ -z "${BACKUP_FILE}" ]; then
    log_error "Backup file not specified"
    exit 1
fi

log_info "Verifying MongoDB backup: ${BACKUP_FILE}"

# Download and verify backup
/scripts/utils/download.sh "${BACKUP_FILE}" "/tmp/${BACKUP_FILE}"

# Extract and check backup structure
tar -tzf "/tmp/${BACKUP_FILE}" | head -5

if [ $? -eq 0 ]; then
    log_info "Backup verification successful"
    rm -f "/tmp/${BACKUP_FILE}"
else
    log_error "Backup verification failed"
    exit 1
fi
