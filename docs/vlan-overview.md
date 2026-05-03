\# VLAN Overview - Home Lab



\## VLAN Structure



| VLAN | Name          | Subnet             | Purpose                          | Access to Vaultwarden |

|------|---------------|--------------------|----------------------------------|-----------------------|

| 1    | Management    | 192.168.1.0/24     | Admin PCs, Servers Management    | Full                  |

| 10   | Servers       | 192.168.10.0/24    | TrueNAS, Vaultwarden, \*arr apps  | Full                  |

| 20   | IoT           | 192.168.20.0/24    | Smart devices, Home Assistant    | Limited               |

| 30   | Clients       | 192.168.30.0/24    | Personal devices, Family         | Via Nginx (443)       |

| 40   | Guests        | 192.168.40.0/24    | Guest Wi-Fi                      | Blocked               |



\*\*Tailscale VPN\*\*: `100.64.0.0/10` - Full access to Vaultwarden



\## Firewall Summary



\- \*\*Clients VLAN\*\* → Allowed to Nginx (port 443)

\- \*\*Tailscale\*\* → Full access to VLAN 10

\- \*\*Guest VLAN\*\* → Completely blocked from VLAN 10 services



This segmentation ensures security while allowing family access.

