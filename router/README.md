# router

`router` is a dedicated machine (m720q) running **Proxmox VE** with an i3-8100T, 16GB of RAM, 2 M.2 2.5GbE ethernet NICs and a 120GB SATA boot SSD.
This folder contains the installation instructions and configuration files used for this device.

## Deployments

| # | Type | vCPUs | RAM (MiB) | Disk (GB) | Name | Services | Description |
| -------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- |
| [100](./opnsense/README.md) | VM | 2 | 8192 | 32 | [opnsense](./opnsense/README.md) | OPNSense | Router and firewall |
| [101](./pi-hole/README.md) | LXC | 1 | 512 | 16 | [pi-hole](./pi-hole/README.md) | PiHole | Adblocking DNS resolver |

## Steps

1. Download the latest proxmox ISO image from [the proxmox iso download page](https://www.proxmox.com/en/downloads/proxmox-virtual-environment/iso). 

2. Flash the ISO to a USB stick using something like [balena etcher](https://etcher.balena.io/).

3. Now unplug the USB and put it in your machine and start it. Make sure to press your media selection or BIOS key (most likely Del or F12). Now make sure you boot from your USB.

4. You will now see the proxmox installation screen. You can choose between a graphical and a terminal install. I prefer terminal for compatibility.

5. Accept the EULA (after reading of course).

6. Select the target hard disk to install to if you want it on 1 SSD with no redundancy (most likely an SSD). If you want redundancy press **Options** and select `zfs (RAID1)` and select your 2 drives.

7. Set your **Country**, **Time zone** and **Keyboard Layout**.

8. Set a secure password and confirm it. For the email address I set it to `invalid@invalid.invalid` since we'll be using a different service for notifications.

9. Now select your network interface for management.

10. Set a local domain you can access your PVE from, don't pick a real domain! Example: `pve2.lan`. ([learn more](https://forum.proxmox.com/threads/hostname-fqdn-huh.63667/))

11. Set your IP address to something you like or keep it as the default (DHCP assigned). Remember this! You should be able to skip the gateway and the DNS server since those should be autofilled.

12. And **Install**!

13. After it has finished installing go to the IP address you chose on port `8096`. And login with username `root` and the password you set.

14. On the top left under **Datacenter** click on your node `pve2` or the name you chose.

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

23. After the reboot go back to the WebUI and go back to your `pve2` node. Now select **System** -> **Network**.

24. // TODO: Create a new bridge with no physical port.

## Debugging

If you have any issues setting up `main` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.
