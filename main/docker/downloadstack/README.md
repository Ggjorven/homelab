# Download Stack

The download stack is collection of services that automate downloading of certain files, this folder contains the instructions for installing all services on a **Proxmox VM** with **Docker**.

## Prerequisites

Before we can create our `download stack` on our `docker` **Proxmox LXC**. We must have finished these steps:

- [`omv`](../../omv/README.md) + extras.
- [`docker`](../README.md)
- [`networkstack`](../networkstack/README.md)

## Installation

1. Go to your users `home` directory and go to your dedicated docker directory and create a new directory for `downloadstack`:
    ```
    cd ~
    cd docker
    mkdir -p downloadstack
    cd downloadstack
    ```

2. Retrieve the compose file and .env file:
    ```
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/downloadstack/compose.yaml 
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/downloadstack/.env
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

5. Change the `METUBE_DOWNLOAD_DIRECTORY` to reflect your actual download directory for **MeTube**. Something like `/mnt/nas/Users/<USERNAME>/YT/Downloads`.

6. Change the `SLSKD_DOWNLOAD_DIRECTORY` to reflect your actual download directory for **Slskd**. Something like `/mnt/nas/Users/<USERNAME>/Soulseek/Downloads`.

7. Change the `SLSKD_INCOMPLETE_DIRECTORY` to reflect your actual incomplete directory for **Slskd**. Something like `/mnt/nas/Users/<USERNAME>/Soulseek/Incomplete`.

8. Set a **Soulseek** `username` and `password` under `SOULSEEK_USERNAME`/`SOULSEEK_PASSWORD`, you can choose these at will as long as no one else has that `username`.

9. Create an API key for **slskd** and set it under `SLSKD_API_KEY`. ([hint](https://randomkeygen.com/jwt-secret))

10. We are now ready to start our docker stack.
    ```
    docker compose up -d
    ```

## Configuring 

### QBitTorrent

To configure **QBitTorrent** you need to go port `8080` of the ip address of the **Proxmox LXC**.

1. First login to QBitTorrent using `username` and `password` from this command:
    ```
    docker logs qbittorrent
    ```
    You'll see a message saying that a temporary password has been generated.  
    Your temporary `username` will most likely be `admin` and the password is the one generated.

2. Then go to the settings and `WebUI` and change the `username` and `password` to something you can remember.

3. Secondly we need to change the `network interface` in the setting under `Advanced` to `tun0`.

4. Thirdly we need to set our directories. Go back to setting and then `Downloads`.
    - Set `Default Save Path` to a path in your NAS (ex. `/mnt/nas/QBitTorrent/Downloads`).
    - Set `Keep incomplete torrents` to a path in your NAS (ex. `/mnt/nas/QBitTorrent/Incomplete`)
    - And `Copy .torrent files`  (ex. `/mnt/nas/QBitTorrent/Torrents`)

5. Since we are gonna be a good torrenter we'll be seeding after downloading, but we don't want to give up all our bandwith. So under settings go to **Speed** under **Global Rate Limits** set your **Upload** to something you want. I have `5000 KiB/s`.

6. Also we want to allow multiple downloads simultaneously, by default only 3 simultaneous download and 2 simultaneous uploads are allowed. Go to settings and under **BitTorrent** set maximum active downloads to something significantly higher. I kept the uploads the same though.

7. (Optional) If you really value every ounce of privacy you can also go to settings and then **BitTorrent** and enable `anonymous mode`. Read [this](https://github.com/qbittorrent/qBittorrent/wiki/Anonymous-Mode) for more information. It doesn't do much.

8. (Optional) If you enabled port forwarding in `gluetun` and you wish to use this port as the torrenting port you can install a docker mod for `qbittorrent`. Below are instructions to help with that. Open the .env file:
    ```
    cd ~/docker/downloadstack
    nano .env
    ```
    Uncomment:
    ```
    DOCKER_MODS=ghcr.io/techclusterhq/qbt-portchecker:main
    ```
    And uncomment + modify `<APIKEY>` to the one created in `networkstack` for `gluetun`:
    ```
    PORTCHECKER_GLUETUN_API_KEY=<APIKEY>
    ```

9. Before we restart and make this work go to the **Proxmox LXC**'s IP address on port `8080`. Navigate to settings and then **WebUI**. Make sure to enable `Bypass authentication for clients on localhost`. To make all previous steps actually able to function.

### NZBGet

To configure **NZBGet** you need to go to port `6789` of the ip address of the **Proxmox LXC**. The first `username` and `password` are `nzbget` and `tegbzn6789` respectively.

1. The first thing you'll want to do is change the `ControlUsername` and `ControlPassword` under `Settings` -> `Security` to something you can remember.

2. Now go to `Settings` -> `Incoming NZBS` and change `AppendCategoryDir` from `Yes` to `No`.

3. And finally under `Settings` -> `Paths` change the directories to your preferred directory.
    - `MainDir` is something like `/downloads`
    - `DestDir` is something like `${MainDir}/completed`
    - `InterDir` is something like `${MainDir}/intermediate`

### MeTube

MeTube doesn't require any configuration for this current setup.  
**MeTube** can be found on port `8081` of your **Proxmox LXC**'s IP address.  
If you have any issues with downloading some sites require cookies, the instructions for these are below:

1. (Optional) Some platforms require cookies to be able to download videos. This can be done by retrieving cookies from your browser using these extensions:
   - [Export Cookies](https://addons.mozilla.org/en-US/firefox/addon/export-cookies-txt/) for Firefox
   - [Get Cookies](https://chromewebstore.google.com/detail/get-cookiestxt-locally/cclelndahbckbenkjhflpdbgdldlbecc) for Chrome
  
2. Copy the contents of the exported file, likely called `cookies.txt`.

3. Go the **Proxmox LXC**'s shell and go to `downloadstack`:
    ```
    cd ~/docker
    cd downloadstack
    ```

4. Create a folder under `metube` for the cookies:
    ```
    mkdir -p metube/cookies
    ```

5. Create a `cookies.txt` file and paste your contents inside:
    ```
    nano metube/cookies/cookies.txt
    ```

6. Modify the `compose.yaml` file:
    ```
    nano compose.yaml
    ```
    And add this line under `volumes`:
    ```
    - ./metube/cookies:/cookies
    ```
    Now we need to tell yt-dlp to use these cookies, so under `environment` add:
    ```
    - YTDL_OPTIONS={"cookiefile":"/cookies/cookies.txt"}
    ```

7. `metube` will now use your cookies which will help bypass some bot checks.

### Slskd

**Slskd** currently doesn't require any more configuration.  
**Slskd** can be accessed on port `5030` of your **Proxmox LXC**'s IP address.

## Start on boot-up

To make this stack start on the boot-up of the LXC follow [these instructions](../BOOT-UP.md#adding-a-stack).


## Debugging

If you have any issues setting up `downloadstack` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.

## References

- [Docker](https://github.com/Ggjorven) - Container ecosystem
- [QBitTorrent](https://www.qbittorrent.org/) - Torrenting client
- [NZBGet](https://nzbget.com/) - NZB downloader
- [MeTube](https://github.com/alexta69/metube) - YouTube downloader
