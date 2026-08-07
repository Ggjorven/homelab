# main

`main` is a dedicated machine running **Proxmox VE** with a Ryzen 5 3600, 64GB of RAM, a RTX 3050 6GB, dual 500GB boot SSDs, a 500GB cache SSD and 6x2TB HDD's.  
This folder contains the installation instructions and configuration files used for this device.

## Deployments

| # | Type | vCPUs | RAM (MiB) | Disk (GB) | Name | Services | Description | Passthrough | Sharing | Public | VLAN ID & IP range|
| -------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- |
| [100](./truenas/README.md) | VM | 4 | 16384 | 48 | [truenas](./truenas/README.md) | TrueNAS | 6x2TB RAIDZ2 with 500GB L2ARC and 16GB RAM | HBA | - | X | 100 \| 172.20.100.10/24 |
| [101](./media/README.md) | LXC | 4 | 4096 | 32 | [media](./media/README.md) | Jellyfin, Navidrome, Seerr, MusicSeerr | Media services | - | GPU | Yes, through proxy | 101 \| 172.20.101.10/24 |
| 102 | LXC | 2 | 1024 | 10 | media-mgmt | tinyMediaManager, metadata-remote | Media management services | - | - | X | 102 \| 172.20.102.10/24 |
| 103 | LXC | 4 | 4096 | 32 | photos | Immich | Photo library management | - | GPU | X | 103 \| 172.20.103.10/24 |
| 104 | LXC | 2 | 2048 | 32 | cloud | NextCloud, Paperless-ngx | Personal Cloud | - | - | Yes, through proxy | 104 \| 172.20.104.10/24 |
| 105 | LXC | 4 | 4096 | 32 | arr | Gluetun (x2), FlareSolverr, Jackett, Prowlarr, Radarr, Sonarr, Lidarr, Bazarr, Scraparr, Subsyncarr, Slskd, QBitTorrent, NZBGet, MeTube | Content download stack | - | GPU | X | 105 \| 172.20.105.10/24 |
| 106 | LXC | 2 | 1024 | 10 | post-arr | Unmanic, ffmpeg-normalizer, Subsyncarr | Post processing on downloaded content| - | GPU | X | 106 \| 172.20.106.10/24 |
| 107 | LXC | 2 | 1024 | 48 | git | Gitea | Git server | - | - | Yes, through proxy | 107 \| 172.20.107.10/24 |
| 108 | LXC | 1 | 512 | 10 | vault | Vaultwarden | Password manager | - | - | Yes, through proxy | 108 \| 172.20.108.10/24 |
| 109 | LXC | 2 | 2048 | 10 | dashboard | Grafana, Gotify | Dashboard/fronted of monitoring | - | - | Yes, through proxy| 100 \| 172.20.109.10/24 |
| 110 | LXC | 2 | 4096 | 80 | monitoring | Prometheus, Loki | Monitoring of all services | - | - | X | 110 \| 172.20.110.10/24 |
| 111 | LXC | 1 | 512 | 10 | mgmt | Portainer | Management of all (docker) services | - | - | X | 111 \| 172.20.111.10/24 |
| 112 | LXC | 2 | 1024 | 10 | pub-net | OpenResty, Authelia, Crowdsec, Fail2ban | Public reverse proxy with authentication DMZ | - | - | Yes, port 80 and 443 | 112 \| 172.20.112.10/24 |
| 113 | LXC | 1 | 512 | 10 | priv-net | OpenResty, DDNS | Private reverse proxy and some network utilities | - | - | X | 113 \| 172.20.113.10/24 |
| [114](./haos/README.md) | VM | 2 | 2048 | 32 | [haos](./haos/README.md) | Home Assistant | Smarthome system | - | - | X | 114 \| 172.20.114.10/24 |
| 115 | LXC | 2 | 2048 | 20 | search | SearchXNG, Hermes + CliProxyAPI | Search engine + AI | - | GPU | X | 115 \| 172.20.115.10/24 |
| 116 | LXC | 2 | 2048 | 32 | misc | Mealie + Nametag + Leantime + Memos + ... | Miscellaneous tools | - | - | X | 116 \| 172.20.116.10/24 |

## Steps

1. Download the latest proxmox ISO image from [the proxmox iso download page](https://www.proxmox.com/en/downloads/proxmox-virtual-environment/iso). 

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

23. After the reboot go back to the WebUI and go back to your `pve1` node's **Shell**.

24. Switch from `iptables` to `nftables`:
    ```sh
    update-alternatives --set iptables /usr/sbin/iptables-nft
    update-alternatives --set ip6tables /usr/sbin/ip6tables-nft
    ```

25. Edit `/etc/network/interfaces`:
    ```sh
    nano /etc/network/interfaces
    ```
    And paste (above the `source /etc/network/interfaces.d/*` line):
    ```
    auto vmbr1
    iface vmbr1 inet manual
        bridge-ports none
        bridge-stp off
        bridge-fd 0
        bridge-vlan-aware yes
        bridge-vids 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116

    # Host gateway IPs, one per VLAN
    auto vmbr1.100
    iface vmbr1.100 inet static
         address 172.20.100.1/24

    auto vmbr1.101
    iface vmbr1.101 inet static
         address 172.20.101.1/24

    auto vmbr1.102
    iface vmbr1.102 inet static
         address 172.20.102.1/24

    auto vmbr1.103
    iface vmbr1.103 inet static
        address 172.20.103.1/24

    auto vmbr1.104
    iface vmbr1.104 inet static
        address 172.20.104.1/24

    auto vmbr1.105
    iface vmbr1.105 inet static
        address 172.20.105.1/24

    auto vmbr1.106
    iface vmbr1.106 inet static
        address 172.20.106.1/24

    auto vmbr1.107
    iface vmbr1.107 inet static
        address 172.20.107.1/24

    auto vmbr1.108
    iface vmbr1.108 inet static
        address 172.20.108.1/24

    auto vmbr1.109
    iface vmbr1.109 inet static
        address 172.20.109.1/24

    auto vmbr1.110
    iface vmbr1.110 inet static
        address 172.20.110.1/24

    auto vmbr1.111
    iface vmbr1.111 inet static
        address 172.20.111.1/24

    auto vmbr1.112
    iface vmbr1.112 inet static
        address 172.20.112.1/24

    auto vmbr1.113
    iface vmbr1.113 inet static
        address 172.20.113.1/24

    auto vmbr1.114
    iface vmbr1.114 inet static
        address 172.20.114.1/24

    auto vmbr1.115
    iface vmbr1.115 inet static
        address 172.20.115.1/24

    auto vmbr1.116
    iface vmbr1.116 inet static
        address 172.20.116.1/24
    ```
    This creates a bridge without a physical interface.  
    Where for every VLAN there is an ID defined in `bridge-vids` as well as a VLAN address block below.

26. While still in the `/etc/network/interfaces` file under `vmbr0` add the line:
    ```
    post-up nft -f /etc/nftables.conf
    ```
    And now you can save and exit.

27. Retrieve the `/etc/nftables.conf` file:
    ```sh
    cd /etc/
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/nftables/nftables.conf
    ```

28. Enable IPv4 forwarding, so `vmbr1` also has internet access:
    ```sh
    echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
    sysctl -p
    ```

29. Enable `nftables`:
    ```sh
    systemctl enable --now nftables
    nft -f /etc/nftables.conf
    ```

30. Reboot your **Proxmox Node** to get all VLANs properly initialized.

31. Once back we can start creating our **VM**'s and **LXC**'s:
    - [`truenas`](./truenas/README.md)
    - [`media`](./media/README.md)

## Debugging

If you have any issues setting up `main` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.
