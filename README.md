# Vaultwarden on TrueNAS Scale - Home Lab Setup

![Vaultwarden](https://img.shields.io/badge/Vaultwarden-000000?style=for-the-badge&logo=bitwarden&logoColor=white)
![TrueNAS Scale](https://img.shields.io/badge/TrueNAS-Scale-00A3E0?style=for-the-badge&logo=truenas)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)

Complete guide for installing, configuring, and maintaining **Vaultwarden** (Bitwarden-compatible password manager) on my **TrueNAS Scale** server as part of my home lab.

**Last Updated:** April 30, 2026

## Quick Links

- [Setup Checklist](SETUP-CHECKLIST.md)
- [EdgeRouter-4 Firewall Rules](edge-router-firewall-rules.md)
- [VLAN Overview](docs/vlan-overview.md)
- [Backup Script](scripts/vaultwarden_backup.sh)

## Screenshots

<div align="center">

**Storage Configuration**  
<img src="screenshots/01-vaultwarden-storage-config.png" width="600" alt="Storage Configuration">

**Nginx Proxy Host**  
<img src="screenshots/03-nginx-proxy-host-01.png" width="600" alt="Nginx Proxy Host">

**Vaultwarden App Settings**  
<img src="screenshots/02-vaultwarden-app-settings.png" width="600" alt="App Settings">

**SMTP Configuration**  
<img src="screenshots/04-vaultwarden-admin-ui-03.png" width="600" alt="SMTP Settings">

**Organization View**  
<img src="screenshots/05-vaultwarden-organization.png" width="600" alt="Family Organization">

</div>

## Overview

- **Server**: TrueNAS Scale @ `192.168.10.101`
- **Data Path**: `/mnt/.ix-apps/app_mounts/vaultwarden/data` (ixVolume)
- **Public URL**: [https://vaultwarden-nguyen.duckdns.org](https://vaultwarden-nguyen.duckdns.org)
- **Reverse Proxy**: Nginx Proxy Manager
- **Backup**: Daily encrypted GPG backups with 30-day retention

## Key Features

- Family sharing via Organizations & Collections
- Automated daily encrypted backups (GPG AES256)
- Secure access from Clients VLAN and Tailscale
- Full integration with my homelab VLAN segmentation

## Installation Steps

1. Install **Vaultwarden** from **Apps → Available Applications**
2. Use `ixVolume` for both Data and Postgres storage
3. Set strong `ADMIN_TOKEN` environment variable
4. Enable **WebSocket** support

## Nginx Reverse Proxy Setup

- **Domain**: `vaultwarden-nguyen.duckdns.org`
- **Forward Host**: `192.168.10.101`
- **Forward Port**: `8083`
- **Websockets Support**: Enabled
- **SSL**: Let's Encrypt certificate

## SMTP Configuration

Configured in **Vaultwarden Admin UI** (`https://vaultwarden-nguyen.duckdns.org/admin`):

- **Host**: `smtp.gmail.com`
- **Port**: `587`
- **Secure SMTP**: `starttls`
- **From Address / Username**: Your Gmail address
- **Password**: Gmail App Password

## Admin Interface & Family Access

- Enabled via `ADMIN_TOKEN`
- Created **"Nguyen Family"** Organization
- Manually added family members
- Used Collections for secure sharing (Wi-Fi, Streaming Services, etc.)

## Automated Backups

**Script**: [`scripts/vaultwarden_backup.sh`](scripts/vaultwarden_backup.sh)

**Features**:
- Daily at 2:00 AM via TrueNAS Cron Job
- Uses correct ixVolume path
- Compressed + encrypted with **GPG AES256**
- 30-day retention

## Network & Firewall Rules

See detailed rules in [`edge-router-firewall-rules.md`](edge-router-firewall-rules.md)

- Clients VLAN (`192.168.30.0/24`) → Allowed via Nginx
- Tailscale (`100.64.0.0/10`) → Full access
- Guest VLAN (`192.168.40.0/24`) → Blocked

## Restore Procedure

1. Decrypt: `gpg -d vaultwarden_backup_*.gpg > backup.tar.gz`
2. Stop Vaultwarden pod
3. Extract to data directory
4. Restart pod
5. Verify access

## Monitoring

- **Netdata**: `http://192.168.10.101:20489`
- **Prometheus + Grafana**
- **Scrutiny** (drive health)

## Home Lab Context

This Vaultwarden instance is part of my larger homelab:
- EdgeRouter-4 with 5 VLANs (Management, Servers, IoT, Clients, Guests)
- 5× Raspberry Pi cluster (Home Assistant, Tailscale, Pi-hole, UniFi, Torrent)
- TrueNAS Scale with 72TB RAIDZ2 storage
- Full media stack (*arr, Jellyfin, Immich, Frigate, Home Assistant)