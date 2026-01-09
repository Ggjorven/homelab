# Homelab Central Repository

This repository acts as a central hub for my Homelab configuration.
Each service or stack lives in its own **dedicated branch**, keeping configurations organized, modular, and easy to manage.

## Overview

- [`truenas`](https://github.com/Ggjorven/homelab/tree/truenas) is the NAS operating system running a network share.
- [`homepage`](https://github.com/Ggjorven/homelab/tree/homepage) is the dashboard for all my services.
- [`pihole`](https://github.com/Ggjorven/homelab/tree/pihole) is the network wide adblocker running on my home network.

## Devices

- **Main server** "nas" (i5-6xxx, 8gb ddr3, 128gb ssd, 2tb hdd)
- **Pi 2 w** "pi2w-jorben-1"
- **Pi 5 8gb** "pi5-jorben"

## Deployments

- [`truenas`](https://github.com/Ggjorven/homelab/tree/truenas) is deployed as a proxmox VM on **Main server**.
- [`homepage`](https://github.com/Ggjorven/homelab/tree/homepage) is deployed as an LXC container on **Main server**.
- [`pihole`](https://github.com/Ggjorven/homelab/tree/pihole) is deployed directly on **Pi 2 w**.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- [TrueNAS](https://www.truenas.com) - NAS operating system
- [Pi-hole](https://www.pi-hole.net) - Network-wide adblocking
