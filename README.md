# Homelab Central Repository

This repository acts as a central hub for my Homelab configuration.
Each service or stack lives in its own **dedicated branch**, keeping configurations organized, modular, and easy to manage.

## Overview

- [`truenas`](https://github.com/Ggjorven/homelab/tree/truenas) is the NAS operating system running a network share.
- [`homepage`](https://github.com/Ggjorven/homelab/tree/homepage) is the dashboard for all my services.
- [`pihole`](https://github.com/Ggjorven/homelab/tree/pihole) is the network wide adblocker running on my home network.
- [`jellyfin`](https://github.com/Ggjorven/homelab/tree/jellyfin) is a media player for playing media from my NAS.
- [`arrstack`](https://github.com/Ggjorven/homelab/tree/arrstack) is a combination of *arr services for ease of watching media.

## Devices

- **Main server** "nas" (i5-6xxx, 8gb ddr3, nvidia gtx 7xx, 128gb ssd, 2tb hdd)
- **Pi 2 w** "pi2w-jorben-1"
- ~~**Pi 5 8gb** "pi5-jorben"~~

## Deployments

- [`truenas`](https://github.com/Ggjorven/homelab/tree/truenas) is deployed as a **Proxmox VM** on **Main server**.
- [`homepage`](https://github.com/Ggjorven/homelab/tree/homepage) is deployed as an **LXC container** on **Main server**.
- [`pihole`](https://github.com/Ggjorven/homelab/tree/pihole) is deployed directly on **Pi 2 w**.
- [`jellyfin`](https://github.com/Ggjorven/homelab/tree/jellyfin) is deployed as an **LXC container** on **Main server**.
- [`arrstack`](https://github.com/Ggjorven/homelab/tree/arrstack) is deployed as a **Proxmox VM** on **Main server**.

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
