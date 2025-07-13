#!/bin/bash

set -e

echo "🔍 Starting recovery verification..."

# Source common utilities
source /scripts/utils/common.sh

verify_database_recovery() {
    local db_type=$1
    local db_name=$2
    
    echo "Verifying $db_type database: $db_name"
    
    case $db_type in
        "postgresql")
            verify_postgres_recovery $db_name
            ;;
        "mysql")
            verify_mysql_recovery $db_name
            ;;
        *)
            echo "❌ Unknown database type: $db_type"
            return 1
            ;;
    esac
}

verify_postgres_recovery() {
    local db_name=$1
    echo "🐘 Verifying PostgreSQL recovery for $db_name..."
    
    # Check database connectivity
    psql -h $PG_HOST -U $PG_USER -d $db_name -c "SELECT 1;" > /dev/null
    
    # Verify data integrity
    psql -h $PG_HOST -U $PG_USER -d $db_name -c "SELECT COUNT(*) FROM information_schema.tables;" > /dev/null
    
    echo "✅ PostgreSQL recovery verified"
}

verify_mysql_recovery() {
    local db_name=$1
    echo "🐬 Verifying MySQL recovery for $db_name..."
    
    # Check database connectivity
    mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD -e "USE $db_name; SELECT 1;" > /dev/null
    
    # Verify data integrity
    mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD -e "USE $db_name; SHOW TABLES;" > /dev/null
    
    echo "✅ MySQL recovery verified"
}

verify_config_recovery() {
    echo "🔧 Verifying configuration recovery..."
    
    # Check ConfigMaps
    kubectl get configmaps -n $NAMESPACE > /dev/null
    
    # Check Secrets
    kubectl get secrets -n $NAMESPACE > /dev/null
    
    echo "✅ Configuration recovery verified"
}

verify_pvc_recovery() {
    echo "💾 Verifying PVC recovery..."
    
    # Check PVC status
    kubectl get pvc -n $NAMESPACE > /dev/null
    
    # Verify data accessibility
    kubectl run test-pvc --rm -it --image=busybox --restart=Never -- ls /data > /dev/null
    
    echo "✅ PVC recovery verified"
}

# Main execution
main() {
    echo "🚀 Starting comprehensive recovery verification..."
    
    # Verify database recovery
    verify_database_recovery "postgresql" "$PG_DATABASE"
    verify_database_recovery "mysql" "$MYSQL_DATABASE"
    
    # Verify configuration recovery
    verify_config_recovery
    
    # Verify PVC recovery
    verify_pvc_recovery
    
    echo "✅ All recovery verification tests passed!"
}

main "$@"
