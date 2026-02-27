# main

`main` is a **Proxmox VE** installed on a dedicated PC with a Ryzen 5 3600, 16GB of RAM, a RTX 3050 6GB, a 500GB boot SSD, a 128GB cache SSD and 3x2TB HDD's.  
This folder contains the installation instructions and configuration files used for this device.

## Specifications

- [`omv`](main/omv/README.md) (2vCPUs, 2GB RAM, 32GB Disk, 3x2TB HDD Passthrough).
- [`docker`](main/docker/README.md) (8vCPUs, 12GB RAM, 160GB Disk, GPU Passthrough).
- [`home-assistant`](main/home-assistant/README.md) (2vCPUs, 2GB RAM, 32GB Disk).

## Deployments

- [`omv`](main/omv/README.md)
- [`docker`](main/docker/README.md)
    - [`networkstack`](main/docker/networkstack/README.md)
    - [`downloadstack`](main/docker/downloadstack/README.md)
    - [`arrstack`](main/docker/arrstack/README.md)
    - [`mediastack`](main/docker/mediastack/README.md)
    - [`musicstack`](main/docker/musicstack/README.md)
    - [`tvstack`](main/docker/tvstack/README.md)
    - [`immich`](main/docker/immich/README.md)
    - [`nginx`](main/docker/nginx/README.md)
- [`home-assistant`](main/home-assistant/README.md)

## Steps

1. // TODO: Steps

2. // TODO: Disable enterprise repo etc

## Debugging

If you have any issues setting up `main` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.
