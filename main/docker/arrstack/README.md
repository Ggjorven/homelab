# *Arr Stack

An *arr stack is collection of services that automate the management of personal media, this folder contains the instructions for installing all services on a **Proxmox VM** with **Docker**.
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

5. Modify `PUID` to reflect your `uid` and `PGID` to reflect `gid`.

6. Change the `SLSKD_DOWNLOAD_DIRECTORY` to reflect your actual download directory for **Soulseek**, previously also set in `downloadstack`. Something like `/mnt/nas/Users/<USERNAME>/Soulseek/Downloads`.

7. Set `SLSKD_API_KEY` to your created API Key in `downloadstack`.

8. We are now ready to start our docker stack.
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
    - **EZTV** priority = 5, tags = (series)
    - **TorrentGalaxyClone** priority = 6, tags = (movies, series, music)
    - **The Pirate Bay** priority = 7, tags = (movies, series, music)
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

3. Do the same for the *Arr application you're setting up. The IP for the *arr application can also be found in the [compose file](compose.yaml), but I'll list them here as well. **Radarr** = `172.39.0.41` on port `7878`, **Sonarr** = `172.39.0.40` on port `8989` & **Lidarr** = `172.39.0.42` on port `8686`.

4. Give the application the appropriate tag. **Radarr** = `music`, **Sonarr** = `series` & **Lidarr** = `music`.

### Radarr

To configure **Radarr** you need to go to port `7878` of the ip address of the **Proxmox LXC** and setup the authentication *(I use Forms)*.

1. First we're gonna start by importing existing movies.

2. Now go to `Settings` -> `Media Management` and enable `Rename Movies` ans set it to `{Movie Title} ({Release Year})`.

3. To allow **Radarr** to download to download we need to add a download client. Go to `Settings` -> `Download Clients` and add **QBitTorrent**. Set the IP to `172.39.0.10` which is defined in the [compose file](compose.yaml). And set your `Username` and `Password`.

4. If you use any `usenet` indexers you will also need to set up **NZBGet**. Add **NZBGet**. Set the IP to `172.39.0.10` which is defined in the [compose file](https://github.com/Ggjorven/homelab/blob/main/main/docker/arrstack/compose.yaml). And set your `Username` and `Password`.

5. Now we'll need to modify **Quality Profiles**. Go to `Settings` -> `Profiles`

6. Delete:
    - **HD - 720p/1080p**
    - **SD**

7. Now change these profiles titles:
    - **HD-720p** to **720p - HD**
    - **HD-1080p** to **1080p - HD**
    - **Ultra-HD** to **2160p - 4K**

8. Under **2160p - 4K** you can optionally add **1080p** profiles for if **4K** isn't available.

9. Now we'll need to set maximum **Quality** sizes. Go to `Settings` -> `Quality`.

10. The **Min**, **Preferred** and **Max** megabytes per minute are defined below:  
    - **HDTV-720p**: min = `0`, preferred = `20`, max = `30`
    - **WEBDL-720p**: min = `0`, preferred = `20`, max = `30`
    - **WEBRip-720p**: min = `0`, preferred = `20`, max = `30`
    - **Bluray-720p**: min = `0`, preferred = `20`, max = `30`  
    --
    - **HDTV-1080p**: min = `0`, preferred = `25`, max = `55`
    - **WEBDL-1080p**: min = `0`, preferred = `25`, max = `55`
    - **WEBRip-1080p**: min = `0`, preferred = `25`, max = `55`
    - **Bluray-1080p**: min = `0`, preferred = `25`, max = `55`  
    - **Remux-1080p**: min = `0`, preferred = `25`, max = `55`  
    --
    - **HDVTV-2160p**: min = `0`, preferred = `65`, max = `135`
    - **WEBDL-2160p**: min = `0`, preferred = `65`, max = `135`
    - **WEBRip-2160p**: min = `0`, preferred = `65`, max = `135`
    - **Bluray-2160p**: min = `0`, preferred = `65`, max = `135`
    - **Remux-2160p**: min = `0`, preferred = `65`, max = `135`

11. Finally we'll setup notifications. Go to the **Proxmox LXC**'s IP address on port `8070`.

12. Login with the `username` and `password` set in the .env of `monitoringstack` for **Gotify**.

13. Go to `Apps` and **Create an Application**.

14. Copy the token.

15. Now head back to **Radarr**. Go to `Settings` -> `Connect` and **Add Connection**.

16. Select **Gotify**.

17. Enable:
    - **On Grab**
    - **On File Import**
    - **On File Upgrade**
    - **On Movie Added**
    - **On Movie Delete**
    - **On Movie File Delete**
    - **On Movie File Delete For Upgrade**
    - **On Health Issue**
    - **On Health Restored**
    - **On Manual Interaction Required**

18. Set **Gotify Server** to `http://172.39.0.20:81`

19. Now paste the copied token in **App Token**.

20. Enable **Include Movie Poster**. And set **Metadata Links** to **TMDb**. And Save!

### Sonarr

To configure **Sonarr** you need to go to port `8989` of the ip address of the **Proxmox LXC** and setup the authentication *(I use Forms)*.

1. First we're gonna start by importing existing series.

2. Now go to `Settings` -> `Media Management` and enable `Rename Episodes` ans set:
   - **Standard Episode Format** to `{Series Title} - S{season:00}E{episode:00} - {Episode Title}`
   - **Daily Episode Format** to `{Series Title} - {Air-Date} - {Episode Title}`
   - **Anime Episode Format** to `{Series Title} - S{season:00}E{episode:00} - {Episode Title}`

3. To allow **Sonarr** to download to download we need to add a download client. Go to `Settings` -> `Download Clients` and add **QBitTorrent**. Set the IP to `172.39.0.10` which is defined in the [compose file](../networkstack/compose.yaml). And set your `Username` and `Password`.

4. If you use any `usenet` indexers you will also need to set up **NZBGet**. Add **NZBGet**. Set the IP to `172.39.0.10` which is defined in the [compose file](../networkstack/compose.yaml). And set your `Username` and `Password`.

5. Now we'll need to modify **Quality Profiles**. Go to `Settings` -> `Profiles`

6. Delete:
    - **HD - 720p/1080p**
    - **SD**

7. Now change these profiles titles:
    - **HD-720p** to **720p - HD**
    - **HD-1080p** to **1080p - HD**
    - **Ultra-HD** to **2160p - 4K**

8. Under **2160p - 4K** you can optionally add **1080p** profiles for if **4K** isn't available.

9. Now we'll need to set maximum **Quality** sizes. Go to `Settings` -> `Quality`.

10. The **Min**, **Preferred** and **Max** megabytes per minute are defined below:  
    - **HDTV-720p**: min = `0`, preferred = `20`, max = `30`
    - **WEBDL-720p**: min = `0`, preferred = `20`, max = `30`
    - **WEBRip-720p**: min = `0`, preferred = `20`, max = `30`
    - **Bluray-720p**: min = `0`, preferred = `20`, max = `30`  
    --
    - **HDTV-1080p**: min = `0`, preferred = `25`, max = `55`
    - **WEBDL-1080p**: min = `0`, preferred = `25`, max = `55`
    - **WEBRip-1080p**: min = `0`, preferred = `25`, max = `55`
    - **Bluray-1080p**: min = `0`, preferred = `25`, max = `55`  
    - **Remux-1080p**: min = `0`, preferred = `25`, max = `55`  
    --
    - **HDVTV-2160p**: min = `0`, preferred = `65`, max = `135`
    - **WEBDL-2160p**: min = `0`, preferred = `65`, max = `135`
    - **WEBRip-2160p**: min = `0`, preferred = `65`, max = `135`
    - **Bluray-2160p**: min = `0`, preferred = `65`, max = `135`
    - **Remux-2160p**: min = `0`, preferred = `65`, max = `135`

11. Finally we'll setup notifications. Go to the **Proxmox LXC**'s IP address on port `8070`.

12. Login with the `username` and `password` set in the .env of `monitoringstack` for **Gotify**.

13. Go to `Apps` and **Create an Application**.

14. Copy the token.

15. Now head back to **Sonarr**. Go to `Settings` -> `Connect` and **Add Connection**.

16. Select **Gotify**.

17. Enable:
    - **On Grab**
    - **On File Import**
    - **On File Upgrade**
    - **On Series Add**
    - **On Series Delete**
    - **On Episode File Delete**
    - **On Episode File Delete For Upgrade**
    - **On Health Issue**
    - **On Health Restored**
    - **On Manual Interaction Required**

18. Set **Gotify Server** to `http://172.39.0.20:81`

19. Now paste the copied token in **App Token**.

20. Enable **Include Series Poster**. And set **Metadata Links** to **TVDb**. And Save!

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
- Soundtrack
- Live
- Demo
- Compilation

6. Under **Release Statuses** enable:
- Official

7. To automatically add metadata go to `Settings` -> `Metadata`. Set **Tag Audio Files with Metadata** to **All files; initial import only**.

8. Enable both **Embed Covert Art In Audio Files** and **Scrub Existing Tags** too.

9. To allow **Lidarr** to download to download we need to add a download client. Go to `Settings` -> `Download Clients` and add **QBitTorrent**. Set the IP to `172.39.0.10` which is defined in the [compose file](../networkstack/compose.yaml). And set your `Username` and `Password`.

10. If you use any `usenet` indexers you will also need to set up **NZBGet**. Add **NZBGet**. Set the IP to `172.39.0.10` which is defined in the [compose file](../networkstack/compose.yaml). And set your `Username` and `Password`.

11. Finally we'll setup notifications. Go to the **Proxmox LXC**'s IP address on port `8070`.

12. Login with the `username` and `password` set in the .env of `monitoringstack` for **Gotify**.

13. Go to `Apps` and **Create an Application**.

14. Copy the token.

15. Now head back to **Sonarr**. Go to `Settings` -> `Connect` and **Add Connection**.

16. Select **Gotify**.

17. Enable:
    - **On Grab**
    - **On Release Import**
    - **On Upgrade**
    - **On Download Failure**
    - **On Import Failure**
    - **On Artist Add**
    - **On Artist Delete**
    - **On Album Delete**
    - **On Health Issue**
    - **On Health Restored**

18. Set **Gotify Server** to `http://172.39.0.20:81`

19. Now paste the copied token in **App Token**.

20. Enable **Include Artist Poster**. And Save!

### Soularr 

To configure **Soularr** you need to edit a `config.ini` file under `soularr/config.ini`.

1. Download the template file into `soularr`:
    ```
    cd soularr
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/arrstack/config.ini
    ```

2. Modify the `config.ini` file:
    ```
    sudo nano config.ini
    ```

3. Set the `api_key` under `[Lidarr]` to the API key that can be found under **Settings** -> **General** -> **API Key** on the **Proxmox LXC**'s IP on port `8686`.

4. All set! **Soularr** will now download monitored items automatically every 300 seconds using **Soulseek** or on another interval if you changed it.

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

6. Set the `Address` to `172.39.0.40` as defined in the [compose file](compose.yaml)

7. Now open another tab and go to your **Proxmox LXC**'s IP address on port `8989`. Go to `Settings` -> `General` and copy your **API Key**. Now paste it back in the Bazarr field called `API Key`.

8. Hit **Test** and save your changes.

9. Now let's do the same for **Radarr**. Go to `Settings` -> `Radarr`. Enable it.

10. Set the `Address` to `172.39.0.41` as defined in the [compose file](compose.yaml)

11. Now open another tab and go to your **Proxmox LXC**'s IP address on port `7878`. Go to `Settings` -> `General` and copy your **API Key**. Now paste it back in the Bazarr field called `API Key`.

12. Finally hit **Test** and save your changes.

### AutoSubSync

To configure **AutoSubSync** you need to go to port `6080` of the ip address of the **Proxmox LXC**.

1. // TODO: ...

## Start on boot-up

To make this stack start on the boot-up of the LXC follow [these instructions](../BOOT-UP.md#adding-a-stack).

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

We need to modify the script:
```
sudo nano test-indexers.sh
```
And replace all these values:
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
- [Soularr](https://github.com/mrusse/soularr) - Interface between Lidarr and Slskd
- [Slskd](https://github.com/slskd/slskd) - Soulseek client
