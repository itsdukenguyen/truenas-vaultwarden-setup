# Vaultwarden on TrueNAS Scale - Home Lab Setup

Complete documentation for installing, configuring, and maintaining **Vaultwarden** (Bitwarden-compatible password manager) on my TrueNAS Scale server in my home lab.

**Last Updated:** April 29, 2026  
**TrueNAS Version:** Scale  
**Vaultwarden URL:** https://vaultwarden-nguyen.duckdns.org

## Overview

- **Server**: TrueNAS Scale @ `192.168.10.101`
- **Storage Pool**: `DataPool`
- **App Storage Path**: `/mnt/DataPool/apps/vaultwarden/data`
- **Reverse Proxy**: Nginx Proxy Manager (`192.168.10.101:81`)
- **Domain**: `vaultwarden-nguyen.duckdns.org` (via DuckDNS)
- **Access Method**: HTTPS via Nginx + Let's Encrypt
- **Backup Strategy**: Automated daily encrypted GPG backups with 30-day retention

## Table of Contents

- [Installation Steps](#installation-steps)
- [Nginx Reverse Proxy Setup](#nginx-reverse-proxy-setup)
- [SMTP Email Setup](#smtp-email-setup)
- [Enabling Admin Interface](#enabling-admin-interface)
- [Adding Family Members](#adding-family-members)
- [Automated Backups](#automated-backups)
- [Network & Firewall Configuration](#network--firewall-configuration)
- [Restore Procedure](#restore-procedure)

## Installation Steps

1. Installed **Vaultwarden** via **Apps → Available Applications**
2. Used `ixVolume` for data storage (default)
3. Configured **ADMIN_TOKEN** environment variable

## Nginx Reverse Proxy Setup

- Domain: `vaultwarden-nguyen.duckdns.org`
- Forward Host: `192.168.10.101`
- Forward Port: `8083`
- Enabled **Websockets Support**
- Requested Let's Encrypt SSL certificate

## SMTP Email Setup (for User Invites)

Configured in **Vaultwarden Admin UI** (`https://vaultwarden-nguyen.duckdns.org/admin`):

- **Enabled**: `true`
- **Use Sendmail**: `false`
- **Host**: `smtp.gmail.com`
- **Secure SMTP**: `starttls`
- **Port**: `587`
- **From Address / Username**: `your.email@gmail.com`
- **Password**: Gmail App Password
- **SMTP Connection Timeout**: `15`

## Enabling Admin Interface

- Added `ADMIN_TOKEN` environment variable in the Vaultwarden app settings
- Access: `https://vaultwarden-nguyen.duckdns.org/admin`

## Adding Family Members

Because email invites were not working initially:
1. Used Admin Interface → **Create User**
2. Manually added users to **"Nguyen Family"** Organization
3. Assigned appropriate Collections (Shared Wi-Fi, Streaming Services, etc.)

## Automated Backups

**Script Location**: `backup-script/vaultwarden_backup.sh`

**Features**:
- Daily backup at 2:00 AM via TrueNAS Cron Job
- Stops Vaultwarden pod briefly for consistent backup
- Compresses data → Encrypts with **GPG AES256**
- 30-day retention (automatically deletes older backups)
- Backup folder: `/mnt/DataPool/backups/bitwarden/`

## Network & Firewall Configuration

- Clients VLAN (`192.168.30.0/24`) → Allowed to access Vaultwarden via Nginx
- Tailscale (`100.64.0.0/10`) → Full access
- Guest VLAN (`192.168.40.0/24`) → Blocked (security best practice)

## Restore Procedure

1. Decrypt: `gpg -d vaultwarden_backup_*.gpg > backup.tar.gz`
2. Stop Vaultwarden pod
3. Extract backup to data directory
4. Restart pod
5. Verify access

## Monitoring

- Netdata: `http://192.168.10.101:20489`
- Prometheus + Grafana
- Scrutiny (drive health)

## Home Lab Context

This Vaultwarden instance is part of my larger homelab:
- EdgeRouter-4 with 5 VLANs (Management, Servers, IoT, Clients, Guests)
- 5× Raspberry Pi cluster (Home Assistant, Tailscale, Pi-hole, UniFi, Torrent)
- TrueNAS Scale with 72TB RAIDZ2 storage
- Reolink NVR + cameras and *arr media stack