# Vaultwarden Setup Checklist - TrueNAS Scale

Use this checklist to install, configure, verify, and maintain Vaultwarden in your homelab.

**Last Updated:** April 30, 2026  
**Status:** Completed & Automated

## 1. Prerequisites

- [ ] TrueNAS Scale is installed and up to date
- [ ] `DataPool` storage pool exists
- [ ] Nginx Proxy Manager is installed and running
- [ ] DuckDNS domain `vaultwarden-nguyen.duckdns.org` is configured
- [ ] Ports 80 and 443 forwarded on EdgeRouter-4 to TrueNAS
- [ ] Gmail account with **App Password** ready for SMTP
- [ ] Backup directory exists: `/mnt/DataPool/backups/bitwarden`

## 2. Vaultwarden Installation

- [ ] Install **Vaultwarden** from **Apps → Available Applications**
- [ ] Storage Configuration:
  - Use `ixVolume (Dataset created automatically by the system)` for both Data Storage and Postgres Data Storage
  - Leave **Enable ACL** unchecked
- [ ] Add environment variable: `ADMIN_TOKEN` = (strong random string)
- [ ] Enable **WebSocket** support
- [ ] Deploy the app

## 3. Nginx Proxy Manager Configuration

- [ ] Create new Proxy Host
- [ ] Domain: `vaultwarden-nguyen.duckdns.org`
- [ ] Forward Hostname/IP: `192.168.10.101`
- [ ] Forward Port: `8083`
- [ ] Enable **Websockets Support**
- [ ] Request **Let's Encrypt** SSL certificate

## 4. SMTP Configuration (for User Invites)

- [ ] Access Admin UI: `https://vaultwarden-nguyen.duckdns.org/admin`
- [ ] Go to **SMTP Email Settings**
- [ ] Configure:
  - Enabled: Checked
  - Host: `smtp.gmail.com`
  - Secure SMTP: `starttls`
  - Port: `587`
  - From Address / Username: Your Gmail address
  - Password: Gmail App Password

## 5. Admin Interface & Family Access

- [ ] Confirm Admin UI is accessible
- [ ] Create **"Nguyen Family"** Organization
- [ ] Create Collections (e.g., "Shared Wi-Fi", "Streaming Services")
- [ ] Manually create user accounts for family members
- [ ] Add users to Organization and assign Collections
- [ ] Instruct users to change temporary password on first login

## 6. Automated Backups (Working ✅)

- [ ] Passphrase file created: `/mnt/DataPool/backups/bitwarden_passphrase.txt` (permissions 600)
- [ ] Backup script created: `/mnt/DataPool/backups/vaultwarden_backup.sh`
- [ ] Script tested successfully (creates encrypted `.gpg` files)
- [ ] Cron Job created in TrueNAS UI:
  - Description: `Vaultwarden Daily Backup`
  - Command: `/mnt/DataPool/backups/vaultwarden_backup.sh`
  - User: `root`
  - Schedule: Daily at **02:00**

**Backup Location**: `/mnt/DataPool/backups/bitwarden/`

## 7. Network & Security Verification

- [ ] Clients VLAN (`192.168.30.0/24`) can access `https://vaultwarden-nguyen.duckdns.org`
- [ ] Tailscale devices have access
- [ ] Guest VLAN (`192.168.40.0/24`) is blocked from Vaultwarden
- [ ] 2FA enabled on important accounts

## 8. Final Verification

- [ ] Web UI accessible at `https://vaultwarden-nguyen.duckdns.org`
- [ ] Bitwarden app and browser extension work with custom server
- [ ] Family members can log in and access shared collections
- [ ] Daily backups are running and encrypted
- [ ] Old backups (>30 days) are automatically cleaned up

---

**Tip**: Run `/mnt/DataPool/backups/vaultwarden_backup.sh` manually anytime to test.