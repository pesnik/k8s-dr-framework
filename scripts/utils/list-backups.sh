#!/bin/bash
set -euo pipefail

# List backups utility script
source /scripts/utils/common.sh

BACKUP_TYPE=${1:-all}
DAYS_BACK=${2:-30}

log_info "Listing backups for type: ${BACKUP_TYPE}, last ${DAYS_BACK} days"

# Calculate date range
START_DATE=$(date -d "${DAYS_BACK} days ago" +%Y%m%d)
END_DATE=$(date +%Y%m%d)

# List backups based on storage provider
case "${STORAGE_PROVIDER:-s3}" in
    "s3"|"aws-s3")
        aws s3 ls "s3://${STORAGE_BUCKET}/" --recursive | \
        grep -E "${START_DATE}|${END_DATE}" | \
        sort -k1,2
        ;;
    "huawei-obs")
        obsutil ls "obs://${STORAGE_BUCKET}/" -r | \
        grep -E "${START_DATE}|${END_DATE}" | \
        sort -k1,2
        ;;
    "minio")
        mc ls "minio/${STORAGE_BUCKET}/" --recursive | \
        grep -E "${START_DATE}|${END_DATE}" | \
        sort -k1,2
        ;;
    "gcp-gcs")
        gsutil ls "gs://${STORAGE_BUCKET}/**" | \
        grep -E "${START_DATE}|${END_DATE}" | \
        sort
        ;;
    *)
        log_error "Unsupported storage provider: ${STORAGE_PROVIDER}"
        exit 1
        ;;
esac
