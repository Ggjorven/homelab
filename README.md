# Tunarr

**Tunarr** is a Live TV channel streaming solution for emulating Live TV channels, this branch contains the installation instructions for installing **Tunarr** as an LXC Container.

## Preview

![preview image]()

## Installation

1. From the **Proxmox Node**'s shell install **Tunarr** as an **LXC Container** using the [community script](https://community-scripts.github.io/ProxmoxVE/scripts?id=tunarr). Make sure to pass through the GPU.
   ```
   bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct/tunarr.sh)"
   ```
   
2. TODO

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- [Tunarr](https://tunarr.com/) - Custom Live TV Channel hosting
