# VLAN Overview - Home Lab Network

This document outlines the VLAN architecture used in my homelab, with a focus on how **Vaultwarden** fits into the security model.

## Network Topology Summary

| VLAN ID | Name          | Subnet              | Purpose                                      | Access to Vaultwarden      | Internet Access |
|---------|---------------|---------------------|----------------------------------------------|----------------------------|-----------------|
| 1       | **Management**    | `192.168.1.0/24`    | Admin PCs, Servers Management, Trusted Devices | Full Access                | Yes             |
| 10      | **Servers**       | `192.168.10.0/24`   | TrueNAS, Vaultwarden, *arr apps, Services     | Full Access                | Yes             |
| 20      | **IoT**           | `192.168.20.0/24`   | Smart Home Devices, Home Assistant            | Limited (via HA)           | Yes             |
| 30      | **Clients**       | `192.168.30.0/24`   | Family PCs, Phones, Tablets                   | Via Nginx (HTTPS only)     | Yes             |
| 40      | **Guests**        | `192.168.40.0/24`   | Guest Wi-Fi, Visitors                         | **Blocked**                | Yes             |

**Tailscale VPN**: `100.64.0.0/10` → Full access to VLAN 10 (including Vaultwarden)

---

## Visual Diagram

```mermaid
graph TD
    A[Internet] --> B[EdgeRouter-4]
    B --> C[Management VLAN<br>192.168.1.0/24]
    B --> D[Servers VLAN<br>192.168.10.0/24<br>TrueNAS + Vaultwarden]
    B --> E[IoT VLAN<br>192.168.20.0/24]
    B --> F[Clients VLAN<br>192.168.30.0/24<br>Family Devices]
    B --> G[Guests VLAN<br>192.168.40.0/24]
    
    style D fill:#e3f2fd,stroke:#1976d2