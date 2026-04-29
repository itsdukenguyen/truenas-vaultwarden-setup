# Vaultwarden on TrueNAS Scale - Home Lab Setup

![Vaultwarden](https://img.shields.io/badge/Vaultwarden-000000?style=for-the-badge&logo=bitwarden&logoColor=white)
![TrueNAS](https://img.shields.io/badge/TrueNAS-Scale-00A3E0?style=for-the-badge&logo=truenas)

Complete guide for installing, configuring, and maintaining **Vaultwarden** (Bitwarden-compatible password manager) on my **TrueNAS Scale** server as part of my home lab.

**Last Updated:** April 29, 2026  
**Vaultwarden URL:** [https://vaultwarden-nguyen.duckdns.org](https://vaultwarden-nguyen.duckdns.org)

## Overview

- **Server**: TrueNAS Scale @ `192.168.10.101`
- **Storage Pool**: `DataPool`
- **App Data Path**: `/mnt/DataPool/apps/vaultwarden/data`
- **Reverse Proxy**: Nginx Proxy Manager
- **Domain**: `vaultwarden-nguyen.duckdns.org` (DuckDNS + Let's Encrypt)
- **Backup**: Daily encrypted GPG backups with 30-day retention

## Features

- Self-hosted password manager for personal and family use
- Organization + Collections for secure sharing
- Automated daily encrypted backups
- Proper VLAN segmentation (Clients & Tailscale access)
- Integrated with full homelab stack (*arr, Jellyfin, Home Assistant, etc.)

## Screenshots

<div align="center">
  <img src="screenshots/Vaultwarden-Storage-Config.png" width="600" alt="Vaultwarden Storage Configuration on TrueNAS">
</div>

## Table of Contents

- [Installation Steps](#installation-steps)
- [Nginx Reverse Proxy Setup](#nginx-reverse-proxy-setup)
- [SMTP Configuration](#smtp-configuration)
- [Admin Interface & Adding Users](#admin-interface--adding-users)
- [Automated Backups](#automated-backups)
- [Network & Firewall Rules](#network--firewall-rules)
- [Setup Checklist](SETUP-CHECKLIST.md)
- [Restore Procedure](#restore-procedure)

## Installation Steps

1. Install **Vaultwarden** from **Apps → Available Applications**
2. Use default `ixVolume` for storage
3. Set a strong `ADMIN_TOKEN` environment variable

## Nginx Reverse Proxy Setup

- Domain: `vaultwarden-nguyen.duckdns.org`
- Forward to: `192.168.10.101:8083`
- Enable **Websockets Support**
- Request Let's Encrypt SSL certificate

## SMTP Configuration

Configured in Vaultwarden **Admin UI** (`/admin`):

- **Host**: `smtp.gmail.com`
- **Port**: `587`
- **Secure**: `starttls`
- **From / Username**: Your Gmail address
- **Password**: Gmail App Password

## Admin Interface & Adding Users

- Enabled via `ADMIN_TOKEN`
- Manually create users when email invites fail
- Created **"Nguyen Family"** Organization for shared collections (Wi-Fi, Streaming, etc.)

## Automated Backups

**Script**: [`backup-script/vaultwarden_backup.sh`](backup-script/vaultwarden_backup.sh)

**Features**:
- Scheduled daily at 2:00 AM via TrueNAS Cron Job
- Brief pod stop for consistent SQLite backup
- Compressed + encrypted with **GPG AES256**
- 30-day retention policy
- Stored in `/mnt/DataPool/backups/bitwarden/`

## Network & Firewall Rules

- Clients VLAN (`192.168.30.0/24`) → Allowed access to Vaultwarden
- Tailscale (`100.64.0.0/10`) → Full access
- Guest VLAN (`192.168.40.0/24`) → Blocked

## Restore Procedure

1. Decrypt: `gpg -d vaultwarden_backup_*.gpg > backup.tar.gz`
2. Stop Vaultwarden pod
3. Extract to data directory
4. Restart pod
5. Verify access

## Monitoring

- Netdata (`http://192.168.10.101:20489`)
- Prometheus + Grafana
- Scrutiny (drive health monitoring)

## Home Lab Context

This Vaultwarden instance runs as part of my larger homelab:
- EdgeRouter-4 with 5 VLANs (Management, Servers, IoT, Clients, Guests)
- 5× Raspberry Pi cluster (HA, Tailscale, Pi-hole, UniFi, Torrent)
- TrueNAS Scale with 72TB RAIDZ2 storage
- Full *arr media stack, Jellyfin, Immich, Frigate, Home Assistant