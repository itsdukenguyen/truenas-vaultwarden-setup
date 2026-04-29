#!/bin/bash

# =============================================
# Vaultwarden Backup Script for TrueNAS Scale
# =============================================

DATA_DIR="/mnt/DataPool/apps/vaultwarden/data"
BACKUP_DIR="/mnt/DataPool/backups/bitwarden"
PASSFILE="/mnt/DataPool/backups/bitwarden_passphrase.txt"
NAMESPACE="ix-vaultwarden"

# Create backup directory if missing
mkdir -p "$BACKUP_DIR"

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="vaultwarden_backup_${DATE}.tar.gz"
ENCRYPTED_FILE="${BACKUP_FILE}.gpg"

echo "=== Vaultwarden Backup Started at $(date) ==="

# Stop Vaultwarden for consistent backup
echo "Stopping Vaultwarden pod..."
kubectl -n ${NAMESPACE} scale deployment vaultwarden --replicas=0
sleep 8

# Create backup
echo "Creating compressed backup..."
tar czf "${BACKUP_DIR}/${BACKUP_FILE}" -C "${DATA_DIR}" .

# Encrypt with GPG
echo "Encrypting backup with GPG (AES256)..."
gpg --batch --yes --passphrase-file "${PASSFILE}" \
    --symmetric --cipher-algo AES256 \
    -o "${BACKUP_DIR}/${ENCRYPTED_FILE}" "${BACKUP_DIR}/${BACKUP_FILE}"

# Remove unencrypted file
rm -f "${BACKUP_DIR}/${BACKUP_FILE}"

# Restart Vaultwarden
echo "Restarting Vaultwarden pod..."
kubectl -n ${NAMESPACE} scale deployment vaultwarden --replicas=1

# 30-day retention
echo "Applying 30-day retention policy..."
find "${BACKUP_DIR}" -type f -name '*.gpg' -mtime +30 -delete

echo "=== Vaultwarden Backup Completed Successfully at $(date) ==="
echo "Encrypted backup saved: ${ENCRYPTED_FILE}"