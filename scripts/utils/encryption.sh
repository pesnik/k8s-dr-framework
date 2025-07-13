#!/bin/bash
set -euo pipefail

# Encryption utility script
source /scripts/utils/common.sh

OPERATION=${1:-}
INPUT_FILE=${2:-}
OUTPUT_FILE=${3:-}

if [ -z "${OPERATION}" ] || [ -z "${INPUT_FILE}" ]; then
    log_error "Usage: $0 <encrypt|decrypt> <input_file> [output_file]"
    exit 1
fi

if [ -z "${OUTPUT_FILE}" ]; then
    case "${OPERATION}" in
        "encrypt")
            OUTPUT_FILE="${INPUT_FILE}.enc"
            ;;
        "decrypt")
            OUTPUT_FILE="${INPUT_FILE%.enc}"
            ;;
    esac
fi

case "${OPERATION}" in
    "encrypt")
        log_info "Encrypting ${INPUT_FILE} to ${OUTPUT_FILE}"
        openssl enc -aes-256-cbc -salt -in "${INPUT_FILE}" -out "${OUTPUT_FILE}" -k "${ENCRYPTION_KEY}"
        ;;
    "decrypt")
        log_info "Decrypting ${INPUT_FILE} to ${OUTPUT_FILE}"
        openssl enc -aes-256-cbc -d -salt -in "${INPUT_FILE}" -out "${OUTPUT_FILE}" -k "${ENCRYPTION_KEY}"
        ;;
    *)
        log_error "Invalid operation: ${OPERATION}"
        exit 1
        ;;
esac

if [ $? -eq 0 ]; then
    log_info "Encryption/Decryption completed successfully"
else
    log_error "Encryption/Decryption failed"
    exit 1
fi
