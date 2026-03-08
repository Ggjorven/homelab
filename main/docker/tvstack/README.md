# TV Stack

**TV Stack** is a collection of Live TV streaming tools for streaming my content from any device, this folder contains the installation instructions for installing **Dispatcharr & More** using **Docker Compose**.

## Prerequisites

Before we can create our `tv stack` on our `docker` **Proxmox LXC**. We must have finished these steps:

- [`NVIDIA Driver`](../../../tutorials/proxmox/NVIDIA-DRIVERS-NODE.md)
- [`NVIDIA Driver LXC`](../../../tutorials/proxmox/NVIDIA-DRIVERS-LXC.md)
- [`docker`](../README.md)
- [`networkstack`](../networkstack/README.md)
- [`docker NVIDIA runtime`](../../../tutorials/docker/NVIDIA-RUNTIME.md)

## Installation

1. Go to your users `home` directory and go to your dedicated docker directory and create a new directory for `tvstack`:
    ```
    cd ~
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

#### Plugins

To improve the functionality of **Dispatcharr** I have added some plugins.

##### IPTV Checker

Configuration steps for **IPTV Checker** can be found below:

1. // TODO: ...

Github repo: [IPTV Checker](https://github.com/PiratesIRC/Dispatcharr-IPTV-Checker-Plugin)  
ZIP download: [IPTV Checker](https://github.com/PiratesIRC/Dispatcharr-IPTV-Checker-Plugin/releases/latest/download/iptv_checker.zip)

##### Timeshift

Configuration steps for **Timeshift** can be found below:

1. // TODO: ...

Github repo: [Timeshift](https://github.com/cedric-marcoux/dispatcharr_timeshift)  
ZIP download: [Timeshift](https://github.com/cedric-marcoux/dispatcharr_timeshift/releases/latest/download/dispatcharr_timeshift.zip)

##### Too Many Streams

Configuration steps for **Too Many Streams** can be found below:

1. // TODO: ...

Github repo: [Too Many Streams](https://github.com/JamesWRC/Dispatcharr_Too_Many_Streams)  
ZIP download: [Too Many Streams](https://github.com/JamesWRC/Dispatcharr_Too_Many_Streams/releases/latest/download/too_many_streams.zip)

##### Local Catchup

Configuration steps for **Local Catchup** can be found below:

1. // TODO: ...

Github repo: [Local Catchup](https://github.com/helenclarko/dispatcharr_local_catchup)  
ZIP download: [Local Catchup](https://github.com/helenclarko/dispatcharr_local_catchup/raw/refs/heads/main/dispatcharr_local_catchup.zip)

##### VOD Fix

Configuration steps for **VOD Fix** can be found below:

1. // TODO: ...

Github repo: [VOD Fix](https://github.com/cedric-marcoux/dispatcharr_vod_fix)  
ZIP download: [VOD Fix](https://github.com/cedric-marcoux/dispatcharr_vod_fix/archive/refs/heads/main.zip) (rename to `dispatcharr_vod_fix.zip`)

## Start on boot-up

To make this stack start on the boot-up of the LXC follow [these instructions](../BOOT-UP.md#adding-a-stack).

## Debugging

If you have any issues setting up `tvstack` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.

## References

- [Docker](https://www.docker.com/) - Hardware accelerated containers 
- [Dispatcharr](https://github.com/Dispatcharr/Dispatcharr) - M3U & Xtream Proxy
