#!/bin/bash
set -e

# Volume backup entrypoint script
source /scripts/utils/common.sh

BACKUP_TYPE=${BACKUP_TYPE:-backup}

case $BACKUP_TYPE in
    backup)
        exec /scripts/volumes/pvc-backup.sh
        ;;
    restore)
        exec /scripts/volumes/pvc-restore.sh
        ;;
    velero)
        exec /scripts/volumes/velero-integration.sh
        ;;
    *)
        echo "Unknown backup type: $BACKUP_TYPE"
        exit 1
        ;;
esac
