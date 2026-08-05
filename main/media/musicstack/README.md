# Music Stack

**Music Stack** is a collection of Music streaming tools for streaming my music from any device, this folder contains the installation instructions for installing **Navidrome & More** using **Docker Compose**.

## Prerequisites

Before we can create our `music stack` on our `docker` **Proxmox LXC**. We must have finished these steps:

- [`omv`](../../omv/README.md) + extras.
- [`docker`](../README.md)
- [`networkstack`](../networkstack/README.md)

## Installation

1. Go to your users `home` directory and go to your dedicated docker directory and create a new directory for `musicstack`:
    ```
    cd ~
    cd docker
    mkdir -p musicstack
    cd musicstack
    ```

2. Retrieve the compose file and .env file:
    ```
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/musicstack/compose.yaml 
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/musicstack/.env
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

5. Now also modify the `MUSIC_FOLDER` to the actual folder containing your music:
    ```
    MUSIC_FOLDER=/mnt/nas/path/to/your/music/folder
    ```

6. Now generate a token to use for scrobbling your music history locally. Set `NAVIDROME_LB_TOKEN` to this token. ([hint](https://randomkeygen.com/jwt-secret))

7. We are now ready to start our docker stack.
    ```
    docker compose up -d
    ```

## Configuration

### Navidrome

To configure **Navidrome** you need to go to port `4533` of the ip address of the **Proxmox LXC**.

1. Go to `Settings` -> `Personal` and enable **Scrobble to ListenBrainz**.

2. Paste the generated token during step 6 in there.

### Metadata Remote

**Metadata Remote** doesn't require any configuration. It can be accessed on port `8338` of the **Proxmox LXC**'s IP address.

### Multi-Scrobbler

To configure **Multi-Scrobbler** you need to go to port `9078` of the ip address of the **Proxmox LXC**.

1. // TODO: ...

## Debugging

If you have any issues setting up `musicstack` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.

## References

- [Docker](https://www.docker.com/) - Hardware accelerated containers
- [Navidrome](https://www.navidrome.org/) - Music streaming backend
