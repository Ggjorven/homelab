# *Arr Stack

An *arr stack is collection of services that automate the management of personal media, this branch contains the instructions for installing all services on a **Proxmox VM** with **Docker**.
These instructions are heavily inspired by [this youtube video](https://www.youtube.com/watch?v=twJDyoj0tDc) and [this guide](https://wiki.servarr.com/docker-guide). For more details look at those instructions, since this is my personal setup.

## Preparation

Before LXC container can access our SMB share we need to mount it to the root node and pass it through with these steps:
*If you have completed these steps from [jellyfin](https://github.com/Ggjorven/homelab/tree/jellyfin) before you can head straight to **Installation**.*

1. Install the following packages to help with mounting:
    ```
    apt install cifs-utils smbclient
    ```

2. Next we need to setup our credentials for our SMB share. We do this in the file `/root/.smbcred`.
    ```
    nano /root/.smbcred 
    ```

3. Paste in the following content and replace the placeholders with your actual `username` and `password`.
    ```
    username=<YOUR USERNAME FOR SMB>
    password=<YOUR PASSWORD FOR SMB>
    ```

4. Now we just need to make a service that mounts the TrueNAS **SMB Share** when it becomes available. I have also created a service script for this purpose:
    ```
    cd /etc/systemd/system
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/jellyfin/services/mount-smb.service
    mkdir /root/scripts
    cd /root/scripts
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/jellyfin/scripts/mount-smb.sh 
    chmod +x /root/scripts/mount-smb.sh
    ```

5. Edit the `/root/scripts/mount-smb.sh` script and replace the `SERVER_IP` with your NAS's actual IP. 
    ```
    nano /root/scripts/mount-smb.sh
    ```

6. Now make sure your mount point set in the `/root/scripts/mount-smb.sh` actually exists with:
    ```
    mkdir /mnt/nas
    ```

7. Now we need to enable this service with:
    ```
    systemctl daemon-reload
    systemctl enable mount-smb
    systemctl start mount-smb
    ```

8. To check if the mounting script succeeded run:
   ```
   journalctl -xeu mount-smb.service
   ```
   You should see the output from the script saying that the SMB was successfully mounted.

## Installation

1. From the **Proxmox** Node's shell install **Docker** as a **Proxmox LXC** using the [community script](https://community-scripts.github.io/ProxmoxVE/scripts?id=docker).

2. Now go the **Proxmox LXC**'s shell. We can start setting up the docker stack. We first need to create a nice place to work in:
    ```
    mkdir -p /docker
    ```

3. To create the docker stack we use our premade [compose file](https://github.com/Ggjorven/homelab/blob/arrstack/arrstack.yaml). But before we can do so we need to install `wget`.
    ```
    apt install wget
    ```
    Now we can run:
    ```
    cd /docker
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/arrstack/arrstack.yaml
    ```

4. Now modify your `.env` file.
    ```
    nano .env
    ```
    And make sure it contains:
    ```
    # General UID/GIU and Timezone
    TZ=Europe/Amsterdam
    PUID=1000
    PGID=1000
    ```

5. Also make sure the `PUID` and `PGID` are set to your actual IDs in `.env` you can check this with this command *(your user is probably `root`)*:
    ```
    id <YOUR USER>
    ```
    If you run into errors also check [this](https://github.com/TechHutTV/homelab/tree/main/media#user-permissions).

6. We are now finally ready to start our docker stack.
    ```
    docker compose -f gluetun.yaml -f arrstack.yaml up -d
    ```

7. Once everything was pulled and everything started properly and `gluetun` is healthy we can start configuring.

## Configuring 

### QBitTorrent

To configure **QBitTorrent** you need to go port `8080` of the ip address of the **Proxmox LXC**.

1. First login to QBitTorrent using the password from `docker logs qbittorrent`, then go to the settings and `WebUI` and change the `username` and `password` to something you can remember.

2. Secondly we need to change the `network interface` in `Advanced` to `tun0`.

3. Lastly we need to our directories under `downloads`.
    - Set `Default Save Path` to a path in your NAS.
    - Do the same for `Keep incomplete torrents`
    - And `Copy .torrent files`

### NZBGet

To configure **NZBGet** you need to go to port `6789` of the ip address of the **Proxmox LXC**. The first `username` and `password` are `nzbget` and `tegbzn6789` respectively.

1. The first thing you'll want to do is change the `ControlUsername` and `ControlPassword` under `Settings` -> `Security` to something you can remember.

2. Now go to `Settings` -> `Incoming NZBS` and change `AppendCategoryDir` from `Yes` to `No`.

3. And finally under `Settings` -> `Paths` change the directories to your preferred directory.
    - `MainDir` is something like `/downloads`
    - `DestDir` is something like `${MainDir}/completed`
    - `InterDir` is something like `${MainDir}/intermediate`

### Prowlarr

To configure **Prowlarr** you need to go to port `9696` of the ip address of the **Proxmox LXC** and setup the authentication *(I use Forms)*.

1. Now we can start setting up **Prowlarr**. The first we're gonna do is add the Download Clients. Go to `Settings` -> `Download Clients`. Now add **NZBGet**. And set the **Host** to `172.39.0.2` which is set in the [compose file](https://github.com/Ggjorven/homelab/blob/arrstack/arrstack.yaml) under **gluetun**. Set your actual **Username** and **Password** and change the **Default Category** to something like `Movies`.

2. Now we're gonna add **QBitTorrent**. And set the **Host** to `172.39.0.2` which is set in the [compose file](https://github.com/Ggjorven/homelab/blob/arrstack/arrstack.yaml) under **gluetun**. Set your actual **Username** and **Password** and change the **Default Category** to something like `Movies` or keep it default.

3. Now go to `Settings` -> `Indexes` and add an `Index Proxy` and click `FlareSolverr` set it's ip to `172.39.0.2` as set in the [compose file](https://github.com/Ggjorven/homelab/blob/arrstack/arrstack.yaml). And give it the tag `flaresolverr`. 

4. Now you can add indexes in **Prowlarr**. My current setup is (most stolen from [torrentio](https://torrentio.strem.fun/):
    - **1337x** priority = 1, tags = (movies, series, music, flaresolverr)
    - **1337x (backup)** priority = 1, tags = (movies, series, music, flaresolverr)
    - **1337x (backup 2)** priority = 1, tags = (movies, series, music, flaresolverr)
    - **RuTracker.RU** priority = 2, tags = (movies, series, music)
    - **LimeTorrents** priority = 3, tags = (movies, series, music)
    - **BitSearch** priority = 4, tags = (movies, series, music)
    - **EZTV** priority = 25 (default), tags = (series)
    - **ilCorSaRoNeRo** priority = 25 (default), tags = (movies, series, music, flaresolverr)
    - **kickasstorrents.ws** priority = 25 (default), tags = (movies, series, music)
    - **Nyaa.si** priority = 25 (default), tags = (movies, series, music)
    - **The Pirate Bay** priority = 25 (default), tags = (movies, series, music)
    - **showRSS** priority = 25 (default), tags = (series)
    - **SubsPlease** priority = 25 (default), tags = (movies, series)
    - **Tokyo Tokoshan** priority = 25 (default), tags = (series, music)
    - **Torrent9** priority = 25 (default), tags = (movies, series, music, flaresolverr)
    - **TorrentGalaxyClone** priority = 25 (default), tags = (movies, series, music)
    - **YTS** priority = 25 (default), tags = (series)

    Now synchronize.

Make sure to add the proper tags to the indexers and applications you're adding.
Check [this](https://www.reddit.com/r/prowlarr/comments/11egtcn/new_to_prowlarr_and_the_my_indexers_are_not/) and [this](https://wiki.servarr.com/prowlarr/faq). Side note: not all indexers will work with **Radarr* etc...

---

After setting up **Radarr**, **Sonarr** & **Lidarr** come back to these steps. These steps are pretty much the same for all of them so there is only 1 explanation:

1. Go to the application you want to add to **Prowlarr** and go to `Settings` -> `General` and copy your **API Key**.

2. Go back to **Prowlarr** and add an application. Paste in the **API Key** under **API Key**. Set the **Prowlarr** server to your **Prowlarr**'s address. Which most likely is `172.69.0.2` on port `9696` as defined in the [compose file](https://github.com/Ggjorven/homelab/blob/arrstack/arrstack.yaml). 

3. Do the same for the *Arr application you're setting up. The IP for the *arr application can also be found in the [compose file](https://github.com/Ggjorven/homelab/blob/arrstack/arrstack.yaml), but I'll list them here as well. **Radarr** = `172.39.0.4` on port `7878`, **Sonarr** = `172.39.0.3` on port `8989` & **Lidarr** = `172.39.0.5` on port `8686`.

4. Give the application the appropriate tag. **Radarr** = `music`, **Sonarr** = `series` & **Lidarr** = `music`.

### Radarr

To configure **Radarr** you need to go to port `7878` of the ip address of the **Proxmox LXC** and setup the authentication *(I use Forms)*.

1. First we're gonna start by importing existing movies.

2. Now go to `Settings` -> `Media Management` and enable `Rename Movies` ans set it to `{Movie Title} ({Release Year})`.

3. To allow **Radarr** to download to download we need to add a download client. Go to `Settings` -> `Download Clients` and add **QBitTorrent**. Set the IP to `172.39.0.2` which is defined in the [compose file](https://github.com/Ggjorven/homelab/blob/arrstack/arrstack.yaml). And set your `Username` and `Password`.

### Sonarr

To configure **Sonarr** you need to go to port `8989` of the ip address of the **Proxmox LXC** and setup the authentication *(I use Forms)*.

1. First we're gonna start by importing existing series.

2. Now go to `Settings` -> `Media Management` and enable `Rename Episodes` ans set:
   - **Standard Episode Format** to `{Series Title} - S{season:00}E{episode:00} - {Episode Title}`
   - **Daily Episode Format** to `{Series Title} - {Air-Date} - {Episode Title}`
   - **Anime Episode Format** to `{Series Title} - S{season:00}E{episode:00} - {Episode Title}`

3. To allow **Sonarr** to download to download we need to add a download client. Go to `Settings` -> `Download Clients` and add **QBitTorrent**. Set the IP to `172.39.0.2` which is defined in the [compose file](https://github.com/Ggjorven/homelab/blob/arrstack/arrstack.yaml). And set your `Username` and `Password`.

### Lidarr

To configure **Lidarr** you need to go to port `8686` of the ip address of the **Proxmox LXC** and setup the authentication *(I use Forms)*.

1. First we're gonna start by setting the **Root Folder**.

2. Now go to `Settings` -> `Media Management` and enable `Rename Tracks`.
   
3. To allow **Lidarr** to download to download we need to add a download client. Go to `Settings` -> `Download Clients` and add **QBitTorrent**. Set the IP to `172.39.0.2` which is defined in the [compose file](https://github.com/Ggjorven/homelab/blob/arrstack/arrstack.yaml). And set your `Username` and `Password`.

### Bazarr

To configure **Bazarr** you need to go to port `6767` of the ip address of the **Proxmox LXC**.

1. Go to `Settings` -> `Languages` and set **Languages Filter** and add:
   - English
   - Dutch

2. Now we need to add **Language Profiles**. Add:
   - Name = "Nederlands", Tag = "dutch", Languages = (Dutch)
   - Name = "English", Tag = "english", Languages = (English)
   - Name = "Combined", Tag = "english_dutch", Languages = (English, Dutch)
     
3. Now scroll down to the bottom and under **Default Language Profiles For Newly Added Shows** enable **Series** and **Movies**. Set this profile to `Combined`.

4. Now go to `Settings` -> `Providers` and add:
   - **OpenSubtitles.com**
   - ~~**SuperSubtitles**~~
   - ~~**TVSubtitles**~~
   - ~~**YIFY Subtitles**~~

5. Now we're gonna start adding our media management tools like **Sonarr** and **Radarr**. We're gonna start with **Sonarr** under `Settings` -> `Sonarr`. Enable it.

6. Set the `Address` to `172.39.0.3` as defined in the [compose file](https://github.com/Ggjorven/homelab/blob/arrstack/arrstack.yaml)

7. Now open another tab and go to your **Proxmox LXC**'s IP address on port `8989`. Go to `Settings` -> `General` and copy your **API Key**. Now paste it back in the Bazarr field called `API Key`.

8. Hit **Test** and save your changes.

9. Now let's do the same for **Radarr**. Go to `Settings` -> `Radarr`. Enable it.

10. Set the `Address` to `172.39.0.4` as defined in the [compose file](https://github.com/Ggjorven/homelab/blob/arrstack/arrstack.yaml)

11. Now open another tab and go to your **Proxmox LXC**'s IP address on port `7878`. Go to `Settings` -> `General` and copy your **API Key**. Now paste it back in the Bazarr field called `API Key`.

12. Finally hit **Test** and save your changes.

### MeTube

**MeTube** on port `8081` doesn't require any configuration.

## Final step

Finally we need to make it so our ***Arr stack** starts on bootup of the **Proxmox LXC**. For ease of use I have created a **systemctl service** and a **bash script** to help with this. You should have installed these when creating the `gluetun` stack. Now modify the script and add:
```
-f arrstack.yaml
```
to it.
To enable this service we run these commands:
```
systemctl daemon-reload
systemctl enable compose-boot
systemctl start compose-boot
```
Now you're all set.

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- [Docker](https://github.com/Ggjorven) - Container ecosystem
- [Guide](https://github.com/TechHutTV/homelab/tree/main/media) - *Arr stack guide by [TechHutTV](https://github.com/TechHutTV)
- [QBitTorrent](https://www.qbittorrent.org/) - Torrenting client
- [NZBGet](https://nzbget.com/) - NZB downloader
- [Prowlarr](https://prowlarr.com/) - Indexer
- [Radarr](https://radarr.video/) - Movie organizer/manager
- [Sonarr](https://sonarr.tv/) - Series organizer/manager
- [MeTube](https://github.com/alexta69/metube) - YouTube downloader
