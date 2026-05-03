# Vaultwarden Restore Guide

How to restore Vaultwarden from an encrypted backup on TrueNAS Scale.

**Last Updated:** April 30, 2026

## Prerequisites

- Root access to TrueNAS shell
- Latest encrypted backup file (`.gpg`) from `/mnt/DataPool/backups/bitwarden/`
- Your backup passphrase
- Basic comfort with the command line

## Step-by-Step Restore

### 1. Decrypt the Backup

```bash
# Navigate to backup directory
cd /mnt/DataPool/backups/bitwarden

# Decrypt the latest backup (replace with your actual filename)
gpg -d vaultwarden_backup_YYYYMMDD_HHMMSS.tar.gz.gpg > /tmp/vaultwarden_restore.tar.gz

# Stop the Vaultwarden pod
k3s kubectl -n ix-vaultwarden scale deployment vaultwarden --replicas=0
sleep 10

# Remove old data (be careful!)
rm -rf /mnt/.ix-apps/app_mounts/vaultwarden/data/*

# Extract the backup
tar xzf /tmp/vaultwarden_restore.tar.gz -C /mnt/.ix-apps/app_mounts/vaultwarden/data

# Start the pod again
k3s kubectl -n ix-vaultwarden scale deployment vaultwarden --replicas=1

# Verify Restore
Wait 30–60 seconds
Access: https://vaultwarden-nguyen.duckdns.org
Log in and check that all items, folders, and collections are present
Test Bitwarden app and browser extension