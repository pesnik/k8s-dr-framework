#!/bin/bash
set -euo pipefail

# Upload utility script for various storage providers
source /scripts/utils/common.sh

LOCAL_FILE=${1:-}
REMOTE_PATH=${2:-}

if [ -z "${LOCAL_FILE}" ] || [ -z "${REMOTE_PATH}" ]; then
    log_error "Usage: $0 <local_file> <remote_path>"
    exit 1
fi

# Check if file exists
if [ ! -f "${LOCAL_FILE}" ]; then
    log_error "Local file does not exist: ${LOCAL_FILE}"
    exit 1
fi

log_info "Uploading ${LOCAL_FILE} to ${REMOTE_PATH}"

# Determine storage provider and upload
case "${STORAGE_PROVIDER:-s3}" in
    "s3"|"aws-s3")
        aws s3 cp "${LOCAL_FILE}" "s3://${STORAGE_BUCKET}/${REMOTE_PATH}"
        ;;
    "huawei-obs")
        obsutil cp "${LOCAL_FILE}" "obs://${STORAGE_BUCKET}/${REMOTE_PATH}"
        ;;
    "minio")
        mc cp "${LOCAL_FILE}" "minio/${STORAGE_BUCKET}/${REMOTE_PATH}"
        ;;
    "gcp-gcs")
        gsutil cp "${LOCAL_FILE}" "gs://${STORAGE_BUCKET}/${REMOTE_PATH}"
        ;;
    *)
        log_error "Unsupported storage provider: ${STORAGE_PROVIDER}"
        exit 1
        ;;
esac

if [ $? -eq 0 ]; then
    log_info "Upload completed successfully"
    
    # Send notification
    /scripts/utils/notify.sh "Backup uploaded successfully: ${REMOTE_PATH}"
else
    log_error "Upload failed"
    /scripts/utils/notify.sh "Backup upload failed: ${REMOTE_PATH}"
    exit 1
fi
