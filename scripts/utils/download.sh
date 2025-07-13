#!/bin/bash
set -euo pipefail

# Download utility script for various storage providers
source /scripts/utils/common.sh

REMOTE_PATH=${1:-}
LOCAL_FILE=${2:-}

if [ -z "${REMOTE_PATH}" ] || [ -z "${LOCAL_FILE}" ]; then
    log_error "Usage: $0 <remote_path> <local_file>"
    exit 1
fi

log_info "Downloading ${REMOTE_PATH} to ${LOCAL_FILE}"

# Ensure local directory exists
ensure_dir "$(dirname "${LOCAL_FILE}")"

# Determine storage provider and download
case "${STORAGE_PROVIDER:-s3}" in
    "s3"|"aws-s3")
        aws s3 cp "s3://${STORAGE_BUCKET}/${REMOTE_PATH}" "${LOCAL_FILE}"
        ;;
    "huawei-obs")
        obsutil cp "obs://${STORAGE_BUCKET}/${REMOTE_PATH}" "${LOCAL_FILE}"
        ;;
    "minio")
        mc cp "minio/${STORAGE_BUCKET}/${REMOTE_PATH}" "${LOCAL_FILE}"
        ;;
    "gcp-gcs")
        gsutil cp "gs://${STORAGE_BUCKET}/${REMOTE_PATH}" "${LOCAL_FILE}"
        ;;
    *)
        log_error "Unsupported storage provider: ${STORAGE_PROVIDER}"
        exit 1
        ;;
esac

if [ $? -eq 0 ]; then
    log_info "Download completed successfully"
else
    log_error "Download failed"
    exit 1
fi
