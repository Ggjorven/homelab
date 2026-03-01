# Download Stack

The download stack is collection of services that automate downloading of certain files, this branch contains the instructions for installing all services on a **Proxmox VM** with **Docker**.

## Prerequisites

Before we can create our `*arr stack` on our `docker` **Proxmox LXC**. We must have finished these steps:

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

5. We are now ready to start our docker stack.
    ```
    docker compose up -d
    ```

## Configuring 

### QBitTorrent

To configure **QBitTorrent** you need to go port `8080` of the ip address of the **Proxmox LXC**.

1. First login to QBitTorrent using `username` and `password` from:
    ```
    docker logs qbittorrent
    ```

2. Then go to the settings and `WebUI` and change the `username` and `password` to something you can remember.

3. Secondly we need to change the `network interface` in `Advanced` to `tun0`.

4. Thirdly we need to our directories under `Downloads`.
    - Set `Default Save Path` to a path in your NAS.
    - Do the same for `Keep incomplete torrents`
    - And `Copy .torrent files`

5. Since we are gonna be good torrenter we'll be seeding after downloading, but we don't want to give up all our bandwith. So under **Speed** under **Global Rate Limits** set your **Upload** to something you want. I have `5000 KiB/s`.

6. Also we want to allow multiple downloads simultaneously, by default only 3 simultaneous download and 2 simultaneous uploads are allowed. Go to **BitTorrent** and set maximum active downloads to something significantly higher. I kept uploads the same though.

7. (Optional) If you really value every ounce of privacy you can also go to **BitTorrent** and enable `anonymous mode`. Read [this](https://github.com/qbittorrent/qBittorrent/wiki/Anonymous-Mode) for more information. It doesn't do much.

8. (Optional) If you enabled port forwarding in `gluetun` and you wish to use this port as the torrenting port you can install a docker mod for `qbittorrent`. Below are instructions to help with that. Open the compose file:
    ```
    cd ~/docker/downloadstack
    nano compose.yaml
    ```
    And this line under `environment` for `qbittorrent`:
    ```
    - DOCKER_MODS=ghcr.io/techclusterhq/qbt-portchecker:main
    ```
    This adds a docker mod for portchecking to `qbittorrent` If you want multiple mods add a `|` between them like so: `ghcr.io/techclusterhq/qbt-portchecker:main|ghcr.io/vuetorrent/vuetorrent-lsio-mod:latest`.  
    Now also add these lines:
    ```
    - PORTCHECKER_GLUETUN_API_KEY=<APIKEY>
    - PORTCHECKER_SLEEP=120 # The amount of time between port checks
    - PORTCHECKER_KILL_ON_NOT_CONNECTABLE=true # Restart qbittorrent if it can't connect to the port
    ```
    Replace `<APIKEY>` with the API key generated during the `gluetun` instructions.

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

To configure **MeTube** you need to go to port `8081` of the ip address of the **Proxmox LXC**.

1. Change the download folder to a directory of your choosing. Under **Advanced Options**.

2. (Optional) Some platforms require cookies to be able to download videos. This can be done by retrieving cookies from your browser using these extensions:
   - [Export Cookies](https://addons.mozilla.org/en-US/firefox/addon/export-cookies-txt/) for Firefox
   - [Get Cookies](https://chromewebstore.google.com/detail/get-cookiestxt-locally/cclelndahbckbenkjhflpdbgdldlbecc) for Chrome
  
3. Copy the contents of the exported file, likely called `cookies.txt`.

4. Go the **Proxmox LXC**'s shell and go to `downloadstack`:
    ```
    cd ~/docker
    cd downloadstack
    ```

5. Create a folder under `metube` for the cookies:
    ```
    mkdir -p metube/cookies
    ```

6. Create a `cookies.txt` file and paste your contents inside:
    ```
    nano metube/cookies/cookies.txt
    ```

7. Modify the `compose.yaml` file:
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

8. `metube` will now use your cookies which will help bypass some bot checks.

## Start on boot-up

To make `downloadstack` start-up on boot we can set up a **systemd** service. I have created a compose-boot service for this purpose.  

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
    cd /home/<username>/docker/downloadstack
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

## Debugging

If you have any issues setting up `downloadstack` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.

## References

- [Docker](https://github.com/Ggjorven) - Container ecosystem
- [QBitTorrent](https://www.qbittorrent.org/) - Torrenting client
- [NZBGet](https://nzbget.com/) - NZB downloader
- [MeTube](https://github.com/alexta69/metube) - YouTube downloader
