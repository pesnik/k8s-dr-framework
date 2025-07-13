#!/bin/bash

# Common utility functions for backup operations

# Logging functions
log_info() {
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log_error() {
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') - $1" >&2
}

log_warn() {
    echo "[WARN] $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Environment validation
validate_env() {
    local required_vars=("$@")
    local missing_vars=()
    
    for var in "${required_vars[@]}"; do
        if [[ -z "${!var}" ]]; then
            missing_vars+=("$var")
        fi
    done
    
    if [[ ${#missing_vars[@]} -gt 0 ]]; then
        log_error "Missing required environment variables: ${missing_vars[*]}"
        exit 1
    fi
}

# Storage provider functions
get_storage_provider() {
    echo "${STORAGE_PROVIDER:-huawei-obs}"
}

# Backup naming
generate_backup_name() {
    local prefix="$1"
    local timestamp=$(date '+%Y%m%d-%H%M%S')
    echo "${prefix}-${timestamp}"
}

# Retention cleanup
cleanup_old_backups() {
    local retention_days="${RETENTION_DAYS:-30}"
    local prefix="$1"
    
    log_info "Cleaning up backups older than ${retention_days} days with prefix: ${prefix}"
    # Implementation depends on storage provider
}

# Health checks
check_connectivity() {
    local host="$1"
    local port="$2"
    
    if command -v nc >/dev/null 2>&1; then
        nc -z "$host" "$port" || return 1
    else
        timeout 5 bash -c "</dev/tcp/$host/$port" || return 1
    fi
}

# Error handling
handle_error() {
    local exit_code=$?
    local line_number=$1
    log_error "Error occurred in script at line $line_number, exit code: $exit_code"
    exit $exit_code
}

# Set up error handling
trap 'handle_error $LINENO' ERR
