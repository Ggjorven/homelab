# Home Assistant

**Home Assistant** is a smart home operating system, this branch contains the installation instructions for installing **Home Assistant** as a **Proxmox VM**.

## Preview

![preview image]()

## Installation

1. From the **Proxmox Node**'s shell install **Home Assistant** as a **Proxmox VM** using the [community script](https://community-scripts.github.io/ProxmoxVE/scripts?id=haos-vm).
  ```
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/vm/haos-vm.sh)"
  ```
   
2. Now create your account.

3. If you have any smart devices already they should show up in the final to auto show.

## Configuring

To add more functionality to **Home Assistant** we can use **Home Assistant**'s addons. The addons can be found in the addon store.
This is located under `Settings` -> `Add-ons` -> `Add-on Store`.

### ESP Home

1. 

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- [Home Assistant](https://www.home-assistant.io/installation/generic-x86-64) - Smart Home OS Installation Guide
