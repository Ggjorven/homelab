# Homelab Central Repository

This repository acts as a central hub for my Homelab configuration.
Each service or stack lives in its own **dedicated branch**, keeping configurations organized, modular, and easy to manage.

## Overview

- [`truenas`](https://github.com/Ggjorven/homelab/tree/truenas) is the NAS operating system running a network share.
- [`homepage`](https://github.com/Ggjorven/homelab/tree/homepage) is the dashboard for all my services.
- [`pihole`](https://github.com/Ggjorven/homelab/tree/pihole) is the network wide adblocker running on my home network.
- [`jellyfin`](https://github.com/Ggjorven/homelab/tree/jellyfin) is a media player for playing media from my NAS.
- [`arrstack`](https://github.com/Ggjorven/homelab/tree/arrstack) is a combination of *arr services for ease of watching media.
- [`immich`](https://github.com/Ggjorven/homelab/tree/immich) is a simple backup solution for your photos and videos.

## Devices

- **Main server** "nas" (i5-6402P, 8GB DDR3, NVIDIA GTX 750, 128GB SSD, 2TB HDD)
- **Pi 2 w** "pi2w-jorben-1"
- ~~**Pi 5 8gb** "pi5-jorben"~~

## Deployments

- [`truenas`](https://github.com/Ggjorven/homelab/tree/truenas) is deployed as a **Proxmox VM** on **Main server** (2vCPUs, 8GB RAM, 32GB Disk (should be 16GB)).
- [`homepage`](https://github.com/Ggjorven/homelab/tree/homepage) is deployed directly on **Pi 2 w**.
- [`pihole`](https://github.com/Ggjorven/homelab/tree/pihole) is deployed directly on **Pi 2 w**.
- [`jellyfin`](https://github.com/Ggjorven/homelab/tree/jellyfin) is deployed as an **LXC container** on **Main server** (2vCPUs, 2GB RAM, 16GB Disk, GPU Passthrough).
- [`arrstack`](https://github.com/Ggjorven/homelab/tree/arrstack) is deployed as a **Proxmox VM** on **Main server** (2vCPUs, 4GB RAM, 32GB Disk).
- [`immich`](https://github.com/Ggjorven/homelab/tree/immich) is deployed as an **LXC container** on **Main server** (4vCPUs, 4GB RAM, 20GB Disk).

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- [TrueNAS](https://www.truenas.com) - NAS operating system
- [Homepage](https://gethomepage.dev) - Dashboard for all running services
- [Pi-hole](https://www.pi-hole.net) - Network-wide adblocking
- [Jellyfin](https://jellyfin.org) - Media player
- [Immich](https://immich.app/) - Photo/video backup
