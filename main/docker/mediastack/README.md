# Media Stack

**Media Stack** is a collection of media streaming tools for streaming my content from any device, this branch contains the installation instructions for installing **Jellyfin & More** using **Docker Compose**.

## Preview

![preview image](docs/images/jellyfin.png)

## Prerequisites

Before we can create our `*arr stack` on our `docker` **Proxmox LXC**. We must have finished these steps:

- [`omv`](https://github.com/Ggjorven/homelab/tree/main/main/omv/README.md) + extras.
- [`NVIDIA Driver`](https://github.com/Ggjorven/homelab/tree/main/tutorials/proxmox/NVIDIA-DRIVERS-NODE.md)
- [`NVIDIA Driver LXC`](https://github.com/Ggjorven/homelab/tree/main/tutorials/proxmox/NVIDIA-DRIVERS-LXC.md)
- [`docker`](https://github.com/Ggjorven/homelab/tree/main/docker/README.md)
- [`gluetun`](https://github.com/Ggjorven/homelab/tree/main/docker/gluetun/README.md)

## Installation

1. Go to your users `home` directory and go to your dedicated docker directory and create a new directory for `mediastack`:
    ```
    cd ~
    cd docker
    mkdir -p mediastack
    cd mediastack
    ```

2. Retrieve the compose file and .env file:
    ```
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/mediastack/compose.yaml 
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/mediastack/.env
    ```

3. Before we can edit our .env we must identify our user. This is done with:
    ```
    id <yourusername>
    ```
    Take note of `uid` and `gid`.

4. Now open up your .env file:
    ```
    nano .env
    ```

4. Modify `PUID` to reflect your `uid` and `PGID` to reflect `gid`.

5. Now change our postgres credentials to something more secure. ([hint](https://randomkeygen.com/jwt-secret))
    ```
    JELLYSTAT_POSTGRES_USER=username
    JELLYSTAT_POSTGRES_PASSWORD=password
    JELLYSTAT_JWT_SECRET=secret    ```

6. We are now ready to start our docker stack.
    ```
    docker compose up -d
    ```

## Configuration

### Jellyfin

To configure **Jellyfin** you need to go to port `8096` of the ip address of the **Proxmox LXC**.

#### Settings

To change **Jellyfin**'s settings go to the hamburger menu in the top left and go to **Dashboard**.

##### General

1. Change `cache` path if you use a seperate drive (ex. `/mnt/jellyfin-cache/cache`)
   
2. Change `metadata` path if you use a seperate drive (ex. `/mnt/jellyfin-cache/metadata`)

3. Scroll to the bottom and hit **Save**.

##### Transcoding

1. Set **Hardware Acceleration** to **NVIDIA NVENC**.

2. Enable hardware decoding for:
- H264
- HEVC
- VC1
- AV1
- HEVC 10bit
- VP9 10bit

3. Enable **enhanced NVDEC decoder**.

4. Enable hardware encoding and set **Allow encoding in HEVC format**.

5. Change `trancode` path if you use a seperate drive (ex. `/mnt/jellyfin-cache/transcode`)

6. Scroll to the bottom and hit **Save**.

##### Trickplay

1. Enable **hardware decoding**.

2. Scroll to the bottom and hit **Save**.

---

If you use a seperate drive for transcoding, cache and metadata. Make sure to give it the right permissions like so:
```
chmod -R 777 /mnt/jellyfin-cache
```

#### Plugins

**Jellyfin** has an awesome plugin system with plenty of awesome plugins, [examples](https://github.com/awesome-jellyfin/awesome-jellyfin). In my **Jellyfin** deployment I run a lot of plugins listed below:

##### File Tranformation

Configuration steps:

1. Add the manifest listed below these steps to the repositories under **Dashboard** -> **Plugins** -> **Manage Repositories** -> **New Repository**.

###### Manifest:
```
https://www.iamparadox.dev/jellyfin/plugins/manifest.json
```

##### Jellyfin Enhanced

Configuration steps:

1. Add the manifest listed below these steps to the repositories under **Dashboard** -> **Plugins** -> **Manage Repositories** -> **New Repository**.

###### Manifest:
```
https://raw.githubusercontent.com/n00bcodr/jellyfin-plugins/main/10.11/manifest.json
```

##### Jellyfin Tweaks

Configuration steps:

1. Add the manifest listed below these steps to the repositories under **Dashboard** -> **Plugins** -> **Manage Repositories** -> **New Repository**.

###### Manifest:
```
https://raw.githubusercontent.com/n00bcodr/jellyfin-plugins/main/10.11/manifest.json
```

##### Intro Skipper

Configuration steps:

1. Add the manifest listed below these steps to the repositories under **Dashboard** -> **Plugins** -> **Manage Repositories** -> **New Repository**.

###### Manifest:
```
https://intro-skipper.org/manifest.json
```

##### InPlayerEpisodePreview

Configuration steps:

1. Add the manifest listed below these steps to the repositories under **Dashboard** -> **Plugins** -> **Manage Repositories** -> **New Repository**.

###### Manifest:
```
https://raw.githubusercontent.com/Namo2/InPlayerEpisodePreview/master/manifest.json
```

##### Custom Tabs

Configuration steps:

1. Add the manifest listed below these steps to the repositories under **Dashboard** -> **Plugins** -> **Manage Repositories** -> **New Repository**.

###### Manifest:
```
https://www.iamparadox.dev/jellyfin/plugins/manifest.json
```

##### Subtitles Extract

Subtitles Extract is located in the default **Stable Jellyfin** repository.

### Seerr

To configure **Seerr** we need to go to port `5055` of your **Proxmox LXC**'s IP address.

1.Select **Jellyfin** as the media server type.

2. Now set the URL of **Jellyfin** to `172.39.0.8` as defined in the [compose file](https://github.com/Ggjorven/homelab/blob/jellystack/jellystack.yaml). Leave `URL Base` empty. Set `Email Address` to something random. And choose an appropriate `Username` and `Password`.

3. Now **Sync Libraries**. Both **Movies** and **Series** and **Start the scan**.

4. Continue and set up your **Radarr** server. Make it the `Default Server` and set the `Name` to something like "Radarr". Set the IP address to `172.39.0.4` as defined in the [compose file](https://github.com/Ggjorven/homelab/blob/arrstack/arrstack.yaml). Go to **Radarr** and under `Settings` -> `General` you can find your API key. Finally set `Enable Scan`, `Enable Automatic Search` & `Tag Requests`. Now hit **Test**. And set your desired `Quality Profile` and `Root Folder`.

5. Continue go to **Sonarr**. Make it the `Default Server` and set the `Name` to something like "Radarr". Set the IP address to `172.39.0.3` as defined in the [compose file](https://github.com/Ggjorven/homelab/blob/arrstack/arrstack.yaml). Go to **Sonarr** and under `Settings` -> `General` you can find your API key. Set `Season Folders`, `Enable Scan`, `Enable Automatic Search` & `Tag Requests`. Now hit **Test**. And set your desired `Quality Profile` and `Root Folder`.

6. And finish your setup!

### Jellystat

To configure **Jellystat** we need to go to port `3000` of your **Proxmox LXC**'s IP address.

1. Create a new user for **Jellystat**.

2. Paste the **Jellyfin** address in the address bar with `http://`. It's `172.39.0.8` as defined in the [compose file](https://github.com/Ggjorven/homelab/blob/jellystack/jellystack.yaml).

3. Now go to **Jellyfin** on port `8096` of **Proxmox LXC**'s IP address. Go to hamburger menu in the top left -> **Dashboard** -> **API Keys** and create a new **API Key** for **Jellystat**.

4. Now go back and paste your **API Key**.

5. And you're finished!

## Start on boot-up

To make `mediastack` start-up on boot we can set up a **systemd** service. I have created a compose-boot service for this purpose.  

1. First make sure we have a folder for our script:
    ```
    mkdir -p /lxc/scripts
    cd /lxc/scripts
    ```

2. Now download my compose-boot script (if you have already downloaded it before, you can skip this):
    ```
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/scripts/compose-boot.sh
    chmod +x compose-boot.sh
    ```

3. Modify this script.
    ```
    nano compose-boot.sh
    ```
    Either add a `docker compose up -d` for your new stack or replace the existing one.  
    Modify `<username>` to reflect your linux user's username.
    ```
    cd /home/<username>/docker/mediastack
    docker compose up -d
    ```
    Eventually this script will contain all the stacks that need to start on start-up.

4. If you have already set up the **systemd** service you can skip the next steps. But now we need to create a **systemd** service to run this script on start-up.
    ```
    cd /etc/systemd/system
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/services/compose-boot.service
    ```

5. Modify the **systemd** service:
    ```
    nano compose-boot.service
    ```
    And change `User` and `Group` to reflect your linux user's username:
    ```
    User=<username>
    Group=<username>
    ```

6. Now enable this service:
    ```
    systemctl daemon-reload
    systemctl enable compose-boot
    systemctl start compose-boot
    ```

## References

- [Docker](https://www.docker.com) - Hardware accelerated containers
- [Jellyfin](https://jellyfin.org/) - Media streaming solution
- [Jellystat](https://github.com/CyferShepard/Jellystat) - Jellyfin statistics
- [Seerr](https://docs.seerr.dev/) - Media discovery
