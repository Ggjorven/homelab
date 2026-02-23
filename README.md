# Pi-hole

Pi-hole is a custom DNS server and used as a network wide adblocker in my case, it's deployed directly on a **Pi 2 w** connected via ethernet. This branch contains the installation instructions and files used during the installation.

## Installation

1. Use the [Raspberry Pi Imager](https://www.raspberrypi.com/software/) to install **Raspberry Pi OS Lite (32-bit)** on your **Pi 2 W**.

2. SSH into your **Pi 2 W** using the following command:
    ```
    ssh <username>@<ip address of pi 2 w>
    ```

3. Make sure your **Pi 2 W** is up to date using the following commands:
    ```
    sudo apt update && sudo apt upgrade -y
    sudo reboot
    ```

4. Once you're back in install Pi-hole using the following command:
    ```
    curl -sSL https://install.pi-hole.net | bash
    ```

5. Go to the **Pi 2 W**'s ip-address in a web browser and login. Now navigate to the **Lists** section and individually add each address in [block_lists](block_lists.txt) with **Add blocklist**.

6. Now go to **Settings/Privacy** and switch from **Basic** to **Expert** in the top-right. 

7. Disable **Log DNS queries and replies** and set **Query Anonymization** to **Anonymous Mode**.

8. Now start enjoying your ad-free browsing experience by setting your **Pi 2 W**'s ip-address as a DNS server in your router.

## Extra notes

The reason these are instructions and not easily deployable files is because alongside all the settings in pi-hole's files there are password hashes and ip-addresses I don't want to risk uploading.
# Homepage

Homepage is a dashboard service run directly on the **Pi 2 W**, this branch contains the `/config` folder of the `/opt/homepage/` folder.

## Preview

![Preview of Dashboard](docs/images/preview.png)

## Installation

1. To get started installing homepage we follow [these instructions](https://gethomepage.dev/installation/source/). We start by cloning the repo in the right place:
    ```
    cd /opt/
    git clone https://github.com/gethomepage/homepage.git
    ```

2. Now we need to install `npm` and `pnpm` if they're not already installed:
    ```
    sudo apt install npm
    npm install -g pnpm
    ```

3. Now install the required dependencies for this project:
    ```
    pnpm install
    ```
    This command may fail due to running out of heap memory. It'll end with a `Killed` message. If you wish to "create" more heap memory you need to create a swapfile (2GB works pretty well).
    ```
    sudo fallocate -l 2G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile 
    ```
    And for extra safety run the command with this option:
    ```
    NODE_OPTIONS="--max-old-space-size=512" pnpm install 
    ```

4. Now we can start building homepage:
    ```
    pnpm build
    ```
    If this command also fails also run this command with these options:
    ```
    NODE_OPTIONS="--max-old-space-size=512" pnpm build 
    ```
   
5. Remove `/opt/homepage/config` folder.

6. Clone the repository into the `/opt/homepage/config` folder:
    ```
    git clone https://github.com/Ggjorven/homelab.git -b homepage /opt/homepage/config
    ```

7. Create or modify the `.env` in `/opt/homepage/` following this format replacing the placeholders with actual values.
    ```
    HOMEPAGE_ALLOWED_HOSTS=192.168.x.x:3000

    HOMEPAGE_VAR_PROXMOX_IP=192.168.x.x
    HOMEPAGE_VAR_PROXMOX_URL=https://192.168.x.x:8006
    HOMEPAGE_VAR_PROXMOX_USERNAME=xxxxx@pam!xxxxx
    HOMEPAGE_VAR_PROXMOX_SECRET=

    HOMEPAGE_VAR_TRUENAS_IP=192.168.x.x
    HOMEPAGE_VAR_TRUENAS_URL=https://192.168.x.x
    HOMEPAGE_VAR_TRUENAS_USERNAME=
    HOMEPAGE_VAR_TRUENAS_PASSWORD=

    HOMEPAGE_VAR_PIHOLE_IP=192.168.x.x
    HOMEPAGE_VAR_PIHOLE_URL=https://192.168.x.x
    HOMEPAGE_VAR_PIHOLE_PASSWORD=
    ```

8. To make this start on bootup we need to install a systemctl service. I have created one. Use this command to create the service:
    ```
    cd /etc/systemd/system
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/homepage/services/start-homepage.service
    ```

9. Now we just need to enable it:
    ```
    systemctl daemon-reload
    systemctl enable start-homepage
    systemctl start start-homepage
    ```
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

- [Raspberry Pi Imager](https://www.raspberrypi.com/software/) - Imaging tool for raspberry pi
- [Pi-hole](https://www.pi-hole.net) - Custom DNS server for easy network wide adblocking & more...
- [Proxmox](https://www.proxmox.com) - Hypervisor
- [Homepage](https://github.com/gethomepage/homepage) - Dashboard
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
