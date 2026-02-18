# Homelab Central Repository

This repository acts as a central hub for my Homelab configuration.
Each service or stack lives in its own **dedicated branch**, keeping configurations organized, modular, and easy to manage.

## Overview

- ~~[`truenas`](https://github.com/Ggjorven/homelab/tree/truenas) is the NAS operating system running a network share.~~
- [`omv`](https://github.com/Ggjorven/homelab/tree/omv) is the NAS operating system running a network share.
- [`homepage`](https://github.com/Ggjorven/homelab/tree/homepage) is the dashboard for all my services.
- [`pihole`](https://github.com/Ggjorven/homelab/tree/pihole) is the network wide adblocker running on my home network.
- ~~[`jellyfin`](https://github.com/Ggjorven/homelab/tree/jellyfin) is a media player for playing media from my NAS.~~
- [`gluetun`](https://github.com/Ggjorven/homelab/tree/gluetun) is my VPN container.
- [`arrstack`](https://github.com/Ggjorven/homelab/tree/arrstack) is a combination of *arr services for ease of watching media.
- [`jellystack`](https://github.com/Ggjorven/homelab/tree/jellystack) is a combination of jellyfin related services for ease of streaming media.
- [`tvstack`](https://github.com/Ggjorven/homelab/tree/tvstack) is a combination of Live TV services for ease of streaming TV._
- [`immich`](https://github.com/Ggjorven/homelab/tree/immich) is a simple backup solution for your photos and videos.
- [`nginx`](https://github.com/Ggjorven/homelab/tree/nginx) is a proxy manager.
- [`pivpn`](https://github.com/Ggjorven/homelab/tree/pivpn) is a vpn that allows you to connect and route traffic through your home network from wherever.
- [`home-assistant`](https://github.com/Ggjorven/homelab/tree/home-assistant) is the smart home operating system deployed on my home server.
- ~~[`retropie`](https://github.com/Ggjorven/homelab/tree/retropie) is an emulator for old retro hardware that is streamed with sunshine to any device.~~
- ~~[`tunarr`](https://github.com/Ggjorven/homelab/tree/tunarr) is a service for simulating TV channels.~~

## Devices

- ~~**Main server** "nas" (i5-6402P, 8GB DDR3, NVIDIA GTX 750, 128GB SSD, 2TB HDD)~~
- **Main server** "main" (Ryzen 5 3600, 16GB DDR4, NVIDIA GTX 750, 500GB SSD, 128GB SSD, 3x2TB HDD)
- **Pi 2 w (1)** "pi2w-jorben-1"
- **Pi 2 w (2)** "pi2w-jorben-2"
- ~~**Pi 5 8gb** "pi5-jorben"~~

## Deployment instructions

I have deployed these services in this order:

1. [`omv`](https://github.com/Ggjorven/homelab/tree/omv) is deployed as a **Proxmox VM** on **Main server** (2vCPUs, 2GB RAM, 32GB Disk, 3x2TB HDD Passthrough).

2. [`pihole`](https://github.com/Ggjorven/homelab/tree/pihole) is deployed directly on **Pi 2 w (1)**.
3. [`homepage`](https://github.com/Ggjorven/homelab/tree/homepage) is deployed directly on **Pi 2 w (1)**.

4. [`gluetun`](https://github.com/Ggjorven/homelab/tree/gluetun) is deployed as **Docker Compose** on **Main server** -> **docker**.
5. [`arrstack`](https://github.com/Ggjorven/homelab/tree/arrstack) is deployed as **Docker Compose** on **Main server** -> **docker**.
6. [`jellystack`](https://github.com/Ggjorven/homelab/tree/jellystack) is deployed as **Docker Compose** on **Main server** -> **docker**.
7. [`tvstack`](https://github.com/Ggjorven/homelab/tree/tvstack) is deployed as **Docker Compose** on **Main server** -> **docker**.
8. [`immich`](https://github.com/Ggjorven/homelab/tree/immich) is deployed as **Docker Compose** on **Main server** -> **docker**.
   
9. [`nginx`](https://github.com/Ggjorven/homelab/tree/nginx) is deployed as a **Proxmox LXC** on **Main server** (2vCPUs, 2GB RAM, 20GB Disk).

10. [`pivpn`](https://github.com/Ggjorven/homelab/tree/pivpn) is deployed directly on **Pi 2 w (2)**.

11. [`home-assistant`](https://github.com/Ggjorven/homelab/tree/home-assistant) is deployed as a **Proxmox VM** on **Main server** (2vCPUs, 2GB RAM, 32GB Disk).

## Architecture

// TODO: Architecture diagram

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- ~~[TrueNAS](https://www.truenas.com) - NAS operating system~~
- [Open Media Vault](https://www.openmediavault.org) - NAS operating system
- [Homepage](https://gethomepage.dev) - Dashboard for all running services
- [Pi-hole](https://www.pi-hole.net) - Network-wide adblocking
- [Jellyfin](https://jellyfin.org) - Media player
- [Gluetun](https://gluetun.com/) - VPN Container
- [Immich](https://immich.app) - Photo/video backup
- [PiVPN](https://www.pivpn.io) - VPN Service
- [Home Assistant](https://www.home-assistant.io) - Home Assistant
- ~~[RetroPie](https://retropie.org.uk) - Hardware emulator~~
- [Nginx](https://nginx.org) - Proxy manager
- ~~[Tunarr](https://tunarr.com) - TV Channel simulator~~
