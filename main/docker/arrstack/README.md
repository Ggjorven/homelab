# *Arr Stack

An *arr stack is collection of services that automate the management of personal media, this branch contains the instructions for installing all services on a **Proxmox VM** with **Docker**.
These instructions are heavily inspired by [this youtube video](https://www.youtube.com/watch?v=twJDyoj0tDc) and [this guide](https://wiki.servarr.com/docker-guide). For more details look at those instructions, since this is my personal setup.

## Prerequisites

Before we can create our `*arr stack` on our `docker` **Proxmox LXC**. We must have finished these steps:

- [`omv`](../../omv/README.md) + extras.
- [`docker`](../README.md)
- [`networkstack`](../networkstack/README.md)
- [`downloadstack`](../downloadstack/README.md)

## Installation

1. Go to your users `home` directory and go to your dedicated docker directory and create a new directory for `arrstack`:
    ```
    cd ~
    cd docker
    mkdir -p arrstack
    cd arrstack
    ```

2. Retrieve the compose file and .env file:
    ```
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/arrstack/compose.yaml 
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/arrstack/.env
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

5. We are now ready to start our docker stack.
    ```
    docker compose up -d
    ```

## Configuring 

### Prowlarr

To configure **Prowlarr** you need to go to port `9696` of the ip address of the **Proxmox LXC** and setup the authentication *(I use Forms)*.

1. Now we can start setting up **Prowlarr**. The first we're gonna do is add the Download Clients. Go to `Settings` -> `Download Clients`. Now add **NZBGet**. And set the **Host** to `172.39.0.10` which is set in the [compose file](../networkstack/compose.yaml) under **gluetun**. Set your actual **Username** and **Password** and change the **Default Category** to something like `Movies`.

2. Now we're gonna add **QBitTorrent**. And set the **Host** to `172.39.0.10` which is set in the [compose file](../networkstack/compose.yaml) under **gluetun**. Set your actual **Username** and **Password** and change the **Default Category** to something like `Movies` or keep it default.

3. Now go to `Settings` -> `Indexers` and add an `Index Proxy` and click `FlareSolverr` set it's ip to `172.39.0.10` as set in the [compose file](../networkstack/compose.yaml). And give it the tag `flaresolverr`. Enable advanced options and set timeout to `180`.

> [!NOTE]
> If flaresolverr still fails to connect checkout my [debugging guide](../networkstack/DEBUGGING.md#flaresolverr-taking-very-long-to-start-chromium) for `networkstack`.

4. Now you can add indexers in **Prowlarr**. My current setup is (most stolen from [torrentio](https://torrentio.strem.fun/):
    - **1337x** priority = 1, tags = (movies, series, music, flaresolverr)
    - **1337x (backup)** priority = 1, tags = (movies, series, music, flaresolverr)
    - **1337x (backup 2)** priority = 1, tags = (movies, series, music, flaresolverr)
    - **RuTracker.RU** priority = 2, tags = (movies, series, music)
    - **LimeTorrents** priority = 3, tags = (movies, series, music, flaresolverr)
    - **BitSearch** priority = 4, tags = (movies, series, music)
    - **BitSearch (backup)** priority = 4, tags = (movies, series, music)
    - **EZTV** priority = 5 (default), tags = (series)
    - **TorrentGalaxyClone** priority = 6 (default), tags = (movies, series, music)
    - **The Pirate Bay** priority = 7 (default), tags = (movies, series, music)
    - **ilCorSaRoNeRo** priority = 25 (default), tags = (movies, series, music, flaresolverr)
    - **kickasstorrents.ws** priority = 25 (default), tags = (movies, series, music, flaresolverr)
    - **MagnetDownload** priority = 25 (default), tags = (movies, series, music)
    - **Magnet Cat** priority = 25 (default), tags = (movies, series, music)
    - **Nyaa.si** priority = 25 (default), tags = (movies, series, music)
    - **NorTorrent** priority = 25 (default), tags = (movies, series, music, flaresolverr)
    - **RuTor** priority = 25 (default), tags = (movies, series, music)
    - **showRSS** priority = 25 (default), tags = (series)
    - **SubsPlease** priority = 25 (default), tags = (movies, series)
    - **Tokyo Tokoshan** priority = 25 (default), tags = (series, music)
    - **Torrent9** priority = 25 (default), tags = (movies, series, music, flaresolverr)
    - **TorrentDownload** priority = 25 (default), tags = (movies, series, music)
    - **Uindex** priority = 25 (default), tags = (movies, series, music)
    - **YTS** priority = 25 (default), tags = (series)

    Now synchronize.

Make sure to add the proper tags to the indexers and applications you're adding.
Check [this](https://www.reddit.com/r/prowlarr/comments/11egtcn/new_to_prowlarr_and_the_my_indexers_are_not/) and [this](https://wiki.servarr.com/prowlarr/faq). Side note: not all indexers will work with **Radarr* etc...

---

After setting up **Radarr**, **Sonarr** & **Lidarr** come back to these steps. These steps are pretty much the same for all of them so there is only 1 explanation:

1. Go to the application you want to add to **Prowlarr** and go to `Settings` -> `General` and copy your **API Key**.

2. Go back to **Prowlarr** and add an application. Paste in the **API Key** under **API Key**. Set the **Prowlarr** server to your **Prowlarr**'s address. Which most likely is `172.39.0.10` on port `9696` as defined in the [compose file](../networkstack/compose.yaml). 

3. Do the same for the *Arr application you're setting up. The IP for the *arr application can also be found in the [compose file](compose.yaml), but I'll list them here as well. **Radarr** = `172.39.0.31` on port `7878`, **Sonarr** = `172.39.0.30` on port `8989` & **Lidarr** = `172.39.0.32` on port `8686`.

4. Give the application the appropriate tag. **Radarr** = `music`, **Sonarr** = `series` & **Lidarr** = `music`.

### Radarr

To configure **Radarr** you need to go to port `7878` of the ip address of the **Proxmox LXC** and setup the authentication *(I use Forms)*.

1. First we're gonna start by importing existing movies.

2. Now go to `Settings` -> `Media Management` and enable `Rename Movies` ans set it to `{Movie Title} ({Release Year})`.

3. To allow **Radarr** to download to download we need to add a download client. Go to `Settings` -> `Download Clients` and add **QBitTorrent**. Set the IP to `172.39.0.10` which is defined in the [compose file](compose.yaml). And set your `Username` and `Password`.

4. If you use any `usenet` indexers you will also need to set up **NZBGet**. Add **NZBGet**. Set the IP to `172.39.0.10` which is defined in the [compose file](https://github.com/Ggjorven/homelab/blob/main/main/docker/arrstack/compose.yaml). And set your `Username` and `Password`.

### Sonarr

To configure **Sonarr** you need to go to port `8989` of the ip address of the **Proxmox LXC** and setup the authentication *(I use Forms)*.

1. First we're gonna start by importing existing series.

2. Now go to `Settings` -> `Media Management` and enable `Rename Episodes` ans set:
   - **Standard Episode Format** to `{Series Title} - S{season:00}E{episode:00} - {Episode Title}`
   - **Daily Episode Format** to `{Series Title} - {Air-Date} - {Episode Title}`
   - **Anime Episode Format** to `{Series Title} - S{season:00}E{episode:00} - {Episode Title}`

3. To allow **Sonarr** to download to download we need to add a download client. Go to `Settings` -> `Download Clients` and add **QBitTorrent**. Set the IP to `172.39.0.10` which is defined in the [compose file](../networkstack/compose.yaml). And set your `Username` and `Password`.

4. If you use any `usenet` indexers you will also need to set up **NZBGet**. Add **NZBGet**. Set the IP to `172.39.0.10` which is defined in the [compose file](../networkstack/compose.yaml). And set your `Username` and `Password`.

### Lidarr

To configure **Lidarr** you need to go to port `8686` of the ip address of the **Proxmox LXC** and setup the authentication *(I use Forms)*.

1. First we're gonna start by setting the **Root Folder**.

2. Now go to `Settings` -> `Media Management` and enable `Rename Tracks`.  
- Set **Standard Track Format** to: `{Artist Name}/{Album Title} ({Release Year})/{track:00} - {Track Title}`
- Set **Multi Disc Track Format** to: `{Artist Name}/{Album Title} ({Release Year})/{Medium Format} {medium:00}/{track:00} - {Track Title}`

3. We also want to modify the **Standard** music profile. Go to `Settings` -> `Profiles` -> `Metadata Profiles` -> `Standard`.

4. Under **Primary Types** enable:
- Album
- Single
- EP

5. Under **Secondary Types** enable:
- Studio
- Live
- Demo
- Compilation

6. Under **Release Statuses** enable:
- Official

7. To allow **Lidarr** to download to download we need to add a download client. Go to `Settings` -> `Download Clients` and add **QBitTorrent**. Set the IP to `172.39.0.10` which is defined in the [compose file](../networkstack/compose.yaml). And set your `Username` and `Password`.

8. If you use any `usenet` indexers you will also need to set up **NZBGet**. Add **NZBGet**. Set the IP to `172.39.0.10` which is defined in the [compose file](../networkstack/compose.yaml). And set your `Username` and `Password`.

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
   - **OpenSubtitles.com** (requires login details from [https://www.opensubtitles.com/](https://www.opensubtitles.com/))
   - **Subdl** (requires **API Key** from [https://subdl.com/](https://subdl.com/))
   - ~~**SuperSubtitles**~~
   - ~~**TVSubtitles**~~
   - ~~**YIFY Subtitles**~~

5. Now we're gonna start adding our media management tools like **Sonarr** and **Radarr**. We're gonna start with **Sonarr** under `Settings` -> `Sonarr`. Enable it.

6. Set the `Address` to `172.39.0.30` as defined in the [compose file](compose.yaml)

7. Now open another tab and go to your **Proxmox LXC**'s IP address on port `8989`. Go to `Settings` -> `General` and copy your **API Key**. Now paste it back in the Bazarr field called `API Key`.

8. Hit **Test** and save your changes.

9. Now let's do the same for **Radarr**. Go to `Settings` -> `Radarr`. Enable it.

10. Set the `Address` to `172.39.0.31` as defined in the [compose file](compose.yaml)

11. Now open another tab and go to your **Proxmox LXC**'s IP address on port `7878`. Go to `Settings` -> `General` and copy your **API Key**. Now paste it back in the Bazarr field called `API Key`.

12. Finally hit **Test** and save your changes.

## Start on boot-up

To make `arrstack` start-up on boot we can set up a **systemd** service. I have created a compose-boot service for this purpose.  

1. First make sure we have a folder for our script:
    ```
    sudo mkdir -p /lxc/scripts
    cd /lxc/scripts
    ```

2. Now download my compose-boot script (if you have already downloaded it before, you can skip this):
    ```
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/scripts/compose-boot.sh
    sudo chmod +x compose-boot.sh
    ```

3. Modify this script.
    ```
    sudo nano compose-boot.sh
    ```
    Either add a `docker compose up -d` for your new stack or replace the existing one.  
    Modify `<username>` to reflect your linux user's username.
    ```
    cd /home/<username>/docker/arrstack
    docker compose up -d
    ```
    Eventually this script will contain all the stacks that need to start on start-up.

4. If you have already set up the **systemd** service you can skip the next steps. But now we need to create a **systemd** service to run this script on start-up.
    ```
    cd /etc/systemd/system
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/services/compose-boot.service
    ```

5. Modify the **systemd** service:
    ```
    sudo nano compose-boot.service
    ```
    And change `User` and `Group` to reflect your linux user's username:
    ```
    User=<username>
    Group=<username>
    ```

6. Now enable this service:
    ```
    sudo systemctl daemon-reload
    sudo systemctl enable compose-boot
    ```

## Extra

I have personally noticed that sometimes even though indexers in **Prowlarr** are available **Prowlarr** doesn't report them properly until you run a **Test All Indexers**.
This can build up over time and cause all indexers to not be reported as available.
To prevent this from happening and requiring manual **Test All Indexers** I have written a **systemctl** service and script to do this using **Prowlarr**, **Radarr**, **Sonarr** & **Lidarr**'s API.

``` 
cd /etc/systemd/system
sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/arrstack/services/test-indexers.service
sudo mkdir -p /lxc/scripts
cd /lxc/scripts
sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/arrstack/scripts/test-indexers.sh
sudo chmod +x test-indexers.sh
```

We need to modify the script and replace all these values:

```
SERVER_IP="192.168.x.x"
PROWLARR_API=""
RADARR_API=""
SONARR_API=""
LIDARR_API=""
```

Replace `SERVER_IP` with the **Proxmox LXC**'s address.
Replace the `XXX_API` with the **API Key**'s that can be found under **General** -> **Settings** for each of these services.

Finally we need to enable this service:
```
sudo systemctl daemon-reload
sudo systemctl enable test-indexers
sudo systemctl start test-indexers
```

## Debugging

If you have any issues setting up `arrstack` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.

## References

- [Docker](https://github.com/Ggjorven) - Container ecosystem
- [Guide](https://github.com/TechHutTV/homelab/tree/main/media) - *Arr stack guide by [TechHutTV](https://github.com/TechHutTV)
- [Prowlarr](https://prowlarr.com/) - Indexer
- [Radarr](https://radarr.video/) - Movie organizer/manager
- [Sonarr](https://sonarr.tv/) - Series organizer/manager
- [Lidarr](https://lidarr.audio/) - Music organizer/manager
