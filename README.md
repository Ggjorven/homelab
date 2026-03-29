# Homelab

Welcome to my homelab infrastructure repository.

This repository documents the complete setup of my self-hosted environment, including infrastructure, services, networking, automation, and supporting documentation.

Each top-level directory represents a physical device in the lab.  
Inside each device folder are detailed instructions, configuration files, compose stacks, and service documentation.

## Architecture Overview

My homelab consists of three primary machines:

| Device | Role | Description |
|--------|------|------------|
| `main` | Core Server | Proxmox host running core infrastructure and application stacks |
| `pi2w-1` | Network & Dashboard | DNS filtering + Homepage dashboard |
| `pi2w-2` | Remote Access | VPN gateway |

There is also a `tutorials` directory containing reusable infrastructure documentation.

### Image overview

// TODO: ...

### main 

The `main` machine is the heart of the homelab.

It runs **Proxmox VE** as the hypervisor and hosts:

- Storage service
    - Open Media Vault
- Docker-based application stacks
    - network stack
    - monitoring stack
    - download stack
    - *arr stack
    - media stack
    - music stack
    - tv stack
    - share stack
    - internet stack
- Home automation
    - Home assistant 
    - ESP Home

### pi2w-1

This Raspberry Pi 2 W handles:

- Network-wide DNS filtering
    - Pi-hole
- Service dashboard
    - Homepage

### pi2w-2

This Raspberry Pi 2 W handles:

- Remote connection
    - PiVPN

## How to Use

1. Start at the device level (`main`, `pi2w-1`, `pi2w-2`)
2. Follow each device's README.md
3. Deploy individual stacks as needed
4. Use tutorials for reusable infrastructure patterns

If you can't figure something out or it is broken checkout the respective DEBUGGING.md file.  
If you still can't figure it out you can reach out to me personally, I personally want to make this repository near bulletproof.

## Quick Navigation

To quickly navigate this repository I have this list of services below:

- [`main`](main/README.md)
    - [`omv`](main/omv/README.md)
    - [`docker`](main/docker/README.md)
        - [`networkstack`](main/docker/networkstack/README.md)
        - [`downloadstack`](main/docker/downloadstack/README.md)
        - [`monitoringstack`](main/docker/monitoringstack/README.md)
        - [`arrstack`](main/docker/arrstack/README.md)
        - [`mediastack`](main/docker/mediastack/README.md)
        - [`musicstack`](main/docker/musicstack/README.md)
        - [`tvstack`](main/docker/tvstack/README.md)
        - [`sharestack`](main/docker/sharestack/README.md)
        - [`internetstack`](main/docker/internetstack/README.md)
    - [`home-assistant`](main/home-assistant/README.md)

---

- [`pi2w-1`](pi2w-1/README.md)
    - [`pi-hole`](pi2w-1/pihole/README.md)
    - [`homepage`](pi2w-1/homepage/README.md)

---

- [`pi2w-2`](pi2w-2/README.md)
    - [`pivpn`](pi2w-2/pivpn/README.md)

## Status

This homelab is actively maintained and continuously evolving.

New stacks, improvements, and documentation updates are added almost daily.

## Disclaimer

This project is intended for legal use only. You are solely responsible for ensuring your use complies with all applicable local laws and regulations, including copyright and intellectual property law. The author accepts no responsibility or liability for any misuse of this software or any legal consequences arising from its use. Do not use this stack to download or distribute content you do not have the rights to.

## Contributing 

This is a personal homelab repository, but ideas, improvements, and suggestions are always welcome.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE.txt) for details.
