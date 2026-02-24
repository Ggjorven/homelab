# Homelab

Welcome to my homelab infrastructure repository.

This repository documents the complete setup of my self-hosted environment, including infrastructure, services, networking, automation, and supporting documentation.

Each top-level directory represents a physical device in the lab.  
Inside each device folder are detailed instructions, configuration files, compose stacks, and service documentation.

# Architecture Overview

My homelab consists of three primary machines:

| Device | Role | Description |
|--------|------|------------|
| `main` | Core Server | Proxmox host running core infrastructure and application stacks |
| `pi2w-1` | Network & Dashboard | DNS filtering + Homepage dashboard |
| `pi2w-2` | Remote Access | VPN gateway |

There is also a `tutorials` directory containing reusable infrastructure documentation.

## main 

The `main` machine is the heart of the homelab.

It runs **Proxmox VE** as the hypervisor and hosts:

- Storage service
    - Open Media Vault
- Docker-based application stacks
    - gluetun
    - *arr stack
    - jelly stack
    - navi stack
    - tv stack
    - immich
- Home automation
    - Home assistant 
    - ESP Home

## pi2w-1

This Raspberry Pi 2 W handles:

- Network-wide DNS filtering
    - Pi-hole
- Service dashboard
    - Homepage

## pi2w-2

This Raspberry Pi 2 W handles:

- Remote connection
    - PiVPN

# How to Use This Repository

1. Start at the device level (`main`, `pi2w-1`, `pi2w-2`)
2. Follow each device's README
3. Deploy individual stacks as needed
4. Use tutorials for reusable infrastructure patterns

# Status

This homelab is actively maintained and continuously evolving.

New stacks, improvements, and documentation updates are added almost daily.

# Contributing 

This is a personal homelab repository, but ideas, improvements, and suggestions are always welcome.

# License

This project is licensed under the MIT License. See [LICENSE](LICENSE.txt) for details.
