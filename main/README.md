# main

`main` is a **Proxmox VE** installed on a dedicated PC with a Ryzen 5 3600, 16GB of RAM, a RTX 3050 6GB, a 500GB boot SSD, a 128GB cache SSD and 3x2TB HDD's.  
This folder contains the installation instructions and configuration files used for this device.

## Specifications

- [`omv`](omv/README.md) (2vCPUs, 2GB RAM, 32GB Disk, 3x2TB HDD Passthrough).
- [`docker`](docker/README.md) (8vCPUs, 12GB RAM, 160GB Disk, GPU Passthrough).
- [`home-assistant`](home-assistant/README.md) (2vCPUs, 2GB RAM, 32GB Disk).

## Deployments

- [`omv`](omv/README.md)
- [`docker`](docker/README.md)
    - [`networkstack`](docker/networkstack/README.md)
    - [`monitoringstack`](docker/monitoringstack/README.md)
    - [`downloadstack`](docker/downloadstack/README.md)
    - [`arrstack`](docker/arrstack/README.md)
    - [`mediastack`](docker/mediastack/README.md)
    - [`musicstack`](docker/musicstack/README.md)
    - [`tvstack`](docker/tvstack/README.md)
    - [`sharestack`](docker/sharestack/README.md)
    - [`internetstack`](docker/internetstack/README.md)
- [`home-assistant`](home-assistant/README.md)

## Steps

1. // TODO: Steps

2. // TODO: Disable enterprise repo etc

## Debugging

If you have any issues setting up `main` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.
