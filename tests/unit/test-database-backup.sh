#!/bin/bash

set -e

DB_TYPE=$1

echo "🧪 Testing $DB_TYPE backup script..."

# Mock environment variables
export PG_HOST="mock-postgres"
export PG_USER="mock-user"
export PG_PASSWORD="mock-password"
export MYSQL_HOST="mock-mysql"
export MYSQL_USER="mock-user"
export MYSQL_PASSWORD="mock-password"

# Test script syntax
case $DB_TYPE in
    "postgres")
        bash -n ../../scripts/databases/postgres/backup.sh
        echo "✅ PostgreSQL backup script syntax OK"
        ;;
    "mysql")
        bash -n ../../scripts/databases/mysql/backup.sh
        echo "✅ MySQL backup script syntax OK"
        ;;
    *)
        echo "❌ Unknown database type: $DB_TYPE"
        exit 1
        ;;
esac

echo "✅ $DB_TYPE backup script tests passed!"
