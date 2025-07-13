#!/bin/bash
set -e

# Database backup entrypoint script
source /scripts/utils/common.sh

DB_TYPE=${DB_TYPE:-postgresql}
BACKUP_TYPE=${BACKUP_TYPE:-backup}

case $DB_TYPE in
    postgresql)
        case $BACKUP_TYPE in
            backup)
                exec /scripts/databases/postgres/backup.sh
                ;;
            restore)
                exec /scripts/databases/postgres/restore.sh
                ;;
            verify)
                exec /scripts/databases/postgres/verify.sh
                ;;
            *)
                echo "Unknown backup type: $BACKUP_TYPE"
                exit 1
                ;;
        esac
        ;;
    mysql)
        case $BACKUP_TYPE in
            backup)
                exec /scripts/databases/mysql/backup.sh
                ;;
            restore)
                exec /scripts/databases/mysql/restore.sh
                ;;
            verify)
                exec /scripts/databases/mysql/verify.sh
                ;;
            *)
                echo "Unknown backup type: $BACKUP_TYPE"
                exit 1
                ;;
        esac
        ;;
    mongodb)
        case $BACKUP_TYPE in
            backup)
                exec /scripts/databases/mongodb/backup.sh
                ;;
            restore)
                exec /scripts/databases/mongodb/restore.sh
                ;;
            verify)
                exec /scripts/databases/mongodb/verify.sh
                ;;
            *)
                echo "Unknown backup type: $BACKUP_TYPE"
                exit 1
                ;;
        esac
        ;;
    *)
        echo "Unknown database type: $DB_TYPE"
        exit 1
        ;;
esac
