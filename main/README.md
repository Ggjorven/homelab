# main

`main` is a dedicated machine running **Proxmox VE** with a Ryzen 5 3600, 64GB of RAM, a RTX 3050 6GB, dual 500GB boot SSDs, a 500GB cache SSD and 6x2TB HDD's.  
This folder contains the installation instructions and configuration files used for this device.

## Specifications

- [`omv`](omv/README.md) (2vCPUs, 2GB RAM, 32GB Disk, HDD Passthrough (HBA)).
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

1. Download a proxmox ISO image from [proxmox isos](https://www.proxmox.com/en/downloads/proxmox-virtual-environment/iso). 

2. Flash the ISO to a USB stick using something like [balena etcher](https://etcher.balena.io/).

3. Now unplug the USB and put it in your machine and start it. Make sure to press your media selection or BIOS key (most likely Del or F12). Now make sure you boot from your USB.

4. You will now see the proxmox installation screen. You can choose between a graphical and a terminal install. I prefer terminal for compatibility. ([NVIDIA Graphical help](https://www.reddit.com/r/Proxmox/comments/nyez25/quick_howto_using_the_proxmox_iso_on_an_nvidia_gpu/))

5. Accept the EULA (after reading of course).

6. Select the target hard disk to install to if you want it on 1 SSD with no redundancy (most likely an SSD). If you want redundancy press **Options** and select `zfs (RAID1)` and select your 2 drives.

7. Set your **Country**, **Time zone** and **Keyboard Layout**.

8. Set a secure password and confirm it. For the email address I set it to `invalid@invalid.invalid` since we'll be using a different service for notifications.

9. Now select your network interface (likely only 1 option).

10. Set a local domain you can access your PVE from, don't pick a real domain! Example: `pve1.lan`. ([learn more](https://forum.proxmox.com/threads/hostname-fqdn-huh.63667/))

11. Set your IP address to something you like or keep it as the default (DHCP assigned). Remember this! You should be able to skip the gateway and the DNS server since those should be autofilled.

12. And **Install**!

13. After it has finished installing go to the IP address you chose on port `8096`. And login with username `root` and the password you set.

14. On the top left under **Datacenter** click on your node `pve1` or the name you chose.

15. Open the **Shell** and paste (from [here](https://community-scripts.org/scripts/post-pve-install)):
    ```sh
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/tools/pve/post-pve-install.sh)"
    ```
    This opens a post install script.

16. Start the script.

17. Disable the `pve-enterprise` and `ceph-enterprise` repo.

18. Enable the `pve-no-subscription` repo. Don't enable the the `pve-test` repo.

19. Disable the subscription nag message.

20. Don't enable high availability (it consumes more system resources and is unnecessary in a homelab).

21. You can also disable **Corosync**.

22. Update your **Proxmox VE** and reboot.

23. After the reboot go back to the WebUI and go back to your `pve1` node.

24. // TODO: Create a new bridge with no physical port.

25. // TODO: Proxmox Prometheus exporter

## Debugging

If you have any issues setting up `main` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.
