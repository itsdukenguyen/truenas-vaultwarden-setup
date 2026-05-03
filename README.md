# Vaultwarden on TrueNAS Scale - Home Lab Setup

![Vaultwarden](https://img.shields.io/badge/Vaultwarden-000000?style=for-the-badge&logo=bitwarden&logoColor=white)
![TrueNAS Scale](https://img.shields.io/badge/TrueNAS-Scale-00A3E0?style=for-the-badge&logo=truenas)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)

Complete guide for installing, configuring, and maintaining **Vaultwarden** (Bitwarden-compatible password manager) on my **TrueNAS Scale** server.

**Last Updated:** April 30, 2026

## Quick Links

- [Setup Checklist](SETUP-CHECKLIST.md)
- [EdgeRouter-4 Firewall Rules](edge-router-firewall-rules.md)
- [VLAN Overview](docs/vlan-overview.md)
- [Restore Guide](docs/restore-guide.md)
- [Backup Script](scripts/vaultwarden_backup.sh)
- [Roadmap](ROADMAP.md)

## Screenshots

<div align="center">

**Storage Configuration**  
<img src="screenshots/01-vaultwarden-storage-config.png" width="600" alt="Storage Configuration">

**Nginx Proxy Host**  
<img src="screenshots/03-nginx-proxy-host-01.png" width="600" alt="Nginx Proxy Host">

**App Settings**  
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
- **Backup**: Daily encrypted GPG backups with 30-day retention

## Key Features

- Family sharing via Organizations & Collections
- Automated daily encrypted backups (GPG AES256)
- Secure access from Clients VLAN and Tailscale
- Full integration with my homelab VLAN segmentation

## Restore Guide

See detailed restore instructions in [`docs/restore-guide.md`](docs/restore-guide.md).

## Home Lab Context

This Vaultwarden instance is part of my larger homelab:
- EdgeRouter-4 with 5 VLANs (Management, Servers, IoT, Clients, Guests)
- 5× Raspberry Pi cluster
- TrueNAS Scale with 72TB RAIDZ2 storage
- Full media stack (*arr, Jellyfin, Immich, Frigate, Home Assistant)