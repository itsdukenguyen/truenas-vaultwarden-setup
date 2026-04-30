# Vaultwarden Setup Checklist - TrueNAS Scale

Use this checklist to install, configure, and verify Vaultwarden in your homelab.

**Last Updated:** April 29, 2026

## 1. Prerequisites

- [ ] TrueNAS Scale is installed and up to date
- [ ] `DataPool` storage pool exists
- [ ] Nginx Proxy Manager is installed and running
- [ ] DuckDNS domain `vaultwarden-nguyen.duckdns.org` is configured and pointing to your public IP
- [ ] Ports 80 and 443 are forwarded on EdgeRouter-4 to TrueNAS
- [ ] Gmail account ready with an **App Password** for SMTP
- [ ] Backup directory created: `/mnt/DataPool/backups/bitwarden`

## 2. Vaultwarden Installation

- [ ] Install **Vaultwarden** from **Apps → Available Applications**
- [ ] Storage Configuration:
  - Use `ixVolume` for both "Vaultwarden Data Storage" and "Postgres Data Storage"
  - Leave **Enable ACL** unchecked
- [ ] Set environment variable:
  - `ADMIN_TOKEN` = (generate a strong random string)
- [ ] Enable **WebSocket** support
- [ ] Deploy the app

## 3. Nginx Proxy Manager Configuration

- [ ] Create new Proxy Host
- [ ] Domain Names: `vaultwarden-nguyen.duckdns.org`
- [ ] Forward Hostname/IP: `192.168.10.101`
- [ ] Forward Port: `8083`
- [ ] Enable **Websockets Support**
- [ ] Request **Let's Encrypt** SSL certificate
- [ ] (Optional) Add security headers in Custom Nginx Configuration

## 4. SMTP Configuration (Required for User Invites)

- [ ] Access Vaultwarden Admin UI: `https://vaultwarden-nguyen.duckdns.org/admin`
- [ ] Go to **Settings → SMTP Email Settings**
- [ ] Configure:
  - **Enabled**: Checked
  - **Host**: `smtp.gmail.com`
  - **Secure SMTP**: `starttls`
  - **Port**: `587`
  - **From Address**: `your-email@gmail.com`
  - **Username**: `your-email@gmail.com`
  - **Password**: Gmail App Password
- [ ] Test SMTP if possible

## 5. Admin Interface & Family Access

- [ ] Confirm Admin UI is accessible
- [ ] Create **"Nguyen Family"** Organization
- [ ] Create Collections (e.g., "Shared Wi-Fi", "Streaming Services", "Home Automation")
- [ ] Manually create user accounts for family members
- [ ] Add users to the Organization and assign appropriate Collections
- [ ] Instruct users to change their temporary password on first login

## 6. Automated Backups

- [ ] Create secure passphrase file: `/mnt/DataPool/backups/bitwarden_passphrase.txt`
- [ ] Place `vaultwarden_backup.sh` in `/mnt/DataPool/backups/`
- [ ] Make script executable
- [ ] Create Cron Job in TrueNAS:
  - Description: "Vaultwarden Daily Backup"
  - Command: `/mnt/DataPool/backups/vaultwarden_backup.sh`
  - User: `root`
  - Schedule: Daily at **02:00**
- [ ] Run the job manually once to verify it works

## 7. Network & Security Verification

- [ ] Clients VLAN (`192.168.30.0/24`) can access `https://vaultwarden-nguyen.duckdns.org`
- [ ] Tailscale devices can access Vaultwarden
- [ ] Guest VLAN (`192.168.40.0/24`) is blocked from accessing Vaultwarden
- [ ] 2FA is enabled on all important accounts

## 8. Final Verification & Testing

- [ ] Can successfully log in via web UI
- [ ] Bitwarden app and browser extension work with custom server URL
- [ ] Family members can access shared collections
- [ ] Backup script creates encrypted `.gpg` files
- [ ] Old backups older than 30 days are automatically deleted

---

**Tip**: Keep this checklist updated as you make changes to the setup.