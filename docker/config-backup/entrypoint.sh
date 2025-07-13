#!/bin/bash
set -e

# Config backup entrypoint script
source /scripts/utils/common.sh

BACKUP_TYPE=${BACKUP_TYPE:-backup}

case $BACKUP_TYPE in
    backup)
        exec /scripts/configs/manifest-backup.sh
        ;;
    restore)
        exec /scripts/configs/manifest-restore.sh
        ;;
    etcd-backup)
        exec /scripts/configs/etcd-backup.sh
        ;;
    *)
        echo "Unknown backup type: $BACKUP_TYPE"
        exit 1
        ;;
esac
