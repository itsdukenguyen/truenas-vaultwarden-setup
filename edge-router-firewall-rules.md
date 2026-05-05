# EdgeRouter-4 Firewall Rules for Vaultwarden Setup

Complete list of all firewall rules related to my Vaultwarden deployment.

**Last Updated:** April 30, 2026

## 1. LAN_IN Rules (Internal Access)

### Rule 23 - Allow Clients VLAN to Nginx (Vaultwarden)
```bash
set firewall name LAN_IN rule 23 action accept
set firewall name LAN_IN rule 23 description "Allow Clients to VLAN10 Nginx"
set firewall name LAN_IN rule 23 destination address 192.168.10.101
set firewall name LAN_IN rule 23 destination port 80,443
set firewall name LAN_IN rule 23 protocol tcp
set firewall name LAN_IN rule 23 source address 192.168.30.0/24
set firewall name LAN_IN rule 23 state established enable
set firewall name LAN_IN rule 23 state related enable
```

### Rule 19 - Allow Tailscale to VLAN10 Services (including Vaultwarden)
```bash
set firewall name LAN_IN rule 19 action accept
set firewall name LAN_IN rule 19 description "Allow VPN to VLAN10 Services"
set firewall name LAN_IN rule 19 destination address 192.168.10.0/24
set firewall name LAN_IN rule 19 destination port 445,9000,7878,20489,9091,8083
set firewall name LAN_IN rule 19 protocol tcp
set firewall name LAN_IN rule 19 source address 100.64.0.0/10
set firewall name LAN_IN rule 19 state established enable
set firewall name LAN_IN rule 19 state related enable
```

### Rule 22 - Allow Management VLAN to VLAN10 Services
```bash
set firewall name LAN_IN rule 22 action accept
set firewall name LAN_IN rule 22 description "Allow Management to VLAN10 Services"
set firewall name LAN_IN rule 22 destination address 192.168.10.0/24
set firewall name LAN_IN rule 22 destination port 445,9000,7878,20489,9091,8083
set firewall name LAN_IN rule 22 protocol tcp
set firewall name LAN_IN rule 22 source address 192.168.1.0/24
set firewall name LAN_IN rule 22 state established enable
set firewall name LAN_IN rule 22 state related enable
```
## 2. WAN_IN Rules (External Access)
```bash
#Nginx HTTPS + Vaultwarden - WAN_IN Rules (External Access)
set firewall name WAN_IN rule 29 action accept
set firewall name WAN_IN rule 29 description "Allow Nginx HTTPS and Vaultwarden WebSocket"
set firewall name WAN_IN rule 29 destination address 192.168.10.101
set firewall name WAN_IN rule 29 destination port 443
set firewall name WAN_IN rule 29 protocol tcp
set firewall name WAN_IN rule 29 state established enable
set firewall name WAN_IN rule 29 state new enable
set firewall name WAN_IN rule 29 state related enable
```

## 3. GUEST_IN Rules (Isolation)
```bash
# Block Guest VLAN to VLAN10 (including Vaultwarden) - GUEST_IN Rules (Isolation)
set firewall name GUEST_IN rule 24 action drop
set firewall name GUEST_IN rule 24 description "Block Guest to VLAN10 Services"
set firewall name GUEST_IN rule 24 destination address 192.168.10.0/24
set firewall name GUEST_IN rule 24 source address 192.168.40.0/24
```
## 4. WAN_OUT - SMTP Outbound (for Email Invites)
```bash
set firewall name WAN_OUT rule 10 action accept
set firewall name WAN_OUT rule 10 description "Allow SMTP Outbound from VLAN10"
set firewall name WAN_OUT rule 10 source address 192.168.10.0/24
set firewall name WAN_OUT rule 10 destination port 587
set firewall name WAN_OUT rule 10 protocol tcp
set firewall name WAN_OUT rule 10 state new enable
set firewall name WAN_OUT rule 10 state established enable
set firewall name WAN_OUT rule 10 state related enable
```

Full Apply Command Block
```bash
configure

# Paste all rules above here...

commit
save
exit
```