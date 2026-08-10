# media

`media` is a **Proxmox LXC** on the **Proxmox Node** with **docker** and **docker compose** installed.  
This folder contains the installation instructions and configuration files used for this device.

## Prerequisites

Before we can create our `media` **Proxmox LXC**. We must have finished these steps:

- [`truenas`](../truenas/README.md)
- [`Node NVIDIA Driver`](../../tutorials/proxmox/NVIDIA-DRIVERS-NODE.md)

## Steps

1. From the **Proxmox** WebUI navigate to the **Node**'s **Shell**.

2. Start creation of a **Docker LXC** using the [community script](https://community-scripts.org/scripts/docker):
    ```
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct/docker.sh)"
    ```

3. Choose `Advanced Install`. 

4. Choose **Unpriviliged**, set a safe root password, set the container ID to `101` (matches with the VLAN) and set the hostname to `media` (or something else).

5. For the `media` LXC I have given it a disk of **48GB**, **4vCPU**s and **4096MiB** of RAM.

6. For the (primary) **Network Bridge** select `vmbr1` and set a static IP (since we don't have a DHCP server). Set the IP to `172.20.101.10/24` and the gateway to `172.20.101.1`. For IPv6 select `none`.

7. Leave **MTU Size** blank, same for **DNS search domain**, **DNS server IP** and **MAC-address**.

8. Set the **VLAN tag** to `101` to get the proper firewall rules.

9. You can keep the **Tags** as default or set it to something custom like: `docker;media`.

10. Provision the SSH for root by using the `found` option (or provide your own). Use space to select the key. And enable `root` SSH access.

11. Leave **FUSE support** disabled, same for **TUN/TAP** support.

12. **Enable nesting** and **Enable GPU passthrough**.

13. Leave **APT-cacher** disabled and don't set a **HTTP/HTTPS proxy**.

14. Set your **Timezone** to your timezone, mine is `Europe/Amsterdam`.

15. (Optional) Personally I like to have **Container protection** enabled to avoid accidental deletion.

16. Set **Allow device node creation** to No and leave **Filesystem mounts** empty. Same for the **Post-install hook**.

17. (Optional) If you want verbose output during installation enable it. (I like it)

18. Confirm the settings and wait... (If you're asked to update the defaults just hit Cancel)

19. When it asks you to install **Portainer** select **N**. Same for the **Portainer Agent**.

20. Also don't expose the **Docker TCP Socket**, so **N**.

21. Now that the container is installed go to the **LXC** in the WebUI and go to **Network**.

22. Double click on `net0`/`eth0`/`vmbr1` and disable the **Firewall**, since we'll be setting up our own firewall rules.

23. For debugging I also like to **Add** another **Network Device**. 

24. Set the **Name** to `eth1`. Set the **Bridge** to `vmbr0` and disable the **Firewall**.

25. Set **IPv4** to **DHCP** (since it's only for debugging) and set **IPv6** to **Static** and leave it empty. **Add**!

26. We also want to give the **LXC** access to our `media` dataset from [truenas](./../truenas/README.md), so open the **Proxmox Node**'s **Shell**.

27. Edit the **LXC**'s config file:
    ```sh
    nano /etc/pve/lxc/101.conf
    ```
    Where `101` is the container ID (CTID) or LXC ID.

28. Pass through the `/mnt/media` mountpoint by pasting:
    ```
    mp0: /mnt/media,mp=/mnt/media
    ```

29. We'll also want to make the `media`'s user and group ID to be properly passed through to the mountpoint/NFS share. `media`:`media` is `1001`:`1001` as set during the [truenas installation](./../truenas/README.md). So also paste this in `/etc/pve/lxc/101.conf`:
    ```
    lxc.idmap: g 0 100000 1001
    lxc.idmap: g 1001 1001 1
    lxc.idmap: g 1002 101002 64534
    lxc.idmap: u 0 100000 1001
    lxc.idmap: u 1001 1001 1
    lxc.idmap: u 1002 101002 64534
    ```
    The explanation/tutorial for these id mappings can be found [here](./../../tutorials/proxmox/UNPRIVILEGED-LXC-UID-GID-PASSTHROUGH.md).

30. Now reboot the **LXC**.

31. Now go to **LXC**'s **Shell** and login with `root` and the password you set in the installation.

32. Install the same NVIDIA drivers on the **LXC** as on the **Proxmox Node** with [this tutorial](./../../tutorials/proxmox/NVIDIA-DRIVERS-LXC.md).

33. Create a `media` group and user in the LXC using:
    ```sh
    groupadd -g 1001 media
    useradd -u 1001 -g 1001 -m -s /bin/bash media
    usermod -aG docker media
    usermod -aG sudo media
    ```

34. Set a (safe) password for the `media` user:
    ```sh
    passwd media
    ```

35. Now login as the `media` user:
    ```sh
    su media
    ```

36. Now we're going to install all of the files. Start by navigating to the `home` directory:
    ```sh
    cd ~/
    ```

37. Get the global .env:
    ```sh
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/media/.env
    ```

38. Create the `networking` stack:
    ```sh
    mkdir -p ~/networking
    cd ~/networking
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/media/networking/.env
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/media/networking/compose.yaml
    ```

39. Create the `monitoring` stack:
    ```sh
    mkdir -p ~/monitoring
    cd ~/monitoring
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/media/monitoring/.env
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/media/monitoring/compose.yaml
    ```

40. Create the `jellyfin` stack:
    ```sh
    mkdir -p ~/jellyfin
    cd ~/jellyfin
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/media/jellyfin/.env
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/media/jellyfin/compose.yaml
    ```

41. Get the `up` and `down` scripts:
    ```sh
    sudo mkdir -p /lxc/scripts
    cd /lxc/scripts
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/media/scripts/up-networking.sh
    sudo chmod +x up-networking.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/media/scripts/up-monitoring.sh
    sudo chmod +x up-monitoring.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/media/scripts/up-jellyfin.sh
    sudo chmod +x up-jellyfin.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/media/scripts/down-networking.sh
    sudo chmod +x down-networking.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/media/scripts/down-monitoring.sh
    sudo chmod +x down-monitoring.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/media/scripts/down-jellyfin.sh
    sudo chmod +x down-jellyfin.sh
    ```

42. Also get the `compose-boot`, `compose-shutdown` and `compose-restart` scripts and services:
    ```sh
    sudo mkdir -p /lxc/scripts
    cd /lxc/scripts
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/media/scripts/compose-boot.sh
    sudo chmod +x compose-boot.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/media/scripts/compose-shutdown.sh
    sudo chmod +x compose-shutdown.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/media/scripts/compose-restart.sh
    sudo chmod +x compose-restart.sh
    cd /etc/systemd/system
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/media/services/compose-boot.service
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/media/services/compose-shutdown.service
    ```

43. Enable the `systemctl` for `compose-boot` and `compose-shutdown`:
    ```sh
    sudo systemctl daemon-reload
    sudo systemctl enable compose-boot
    sudo systemctl enable compose-shutdown
    ```

44. Now start the `networking` and `monitoring` stacks:
    ```sh
    sudo /lxc/scripts/up-networking.sh
    sudo /lxc/scripts/up-monitoring.sh
    ```
    You can now start configuring individual stacks listed below.

## Configuration

### Jellyfin

Before we can configure the settings inside **Jellyfin** we must set certain `env` variables.  
Open `.env`:
```sh
nano ~/jellyfin/.env
```
Set `MOVIES_FOLDER` to the actual movies directory.  
Do the same for `SERIES_FOLDER`.

Start **Jellyfin** by running:
```sh
sudo /lxc/scripts/up-jellyfin.sh
```

To configure **Jellyfin** you need to go to port `8096` of the ip address of the **Proxmox LXC** if `vmbr0` is attached (and enabled).

#### Settings

To change **Jellyfin**'s settings go to the hamburger menu in the top left and go to **Dashboard**.

##### Transcoding

1. Set **Hardware Acceleration** to **NVIDIA NVENC**.

2. Enable hardware decoding for (for RTX 3050):
    - H264
    - HEVC
    - MPEG2
    - VC1
    - VP9
    - AV1
    - HEVC 10bit
    - VP9 10bit

    You can find out what your NVIDIA GPU supports [here](https://en.wikipedia.org/wiki/NVDEC).  
    For AMD you can look [here](https://en.wikipedia.org/wiki/Unified_Video_Decoder).  
    And Intel [here](https://www.intel.com/content/www/us/en/docs/onevpl/developer-reference-media-intel-hardware/1-1/overview.html).

3. Enable **enhanced NVDEC decoder**.

4. Enable hardware encoding and set **Allow encoding in HEVC format**.

5. Scroll to the bottom and hit **Save**.

##### Trickplay

1. Enable **hardware decoding**.

2. Scroll to the bottom and hit **Save**.

#### Plugins

**Jellyfin** has an awesome plugin system with plenty of awesome plugins, [examples](https://github.com/awesome-jellyfin/awesome-jellyfin). In my **Jellyfin** deployment I run a lot of plugins listed below:

- [Cover Art Archive](https://github.com/jellyfin/jellyfin-plugin-coverartarchive) - Installed by default
- [Custom Tabs](https://github.com/IAmParadox27/jellyfin-plugin-custom-tabs) - Installed from [this manifest](https://www.iamparadox.dev/jellyfin/plugins/manifest.json)
- [File Transformation](https://github.com/IAmParadox27/jellyfin-plugin-file-transformation) - Installed from [this manifest](https://www.iamparadox.dev/jellyfin/plugins/manifest.json)
- [InPlayerEpisodePreview](https://github.com/Namo2/InPlayerEpisodePreview) - Installed from [this manifest](https://raw.githubusercontent.com/Namo2/InPlayerEpisodePreview/master/manifest.json)
- [Intro Skipper](https://github.com/intro-skipper/intro-skipper) - Installed from [this manifest](https://intro-skipper.org/manifest.json)
- [Javascript Injector](https://github.com/n00bcodr/Jellyfin-JavaScript-Injector) - Installed from [this manifest](https://raw.githubusercontent.com/n00bcodr/jellyfin-plugins/main/10.11/manifest.json)
- [Jellyfin Enhanced](https://github.com/n00bcodr/Jellyfin-Enhanced) - Installed from [this manifest](https://raw.githubusercontent.com/n00bcodr/jellyfin-plugins/main/10.11/manifest.json)
- [Segment Editor](https://github.com/intro-skipper/segment-editor-plugin) - Installed from [this manifest](https://intro-skipper.org/manifest.json)
- [TheIntroDB](https://github.com/TheIntroDB/jellyfin-plugin) - Installed from [this manifest](https://raw.githubusercontent.com/TheIntroDB/jellyfin-plugin/main/manifest.json)
- [KefinTweaks](https://github.com/ranaldsgift/kefintweaks) - Installed using [Javascript Injector](https://github.com/n00bcodr/Jellyfin-JavaScript-Injector)
- [TheTVDB](https://github.com/jellyfin/jellyfin-plugin-tvdb) - Installed using the default manifest

// TODO: Install from a manifest instructions

##### Jellyfin Enhanced

// TODO: Customization settings

##### KefinTweaks

// TODO: Install help

// TODO: Customization settings

#### *Arr Connection

> [!NOTE]
> Requires [arr](./../arr/README.md) to be set-up.

To immediately scan your media library when **Radarr** or **Sonarr** adds something I have created some simple instructions. Repeat these instructions for both **Radarr** and **Sonarr**.

1. Go to your ***Arr** app on port `7878`/`8989` of the `arr` **Proxmox LXC**'s IP (if `vmbr0` is attached/enabled).

2. Go to `Settings` -> `Connect`.

3. Add a connection and select **Emby / Jellyfin**.

4. Enable the triggers (radarr/sonarr):  
  
    **Radarr**:  
    - On File Import
    - On File Upgrade
    - On Rename
    - On Movie Delete
    - On Movie File Delete
    - On Movie File Delete For Upgrade
    - On Application Update
  
    **Sonarr**:  
    - On File Import
    - On File Upgrade
    - On Import Complete
    - On Rename
    - On Series Delete
    - On Episode File Delete
    - On Episode File Delete For Upgrade
    - On Application Update

5. Set the host IP to `172.20.101.10` as defined in [this table](./../README.md#Deployments).

6. Go to **Jellyfin** on port `8096` of your **Proxmox LXC**'s IP (if `vmbr0` is attached/enabled).

7. Go to `Dashboard` -> `API Keys` and create a key for your ***arr app**. 

8. Paste the key in the **API Key** field.

9. Enable **Update Library**.

10. **Save**!

## Debugging

If you have any issues setting up `media` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.

## Extra 

To update a compose stack's images just run:
```
docker compose down
docker compose pull
docker compose up -d
docker image prune
```
In the stack's directory

To remove all docker containers and their remains run:

> [!CAUTION]
> This action is irreversible and will delete docker containers and networks.

```
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker network prune
```
To also delete cached images run:
```
docker image prune
```
