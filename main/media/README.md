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
    ```sh
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct/docker.sh)"
    ```

3. Choose `Advanced Install`. 

4. Choose **Unprivileged**, set a safe root password, set the container ID to `101` (matches with the VLAN) and set the hostname to `media` (or something else).

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

15. (optional) Personally I like to have **Container protection** enabled to avoid accidental deletion.

16. Set **Allow device node creation** to No and leave **Filesystem mounts** empty. Same for the **Post-install hook**.

17. (optional) If you want verbose output during installation enable it. (I like it)

18. Confirm the settings and wait... (If you're asked to update the defaults just hit Cancel)

19. When it asks you to install **Portainer** select **N**. Same for the **Portainer Agent**.

20. Also don't expose the **Docker TCP Socket**, so **N**.

21. Now that the container is installed go to the **LXC** in the WebUI and go to **Network**.

22. Double click on `net0`/`eth0`/`vmbr1` and disable the **Firewall**, since we'll be setting up our own firewall rules.

23. For debugging I also like to **Add** another **Network Device**. 

24. Set the **Name** to `eth1`. Set the **Bridge** to `vmbr0` and disable the **Firewall**.

25. Set **IPv4** to **DHCP** (since it's only for debugging) and set **IPv6** to **Static** and leave it empty. **Add**!

26. We also want the **LXC** to boot properly on startup, go to **Options** tab and set **Start/Shutdown order** to `2`. 

27. We also want to give the **LXC** access to our `media` dataset from [truenas](./../truenas/README.md), so open the **Proxmox Node**'s **Shell**.

28. Edit the **LXC**'s config file:
    ```sh
    nano /etc/pve/lxc/101.conf
    ```
    Where `101` is the container ID (CTID) or LXC ID.

29. Pass through the `/mnt/media` mountpoint by pasting:
    ```
    mp0: /mnt/media,mp=/mnt/media
    ```

30. Now reboot the **LXC**.

31. Go to **LXC**'s **Shell** and login with `root` and the password you set in the installation.

32. Install the same NVIDIA drivers on the **LXC** as on the **Proxmox Node** with [this tutorial](./../../tutorials/proxmox/NVIDIA-DRIVERS-LXC.md).

33. Create a `media` group and user in the LXC using:
    ```sh
    groupadd -g 1000 media
    useradd -u 1000 -g 1000 -m -s /bin/bash media
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
    BRANCH=main
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/.env"
    ```

38. Create the `networking` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/networking
    cd ~/networking
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/networking/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/networking/compose.yaml"
    ```

39. Create the `monitoring` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/monitoring
    cd ~/monitoring
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/monitoring/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/monitoring/compose.yaml"
    ```

40. Create the `jellyfin` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/jellyfin
    cd ~/jellyfin
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/jellyfin/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/jellyfin/compose.yaml"
    ```

41. Create the `seerr` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/seerr
    cd ~/seerr
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/seerr/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/seerr/compose.yaml"
    ```

42. Create the `navidrome` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/navidrome
    cd ~/navidrome
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/navidrome/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/navidrome/compose.yaml"
    ```

43. Create the `droppedneedle` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/droppedneedle
    cd ~/droppedneedle
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/droppedneedle/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/droppedneedle/compose.yaml"
    ```

44. Create the `bookorbit` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/bookorbit
    cd ~/bookorbit
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/bookorbit/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/bookorbit/compose.yaml"
    ```

45. Get the `up` and `down` scripts:
    ```sh
    BRANCH=main
    sudo mkdir -p /lxc/scripts
    cd /lxc/scripts
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/scripts/up-networking.sh"
    sudo chmod +x up-networking.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/scripts/up-monitoring.sh"
    sudo chmod +x up-monitoring.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/scripts/up-jellyfin.sh"
    sudo chmod +x up-jellyfin.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/scripts/up-seerr.sh"
    sudo chmod +x up-seerr.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/scripts/up-navidrome.sh"
    sudo chmod +x up-navidrome.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/scripts/up-droppedneedle.sh"
    sudo chmod +x up-droppedneedle.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/scripts/up-bookorbit.sh"
    sudo chmod +x up-bookorbit.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/scripts/down-networking.sh"
    sudo chmod +x down-networking.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/scripts/down-monitoring.sh"
    sudo chmod +x down-monitoring.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/scripts/down-jellyfin.sh"
    sudo chmod +x down-jellyfin.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/scripts/down-seerr.sh"
    sudo chmod +x down-seerr.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/scripts/down-navidrome.sh"
    sudo chmod +x down-navidrome.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/scripts/down-droppedneedle.sh"
    sudo chmod +x down-droppedneedle.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/scripts/down-bookorbit.sh"
    sudo chmod +x down-bookorbit.sh
    ```

46. Also get the `compose-boot`, `compose-shutdown` and `compose-restart` scripts and services:
    ```sh
    BRANCH=main
    sudo mkdir -p /lxc/scripts
    cd /lxc/scripts
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/scripts/compose-boot.sh"
    sudo chmod +x compose-boot.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/scripts/compose-shutdown.sh"
    sudo chmod +x compose-shutdown.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/scripts/compose-restart.sh"
    sudo chmod +x compose-restart.sh
    cd /etc/systemd/system
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/services/compose-boot.service"
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media/services/compose-shutdown.service"
    ```

47. Enable the `systemctl` for `compose-boot` and `compose-shutdown`:
    ```sh
    sudo systemctl daemon-reload
    sudo systemctl enable compose-boot
    sudo systemctl enable compose-shutdown
    ```

48. Now start the `networking` and `monitoring` stacks:
    ```sh
    sudo /lxc/scripts/up-networking.sh
    sudo /lxc/scripts/up-monitoring.sh
    ```
    You can now start configuring individual stacks listed below.

## Configuration

### Jellyfin

// TODO: Make instructions linear with just plugin sections

First we'll start by configuring via the `.env` file.

1. Open the `.env`:
    ```sh
    cd ~/jellyfin
    nano .env
    ```
    Set `MOVIES_FOLDER` to the actual movies directory, I use `/mnt/media/films`.  
    Do the same for `SERIES_FOLDER`, I use `/mnt/media/series`.

2. Make sure the folders actually exist:
    ```sh
    mkdir -p /mnt/media/films
    mkdir -p /mnt/media/series
    ```

3. You can now start the container:
    ```sh
    sudo /lxc/scripts/up-jellyfin.sh
    ```

Now that the container is running we'll start configuring via the WebUI on port `8096`. This requires either having `vmbr0` still attached or having set up [`priv-net`](./../priv-net/README.md).

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

### Seerr

> ![NOTE]
> This requires having set up the [arr](./../arr/README.md) container

**Seerr** doesn't require any configuring via the `.env` file.  
So just start the container:
```sh
sudo /lxc/scripts/up-seerr.sh
```

Now that the container is running we'll start configuring via the WebUI on port `5055`. This requires either having `vmbr0` still attached or having set up [`priv-net`](./../priv-net/README.md).

1. When in the WebUI select **Jellyfin** as the media server type.

2. Now set the URL of **Jellyfin** to `172.24.1.10`. Leave **URL Base** empty. Set **Email Address** to something random like `invalid@invalid.invalid`. And choose an appropriate **Username** and **Password**.

3. Now **Sync Libraries**. Both **Movies** and **Series** and **Start the scan**.

4. Continue and set up the **Radarr** server. Make it the **Default Server** and set the **Name** to something like "Radarr". 

5. Set the IP address to `172.20.105.10`. 

6. Now open the **Radarr** WebUI on port `7878`, this requires either having `vmbr0` still attached or having set up [`priv-net`](./../priv-net/README.md). 

7. Go to **Settings** -> **General** and copy your API key and paste it in the **API Key** field in **Seerr**.

8. Now hit **Test**.

9. Set your desired **Quality Profile** and **Root Folder**, for me `1080p - HD` and `/movies`.

10. Finally enable **Enable Scan** & **Enable Automatic Search** and **Save**.

11. Now set up the **Sonarr** server. Make it the **Default Server** and set the **Name** to something like "Sonarr". 

12. Set the IP address to `172.20.105.10`. 

13. Now open the **Sonarr** WebUI on port `8989`, this requires either having `vmbr0` still attached or having set up [`priv-net`](./../priv-net/README.md). 

14. Go to **Settings** -> **General** and copy your API key and paste it in the **API Key** field in **Seerr**.

15. Now hit **Test**.

16. Set your desired **Quality Profile** and **Root Folder**, for me `1080p - HD` and `/tv`.

17. Finally enable **Enable Scan** & **Enable Automatic Search** and **Save**.

18. And finish your setup!

19. Now go to **Settings** -> **Users** and under **Default Permissions** enable:
    - **Advanced Requests** (for quality selection)
    - **Auto-Approve** (for auto approving requests)
    And scroll to the bottom and **Save**!

20. Go to **Settings** -> **Network** and enable **Enable Proxy Support** and **Save**!

21. Now go to **Settings** -> **General** and scroll down to **Blocklist Content with Tags**.

22. Now open [this file](https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/dev/main/docker/mediastack/seerr_blocklist.txt) and copy it's contents.

23. Back in the WebUI hit the import arrow next to **Blocklist Content with Tags** and paste the file contents and **Save**!

24. The last step is to go to the **Users** tab and hit **Import Jellyfin Users** and import the users.

25. To apply some of the changes you might need to restart **Seerr**:
    ```sh
    docker restart seerr
    ```

---

// TODO: Gotify notifications after monitoring

### Navidrome

// TODO: ...

### DroppedNeedle

// TODO: ...

### BookOrbit

First we'll start by configuring via the `.env` file.

1. Open the `.env`:
    ```sh
    nano ~/bookorbit/.env
    ```
    Change `EBOOKS_FOLDER` to your ebooks folder, I use `/mnt/media/books/ebooks`.  
    Change `AUDIOBOOKS_FOLDER` to your audiobooks folder, I use `/mnt/media/books/audiobooks`.

2. Change `APP_URL` to either your reverse proxy's url like `https://bookorbit.local.mydomain.com` or set it to `http://vmbr0-ip:3131` where `vmbr0-ip` is the LAN ip of the LXC (you can query it with `ip a`).

3. For security we'll need to generate some random keys, generate them from [here](https://randomkeygen.com/jwt-secret) or another 16 to 255 character generator. Now set a unique key for both `APP_SECRET` and `APP_SETUP_SECRET` in the `.env` file.

4. Finally we'll set a secure password for `DATABASE_PASSWORD`.

5. Now make sure the book folders actually exist:
    ```sh
    mkdir -p /mnt/media/books/ebooks
    mkdir -p /mnt/media/books/audiobooks
    ```

6. You can now start the container:
    ```sh
    sudo /lxc/scripts/up-bookorbit.sh
    ```

Now that the container is running we'll start configuring via the WebUI on port `3131`. This requires either having `vmbr0` still attached or having set up [`priv-net`](./../priv-net/README.md).

1. Set **Username** to an appropriate name as well as set **Full Name** to that name.

2. Set **Email** to `invalid@invalid.invalid`.

3. Set a safe **Password** and confirm it.

4. Copy the `APP_SETUP_SECRET` from the `.env`:
    ```sh
    cat ~/bookorbit/.env
    ```

5. Now back in the WebUI paste it under **Setup token**.

6. Now create an "Ebooks" library and an "Audiobooks" library with `/books/ebooks` and `/books/audiobooks` respectively using the following instructions:
    1. On the **Dashboard** look for **Libraries** in the left sidebar and hit the plus.
    2. Name your library to "Ebooks" or "Audiobooks" depending on the one you are making.
    3. Now **Browse server folders** and select `/books/ebooks` for the "Ebooks" library and `/book/audiobooks" for the "Audiobooks" folder and **Continue**.
    4. For scan mode select **Folder as Book** and **Continue**.
    5. For source precedence set the following order:
        - **Embedded metadata**
        - **OPF files**

        And keep the format priority and **Continue**.
    6. Now set the percentages:
        - Set **Reading Start** to `0.25%`.
        - Set **Mark as Finished** to `98%`

        And **Continue**.
    7. Enable **Watch Folders** and set the **Auto-scan Schedule** to **Custom** and input: `0 */2 * * *` which is every 2 hours. **Continue**!
    8. Enable **Rename files after metadata changes** and **Write metadata to files** and **Continue**!

7. Now go to the **Settings** in the top right.

8. Go to the **Metadata** tab and go to the **Books** tab. Here enable:
    - **Enable auto-fetch**
    - **Trigger on import**

    And **Save**!

9. Now go to the **Authors** tab under **Metadata**. Here enable:
    - **Enable auto author enrichment**
    - **Trigger on import**

10. For the **Eligibility conditions** enable:
    - **Never enriched**
    - **Missing bio**
    - **Missing photo**

    And **Save**!

11. (optional) Now go to the **Providers** tab under **Metadata**.

12. (optional) Create a **Hardcover** account ([from here](https://hardcover.app/)).

13. (optional) In **Hardcover** under **Settings** go to **Hardcover API**.

14. (optional) Click **New API Key** and **Name** it "BookOrbit" and set the **Expiration** to **Never**. Set **Permissions** to **All** and **Create Key**. Now **Copy** the key.

15. (optional) Paste the API key into the **Hardcover** field back in the **BookOrbit** WebUI, hit **Test** and enable **Hardcover** as a provider. Scroll up and **Save Changes**.

16. To create more users go to the **Admin** tab and hit **Create user**.

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
