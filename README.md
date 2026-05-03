# Vaultwarden on TrueNAS Scale - Home Lab Setup

![Vaultwarden](https://img.shields.io/badge/Vaultwarden-000000?style=for-the-badge&logo=bitwarden&logoColor=white)
![TrueNAS Scale](https://img.shields.io/badge/TrueNAS-Scale-00A3E0?style=for-the-badge&logo=truenas)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)

Complete guide for installing, configuring, and maintaining **Vaultwarden** (Bitwarden-compatible password manager) on my **TrueNAS Scale** server as part of my home lab.

**Last Updated:** April 30, 2026

## Overview

- **Server**: TrueNAS Scale @ `192.168.10.101`
- **Storage Pool**: `DataPool`
- **App Data Path**: `/mnt/.ix-apps/app_mounts/vaultwarden/data` (ixVolume)
- **Public URL**: [https://vaultwarden-nguyen.duckdns.org](https://vaultwarden-nguyen.duckdns.org)
- **Reverse Proxy**: Nginx Proxy Manager
- **Backup**: Daily encrypted GPG backups with 30-day retention

## Screenshots

<div align="center">

**Storage Configuration**  
<img src="screenshots/01-vaultwarden-storage-config.png" width="600" alt="Vaultwarden Storage Configuration">

**Nginx Proxy Host**  
<img src="screenshots/03-nginx-proxy-host-01.png" width="600" alt="Nginx Proxy Host Configuration">

**Vaultwarden App Settings**  
<img src="screenshots/02-vaultwarden-app-settings.png" width="600" alt="Vaultwarden App Settings">

**SMTP Configuration**  
<img src="screenshots/04-vaultwarden-admin-ui-03.png" width="600" alt="SMTP Settings">

**Admin Interface & Organization**  
<img src="screenshots/05-vaultwarden-organization.png" width="600" alt="Vaultwarden Organization">

</div>

## Key Features

- Self-hosted password manager for personal and family use
- Organization + Collections for secure sharing
- Automated daily encrypted backups (GPG AES256)
- Proper integration with VLAN segmentation (Clients + Tailscale)

## Automated Backups

**Status**: Working ✅

**Script**: [`backup-script/vaultwarden_backup.sh`](backup-script/vaultwarden_backup.sh)

**Features**:
- Runs daily at **2:00 AM** via TrueNAS Cron Job
- Uses correct ixVolume path (`/mnt/.ix-apps/app_mounts/vaultwarden/data`)
- Creates compressed backup → Encrypts with **GPG AES256**
- 30-day retention (automatically deletes old backups)
- Backup location: `/mnt/DataPool/backups/bitwarden/`

## Installation Steps

1. Install Vaultwarden from **Apps → Available Applications**
2. Use `ixVolume` for data storage
3. Set strong `ADMIN_TOKEN` environment variable
4. Configure Nginx Proxy Manager (port 8083 + WebSocket)
5. Set up SMTP for user invites (Gmail App Password)

## Network & Security

- Clients VLAN (`192.168.30.0/24`) can access Vaultwarden
- Tailscale users have full access
- Guest VLAN is blocked

## Setup Checklist

See [`SETUP-CHECKLIST.md`](SETUP-CHECKLIST.md) for detailed step-by-step instructions.

## Restore Procedure

1. Decrypt: `gpg -d vaultwarden_backup_*.gpg > backup.tar.gz`
2. Stop Vaultwarden pod
3. Extract to data directory
4. Restart pod
5. Verify access

## Monitoring

- Netdata: `http://192.168.10.101:20489`
- Prometheus + Grafana
- Scrutiny (HDD/SSD health)

## Additional Documentation

- [Setup Checklist](SETUP-CHECKLIST.md)
- [EdgeRouter-4 Firewall Rules](edge-router-firewall-rules.md)
- [Backup Script](backup-script/vaultwarden_backup.sh)

## Home Lab Context

This Vaultwarden instance is part of my larger homelab including:
- EdgeRouter-4 with 5 VLANs (Management, Servers, IoT, Clients, Guests)
- 5× Raspberry Pi cluster (Home Assistant, Tailscale, Pi-hole, UniFi, Torrent)
- TrueNAS Scale with 72TB RAIDZ2 storage
- Full media stack (*arr, Jellyfin, Immich, Frigate, etc.)
