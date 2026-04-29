# Vaultwarden on TrueNAS Scale - Home Lab Setup

Complete documentation for installing, configuring, and maintaining **Vaultwarden** (Bitwarden-compatible password manager) on my TrueNAS Scale server.

**Last Updated:** April 29, 2026  
**TrueNAS Version:** Scale (latest)  
**Vaultwarden Access:** https://vaultwarden-nguyen.duckdns.org

## Overview

- **Server**: TrueNAS Scale @ `192.168.10.101`
- **Storage Pool**: `DataPool`
- **App Storage Path**: `/mnt/DataPool/apps/vaultwarden/data`
- **Reverse Proxy**: Nginx Proxy Manager (`192.168.10.101:81`)
- **Domain**: `vaultwarden-nguyen.duckdns.org`
- **Access Method**: HTTPS via Nginx + Let's Encrypt
- **Backup Strategy**: Automated daily encrypted GPG backups with 30-day retention

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation Steps](#installation-steps)
- [Post-Installation Configuration](#post-installation-configuration)
- [SMTP Email Setup (for User Invites)](#smtp-email-setup)
- [Enabling Admin Interface](#enabling-admin-interface)
- [Adding Family Members](#adding-family-members)
- [Automated Backups](#automated-backups)
- [Network & Firewall Configuration](#network--firewall-configuration)
- [Restore Procedure](#restore-procedure)

## Prerequisites

- TrueNAS Scale installed with `DataPool` pool
- Nginx Proxy Manager app installed and configured
- DuckDNS domain (`vaultwarden-nguyen.duckdns.org`) pointing to public IP
- Port forwarding (80 + 443) on EdgeRouter-4 to TrueNAS/Nginx
- Gmail account with App Password (for SMTP)

## Installation Steps

1. **Install Vaultwarden App**
   - Go to **Apps** → **Available Applications**
   - Search for **Vaultwarden**
   - Click **Install**

2. **Storage Configuration** (as shown in screenshot)
   - **Vaultwarden Data Storage**: `ixVolume` (automatically created)
   - **Vaultwarden Postgres Data Storage**: `ixVolume` (if using Postgres - optional)
   - Leave ACL disabled unless needed

3. **Basic App Settings**
   - Set **Domain** to `vaultwarden-nguyen.duckdns.org`
   - Enable **WebSocket Support**
   - Set desired **Admin Token** (strong random string)

4. **Networking**
   - Expose port **8083** (internal) → Nginx will proxy external 443

## Post-Installation Configuration

### 1. Nginx Proxy Manager Setup
- Create new Proxy Host:
  - Domain: `vaultwarden-nguyen.duckdns.org`
  - Forward Host: `192.168.10.101`
  - Forward Port: `8083`
  - Enable **Websockets Support**
  - Request Let's Encrypt SSL certificate

### 2. Access Vaultwarden
- Web UI: `https://vaultwarden-nguyen.duckdns.org`
- Internal direct: `https://192.168.10.101:8083`

## SMTP Email Setup (Critical for User Invites)

Configured in **Vaultwarden Admin UI** (`https://vaultwarden-nguyen.duckdns.org/admin`):

- **Enabled**: `true`
- **Use Sendmail**: `false`
- **Host**: `smtp.gmail.com`
- **Secure SMTP**: `starttls`
- **Port**: `587`
- **From Address**: `your.email@gmail.com`
- **From Name**: `Vaultwarden`
- **Username**: `your.email@gmail.com`
- **Password**: `<Gmail App Password>`
- **SMTP Connection Timeout**: `15`

## Enabling Admin Interface

Added environment variable in TrueNAS App:
- **ADMIN_TOKEN**: `<strong-random-token>`

Access: `https://vaultwarden-nguyen.duckdns.org/admin`

## Adding Family Members

Since email invites were initially not working:
1. Use **Admin Interface** → **Users** → **Create User**
2. Manually add users to **"Nguyen Family" Organization**
3. Assign appropriate **Collections** (Shared Wi-Fi, Streaming Services, etc.)
4. Share temporary password securely and instruct user to change it immediately

## Automated Backups

### Backup Script Location
`/mnt/DataPool/backups/vaultwarden_backup.sh`

### Features
- Daily backup at 2:00 AM
- Stops Vaultwarden pod briefly for consistency
- Creates compressed `.tar.gz`
- Encrypts with **GPG AES256** using passphrase
- 30-day retention policy (auto-deletes older backups)
- Stored in: `/mnt/DataPool/backups/bitwarden/`

### Cron Job Configuration (TrueNAS UI)
- **Description**: Vaultwarden Daily Backup
- **Command**: `/mnt/DataPool/backups/vaultwarden_backup.sh`
- **User**: `root`
- **Schedule**: Daily at 02:00

## Network & Firewall Configuration (EdgeRouter-4)

Key firewall rules applied:
- Allow Clients VLAN (`192.168.30.0/24`) → VLAN10 Nginx (ports 80/443)
- Allow Tailscale (`100.64.0.0/10`) → Vaultwarden services
- Block Guest VLAN (`192.168.40.0/24`) from accessing Vaultwarden

## Restore Procedure

1. Decrypt backup: `gpg -d vaultwarden_backup_*.gpg > backup.tar.gz`
2. Stop Vaultwarden pod
3. Extract backup to data directory
4. Restart Vaultwarden pod
5. Verify access

## Monitoring

- Netdata: `http://192.168.10.101:20489`
- Prometheus + Grafana
- Scrutiny (HDD/SSD health)

## Home Lab Context

This Vaultwarden instance is part of a larger homelab including:
- EdgeRouter-4 with VLAN segmentation (Management, Servers, IoT, Clients, Guests)
- 5× Raspberry Pi cluster (HA, Tailscale, Pi-hole, UniFi, Torrent)
- TrueNAS Scale with 72TB RAIDZ2 storage
- Reolink NVR + cameras
- Multiple *arr stack apps

---

### Additional Files You Should Add to the Repo

1. `backup-script/vaultwarden_backup.sh` → Paste the full backup script
2. `screenshots/` → Add your storage config screenshot + admin UI screenshots
3. `firewall-rules.md` → Copy relevant EdgeRouter rules
4. `LICENSE` → MIT or GPLv3

---

Would you like me to also create:

1. The full backup script file ready to copy
2. A `firewall-rules.md` document with the exact ER-4 commands used
3. A checklist-style `SETUP-CHECKLIST.md`

Just say the word and I’ll generate them for you.

You can now copy the `README.md` above directly into your GitHub repo. Let me know if you want any sections expanded or modified before you push it.
