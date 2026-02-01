# Homelab Central Repository

This repository acts as a central hub for my Homelab configuration.
Each service or stack lives in its own **dedicated branch**, keeping configurations organized, modular, and easy to manage.

## Overview

- ~~[`truenas`](https://github.com/Ggjorven/homelab/tree/truenas) is the NAS operating system running a network share.~~
- [`omv`](https://github.com/Ggjorven/homelab/tree/omv) is the NAS operating system running a network share.
- [`homepage`](https://github.com/Ggjorven/homelab/tree/homepage) is the dashboard for all my services.
- [`pihole`](https://github.com/Ggjorven/homelab/tree/pihole) is the network wide adblocker running on my home network.
- [`jellyfin`](https://github.com/Ggjorven/homelab/tree/jellyfin) is a media player for playing media from my NAS.
- [`arrstack`](https://github.com/Ggjorven/homelab/tree/arrstack) is a combination of *arr services for ease of watching media.
- [`immich`](https://github.com/Ggjorven/homelab/tree/immich) is a simple backup solution for your photos and videos.
- [`pivpn`](https://github.com/Ggjorven/homelab/tree/pivpn) is a vpn that allows you to connect and route traffic through your home network from wherever.
- [`home-assistant`](https://github.com/Ggjorven/homelab/tree/home-assistant) is the smart home operating system deployed on my home server.
- ~~[`retropie`](https://github.com/Ggjorven/homelab/tree/retropie) is an emulator for old retro hardware that is streamed with sunshine to any device.~~

## Devices

- ~~**Main server** "nas" (i5-6402P, 8GB DDR3, NVIDIA GTX 750, 128GB SSD, 2TB HDD)~~
- **Main server** "main" (Ryzen 5 3600, 16GB DDR4, NVIDIA GTX 750, 500GB SSD, 128GB SSD, 3x2TB HDD)
- **Pi 2 w (1)** "pi2w-jorben-1"
- **Pi 2 w (2)** "pi2w-jorben-2"
- ~~**Pi 5 8gb** "pi5-jorben"~~

## Deployments

- ~~[`truenas`](https://github.com/Ggjorven/homelab/tree/truenas) is deployed as a **Proxmox VM** on **Main server** (2vCPUs, 6GB RAM, 32GB Disk, 3x2TB HDD Passthrough).~~
- [`omv`](https://github.com/Ggjorven/homelab/tree/omv) is deployed as a **Proxmox VM** on **Main server** (2vCPUs, 2GB RAM, 32GB Disk, 3x2TB HDD Passthrough).
- [`homepage`](https://github.com/Ggjorven/homelab/tree/homepage) is deployed directly on **Pi 2 w (1)**.
- [`pihole`](https://github.com/Ggjorven/homelab/tree/pihole) is deployed directly on **Pi 2 w (1)**.
- [`jellyfin`](https://github.com/Ggjorven/homelab/tree/jellyfin) is deployed as an **LXC container** on **Main server** (2vCPUs, 2GB RAM, 16GB Disk, 128GB SSD Passthrough, GPU Passthrough).
- [`arrstack`](https://github.com/Ggjorven/homelab/tree/arrstack) is deployed as a **Proxmox VM** on **Main server** (2vCPUs, 4GB RAM, 40GB Disk).
- [`immich`](https://github.com/Ggjorven/homelab/tree/immich) is deployed as an **LXC container** on **Main server** (4vCPUs, 6GB RAM, 32GB Disk, GPU Passthrough).
- [`pivpn`](https://github.com/Ggjorven/homelab/tree/pivpn) is deployed directly on **Pi 2 w (2)**.
- [`home-assistant`](https://github.com/Ggjorven/homelab/tree/home-assistant) is deployed as a **Proxmox VM** on **Main server** (2vCPUs, 2GB RAM, 32GB Disk).
- ~~[`retropie`](https://github.com/Ggjorven/homelab/tree/retropie) is deployed as an **LXC Container** on **Main server** (2vCPUs, 2GB RAM, 32GB Disk).~~

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- ~~[TrueNAS](https://www.truenas.com) - NAS operating system~~
- [Open Media Vault](https://www.openmediavault.org/) - NAS operating system
- [Homepage](https://gethomepage.dev) - Dashboard for all running services
- [Pi-hole](https://www.pi-hole.net) - Network-wide adblocking
- [Jellyfin](https://jellyfin.org) - Media player
- [Immich](https://immich.app/) - Photo/video backup
- [PiVPN](https://www.pivpn.io/) - VPN Service
- [Home Assistant](https://www.home-assistant.io) - Home Assistant
- [RetroPie](https://retropie.org.uk/) - Hardware emulator
