# TV Stack

**TV Stack** is a collection of Live TV streaming tools for streaming my content from any device, this branch contains the installation instructions for installing **Dispatcharr & More** using **Docker Compose**.

## Prerequisites

Before we can create our `*arr stack` on our `docker` **Proxmox LXC**. We must have finished these steps:

- [`NVIDIA Driver`](https://github.com/Ggjorven/homelab/tree/main/tutorials/proxmox/NVIDIA-DRIVER-NODE.md)
- [`NVIDIA Driver LXC`](https://github.com/Ggjorven/homelab/tree/main/tutorials/proxmox/NVIDIA-DRIVER-LXC.md)
- [`docker`](https://github.com/Ggjorven/homelab/tree/main/docker/README.md)

## Installation

1. Go to your users `home` directory and go to your dedicated docker directory and create a new directory for `tvstack`:
    ```
    cd docker
    mkdir -p tvstack
    cd tvstack
    ```

2. Retrieve the compose file and .env file:
    ```
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/tvstack/compose.yaml 
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/tvstack/.env
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

5. Now open the compose file and modify the path pointing to the music:
    ```
    nano compose.yaml
    ```

6. We are now ready to start our docker stack.
    ```
    docker compose up -d
    ```

## Configuration

### Dispatcharr

To configure **Dispatcharr** you need to go to port `9191` of the ip address of the **Proxmox LXC**.

1. First we'll need to create a new **Stream Profile** for **NVENC**. Go to **Settings** -> **Stream Profiles** and add a new stream profile.

2. Set the name to NVENC and set the command to:
    ```
    ffmpeg
    ```

3. Set the parameters to:
    ```
    -user_agent {userAgent} -hwaccel cuda -i {streamUrl} -c:v h264_nvenc -c:a copy -f mpegts pipe:1
    ```

4. Set the User-Agent to something like **TiviMate**. *Note: Sometimes **Dispatcharr** doesn't allow you to set the profile, that's okay, leave it blank.*

5. Now we need to go to **Settings** -> **Stream Settings**. And set the default stream profile to **NVENC**.

6. Some clients send multiple requests when starting a stream ([kodi](https://github.com/Dispatcharr/Dispatcharr/issues/979)). To prevent the stream from instantly stopping and starting and sometimes even crashing it's recommended to **Settings** -> **Proxy Settings** and set **Channel Shutdown Delay** to something like 1 or 2 seconds.

7. To allow IPTV clients to also stream VODs we need to enable **Xtream Codes** export. Go to **Users** and set the **XC Password** to anything.

8. Now we can use the `http://192.168.xxx.xxx:9191` IP and the `username` and `password` as **Xtream Code** credentials which allows both regular channels and VODs.

## Final step    

// TODO: Figure out

## References

- [Docker](https://www.docker.com/) - Hardware accelerated containers 
- [Dispatcharr](https://github.com/Dispatcharr/Dispatcharr) - M3U & Xtream Proxy
