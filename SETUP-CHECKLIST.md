\# Vaultwarden Setup Checklist - TrueNAS Scale



Use this checklist to reproduce or verify the Vaultwarden setup.



\## 1. Prerequisites



\- \[ ] TrueNAS Scale is installed and updated

\- \[ ] `DataPool` storage pool exists

\- \[ ] Nginx Proxy Manager is installed and running

\- \[ ] DuckDNS domain `vaultwarden-nguyen.duckdns.org` is configured

\- \[ ] Ports 80 and 443 are forwarded on EdgeRouter-4 to TrueNAS

\- \[ ] Gmail account with App Password ready



\## 2. Installation



\- \[ ] Install Vaultwarden from \*\*Apps → Available Applications\*\*

\- \[ ] Set storage to `ixVolume` (default)

\- \[ ] Add environment variable: `ADMIN\_TOKEN` = (strong random string)

\- \[ ] Deploy the app



\## 3. Nginx Proxy Manager Configuration



\- \[ ] Create new Proxy Host

\- \[ ] Domain: `vaultwarden-nguyen.duckdns.org`

\- \[ ] Forward Host: `192.168.10.101`

\- \[ ] Forward Port: `8083`

\- \[ ] Enable \*\*Websockets Support\*\*

\- \[ ] Request Let's Encrypt certificate



\## 4. SMTP Setup (for User Invites)



\- \[ ] Access Admin UI: `https://vaultwarden-nguyen.duckdns.org/admin`

\- \[ ] Configure SMTP:

&#x20; - Host: `smtp.gmail.com`

&#x20; - Port: `587`

&#x20; - Secure: `starttls`

&#x20; - Username/From: your Gmail

&#x20; - Password: Gmail App Password



\## 5. Family Member Access



\- \[ ] Create "Nguyen Family" Organization

\- \[ ] Manually create user accounts in Admin UI

\- \[ ] Add users to Organization and assign Collections

\- \[ ] Share temporary passwords securely



\## 6. Automated Backups



\- \[ ] Create directory: `/mnt/DataPool/backups/bitwarden`

\- \[ ] Create passphrase file: `/mnt/DataPool/backups/bitwarden\_passphrase.txt`

\- \[ ] Place `vaultwarden\_backup.sh` in `/mnt/DataPool/backups/`

\- \[ ] Make script executable

\- \[ ] Create Cron Job in TrueNAS:

&#x20; - Command: `/mnt/DataPool/backups/vaultwarden\_backup.sh`

&#x20; - User: `root`

&#x20; - Schedule: Daily at 02:00



\## 7. Network \& Security



\- \[ ] Allow Clients VLAN (`192.168.30.0/24`) to access Nginx (ports 80/443)

\- \[ ] Confirm Guest VLAN is blocked from Vaultwarden

\- \[ ] Test access from Tailscale



\## 8. Final Verification



\- \[ ] Can access `https://vaultwarden-nguyen.duckdns.org`

\- \[ ] Admin UI works

\- \[ ] Backup script runs successfully

\- \[ ] Family members can log in and access shared collections

\- \[ ] Backups are being created and encrypted

