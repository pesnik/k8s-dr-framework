#!/bin/bash
set -euo pipefail

# Validation utility script
source /scripts/utils/common.sh

BACKUP_FILE=${1:-}

if [ -z "${BACKUP_FILE}" ]; then
    log_error "Usage: $0 <backup_file>"
    exit 1
fi

log_info "Validating backup file: ${BACKUP_FILE}"

# Check if file exists
if [ ! -f "${BACKUP_FILE}" ]; then
    log_error "Backup file does not exist: ${BACKUP_FILE}"
    exit 1
fi

# Check file size
FILE_SIZE=$(file_size "${BACKUP_FILE}")
if [ "${FILE_SIZE}" -eq 0 ]; then
    log_error "Backup file is empty: ${BACKUP_FILE}"
    exit 1
fi

# Check file type and validate accordingly
MIME_TYPE=$(file -b --mime-type "${BACKUP_FILE}")

case "${MIME_TYPE}" in
    "application/x-gzip"|"application/gzip")
        log_info "Validating gzip file"
        gzip -t "${BACKUP_FILE}"
        ;;
    "application/x-tar")
        log_info "Validating tar file"
        tar -tf "${BACKUP_FILE}" > /dev/null
        ;;
    "text/plain")
        log_info "Validating plain text file (SQL dump)"
        head -1 "${BACKUP_FILE}" | grep -q "-- \|CREATE\|INSERT\|DROP"
        ;;
    *)
        log_warn "Unknown file type: ${MIME_TYPE}, skipping validation"
        ;;
esac

if [ $? -eq 0 ]; then
    log_info "Backup validation successful"
    log_info "File size: ${FILE_SIZE} bytes"
else
    log_error "Backup validation failed"
    exit 1
fi
