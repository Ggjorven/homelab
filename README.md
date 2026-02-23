# Open Media Vault

**Open Media Vault** is a NAS operating system run as a **Proxmox VM**, this branch contains the steps to easily redeploy an **Open Media Vault** setup with an SMB network share.

## Installation

1. Create a **Proxmox VM** with the [omv iso image](https://www.openmediavault.org/download.html).
![preview image]()
- [`omv`](https://github.com/Ggjorven/homelab/tree/omv) is the NAS operating system running a network share.
- [`homepage`](https://github.com/Ggjorven/homelab/tree/homepage) is the dashboard for all my services.
- [`pihole`](https://github.com/Ggjorven/homelab/tree/pihole) is the network wide adblocker running on my home network.
- [`pivpn`](https://github.com/Ggjorven/homelab/tree/pivpn) is a vpn that allows you to connect and route traffic through your home network from wherever.
- [`gluetun`](https://github.com/Ggjorven/homelab/tree/gluetun) is my VPN container.
- [`arrstack`](https://github.com/Ggjorven/homelab/tree/arrstack) is a combination of *arr services for ease of watching media.
- [`jellystack`](https://github.com/Ggjorven/homelab/tree/jellystack) is a combination of jellyfin related services for ease of streaming media.
- [`navistack`](https://github.com/Ggjorven/homelab/tree/navistack) is a combination of services related to streaming Music.
- [`tvstack`](https://github.com/Ggjorven/homelab/tree/tvstack) is a combination of Live TV services for ease of streaming TV.
- [`immich`](https://github.com/Ggjorven/homelab/tree/immich) is a simple backup solution for your photos and videos.
- [`nginx`](https://github.com/Ggjorven/homelab/tree/nginx) is a proxy manager.
- [`home-assistant`](https://github.com/Ggjorven/homelab/tree/home-assistant) is the smart home operating system deployed on my home server.
- ~~[`truenas`](https://github.com/Ggjorven/homelab/tree/truenas) is the NAS operating system running a network share.~~
- ~~[`jellyfin`](https://github.com/Ggjorven/homelab/tree/jellyfin) is a media player for playing media from my NAS.~~
- ~~[`retropie`](https://github.com/Ggjorven/homelab/tree/retropie) is an emulator for old retro hardware that is streamed with sunshine to any device.~~
- ~~[`tunarr`](https://github.com/Ggjorven/homelab/tree/tunarr) is a service for simulating TV channels.~~

2. Pass through all the disks following these steps (taken from [wiki](https://pve.proxmox.com/wiki/Passthrough_Physical_Disk_to_Virtual_Machine_(VM)))::  
    
    1. List all disks on the **Proxmox Node** using the following command:
        ```
        lsblk |awk 'NR==1{print $0" DEVICE-ID(S)"}NR>1{dev=$1;printf $0" ";system("find /dev/disk/by-id -lname \"*"dev"\" -printf \" %p\"");print "";}'|grep -v -E 'part|lvm' 
        ```

    2. Take note of the path of the desired disk (example: `/dev/disk/by-id/ata-WDC_XXXXXXX_WD-XXXXXXXXXX`)

    3. Go to the Proxmox VM's **Hardware** page, take note of the latest already created (virtual) hard disk id. (example: `scsi0`)

    4. Pass your physical disk to the VM from the Node's shell using:
        ```
        qm set <VMID> -<LATEST DISKID + 1> /dev/disk/by-id/ata-WDC_XXXXXXX_WD-XXXXXXXXXX
        ```

        example: 

        ```
        qm set 101 -scsi1 /dev/disk/by-id/ata-WDC_XXXXXXX_WD-XXXXXXXXXX
        ```

    5. Finally we need to add the serial number to the disk by modifying the VMID configuration file. The file is located in `/etc/pve/qemu-server/<VMID>.conf`. To open the file use the following command:
        ```
        nano /etc/pve/qemu-server/<VMID>.conf
        ```

    example:
        ```
        nano /etc/pve/qemu-server/101.conf
        ```

    6. Now add `,serial=XXXXXXXXX` to the relevant disk named `scsiX` where the serial number is the final part of the ata disk path we got from step 2 in our example `WD-XXXXXXXXXX`.
        ```
        scsi1: /dev/disk/by-id/ata-WDCXXXXXXX-XXXXXX_WD-XXXXXXXX,backup=0,size=12345678910K,serial=WD-XXXXXXXXXX
        ```

    In recent proxmox versions `qemu` imposes a max length of 36 chars on a serial number. If your VM fails to start, truncate your serial number in the /etc/pve/qemu-server/<VMID>.conf file to 36 characters.

3. Login to **OMV** with username `admin` and password `openmediavault`.

4. Click your profile in the top-right and change the `admin` password.

5. Add a new user under `Users` -> `Users`.

6. Now we need to install plugins. `Plugins` are located under `System` -> `Plugins`. We'll be installing the: `openmediavault-md` plugin.

7. Before we can create a 'pool'/multiple device, we need to qipe the current devices to remove their signatures. This can be done under `Storage` -> `Disks`. Select the disk and press `Wipe`. When asked which method to use just select `Quick`.

8. Now we can head to `Storage` -> `Multiple Devices`. Create your pool with your desired layout. Now it will clean and resync. This can take a WHILE.

9. After that's finally finished we need create a filesystem on this large pool. This can be found under `Storage` -> `File Systems`.

10. Now we can create a shader folder under `Storage` -> `Shared Folders`. Choose the filesystem you just created.

11. To make this shared folder visible on the network we need to create an SMB Share under `Services` -> `SMB/CIFS` -> `Shares`. And create a new share and use the just created shared folder.

12. To enable it go to `Services` -> `SMB/CIFS` -> `Settings` and enable it. Optional: You can also set the SMB version to 3.0.
Extra notes
- ~~**Main server** "nas" (i5-6402P, 8GB DDR3, NVIDIA GTX 750, 128GB SSD, 2TB HDD)~~
- **Main server** "main" (Ryzen 5 3600, 16GB DDR4, NVIDIA RTX 3050 6GB, 500GB SSD, 128GB SSD, 3x2TB HDD)
- **Pi 2 w (1)** "pi2w-jorben-1"
- **Pi 2 w (2)** "pi2w-jorben-2"
- ~~**Pi 5 8gb** "pi5-jorben"~~

## Deployment instructions

I have deployed these services in this order:

1. [`omv`](https://github.com/Ggjorven/homelab/tree/omv) is deployed as a **Proxmox VM** on **Main server** (2vCPUs, 2GB RAM, 32GB Disk, 3x2TB HDD Passthrough).

2. [`pihole`](https://github.com/Ggjorven/homelab/tree/pihole) is deployed directly on **Pi 2 w (1)**.
3. [`homepage`](https://github.com/Ggjorven/homelab/tree/homepage) is deployed directly on **Pi 2 w (1)**.
4. [`pivpn`](https://github.com/Ggjorven/homelab/tree/pivpn) is deployed directly on **Pi 2 w (2)**.

5. [`gluetun`](https://github.com/Ggjorven/homelab/tree/gluetun) is deployed as **Docker Compose** on **Main server** -> **docker** (8vCPUs, 12GB RAM, 160GB Disk, GPU Passthrough).
6. [`arrstack`](https://github.com/Ggjorven/homelab/tree/arrstack) is deployed as **Docker Compose** on **Main server** -> **docker** (8vCPUs, 12GB RAM, 160GB Disk, GPU Passthrough).
7. [`jellystack`](https://github.com/Ggjorven/homelab/tree/jellystack) is deployed as **Docker Compose** on **Main server** -> **docker** (8vCPUs, 12GB RAM, 160GB Disk, GPU Passthrough).
8. [`navistack`](https://github.com/Ggjorven/homelab/tree/navistack) is deployed as **Docker Compose** on **Main server** -> **docker** (8vCPUs, 12GB RAM, 160GB Disk, GPU Passthrough).
9. [`tvstack`](https://github.com/Ggjorven/homelab/tree/tvstack) is deployed as **Docker Compose** on **Main server** -> **docker** (8vCPUs, 12GB RAM, 160GB Disk, GPU Passthrough).
10. [`immich`](https://github.com/Ggjorven/homelab/tree/immich) is deployed as **Docker Compose** on **Main server** -> **docker** (8vCPUs, 12GB RAM, 160GB Disk, GPU Passthrough).
   
11. [`nginx`](https://github.com/Ggjorven/homelab/tree/nginx) is deployed as a **Proxmox LXC** on **Main server** (2vCPUs, 2GB RAM, 20GB Disk).

12. [`home-assistant`](https://github.com/Ggjorven/homelab/tree/home-assistant) is deployed as a **Proxmox VM** on **Main server** (2vCPUs, 2GB RAM, 32GB Disk).

## Architecture

// TODO: Architecture diagram

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- [Open Media Vault](https://www.openmediavault.org) - NAS Operating System
- [More references](https://github.com/Ggjorven) - ...
- [Open Media Vault](https://www.openmediavault.org) - NAS operating system
- [Pi-hole](https://www.pi-hole.net) - Network-wide adblocking
- [Homepage](https://gethomepage.dev) - Dashboard for all running services
- [PiVPN](https://www.pivpn.io) - VPN Service
- [Gluetun](https://gluetun.com/) - VPN Container
- [QBitTorrent](https://www.qbittorrent.org/) - Torrenting client
- [NZBGet](https://nzbget.com/) - NZB downloader
- [Prowlarr](https://prowlarr.com/) - Indexer
- [Radarr](https://radarr.video/) - Movie organizer/manager
- [Sonarr](https://sonarr.tv/) - Series organizer/manager
- [Lidarr](https://lidarr.audio/) - Music organizer/manager
- [MeTube](https://github.com/alexta69/metube) - YouTube downloader
- [Jellyfin](https://jellyfin.org) - Media player
- [Jellystat](https://github.com/CyferShepard/Jellystat) - Jellyfin Statistics
- [Jellyseer](https://docs.seerr.dev/) - Jellyfin discovery
- [Dispatcharr](https://github.com/Dispatcharr/Dispatcharr) - M3U/XCode Filter & Proxy
- [Immich](https://immich.app) - Photo/video backup
- [Nginx](https://nginx.org) - Proxy manager
- [Home Assistant](https://www.home-assistant.io) - Home Assistant
- ~~[TrueNAS](https://www.truenas.com) - NAS operating system~~
- ~~[Tunarr](https://tunarr.com) - TV Channel simulator~~
- ~~[RetroPie](https://retropie.org.uk) - Hardware emulator~~
