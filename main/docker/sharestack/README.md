# Share Stack

**Share Stack** is a stack focused on sharing & backup utilities like **Immich** & **NextCloud**, this branch contains the installation instructions for installing **Share Stack** using **Docker Compose**.

## Prerequisites

Before we can create `sharestack` on our `docker` **Proxmox LXC**. We must have finished these steps:

- [`omv`](../omv/README.md) + extras.
- [`NVIDIA Driver`](../../../tutorials/proxmox/NVIDIA-DRIVERS-NODE.md)
- [`NVIDIA Driver LXC`](../../../tutorials/proxmox/NVIDIA-DRIVERS-LXC.md)
- [`docker`](../README.md)
- [`networkstack`](../networkstack/README.md)

## Installation

1. Go to your users `home` directory and go to your dedicated docker directory and create a new directory for `sharestack`:
    ```
    cd ~
    cd docker
    mkdir -p sharestack
    cd sharestack
    ```

2. Retrieve the compose file and .env file:
    ```
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/sharestack/compose.yaml 
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/sharestack/.env
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

6. Modify the **immich** upload location where you wish to store your photos and videos.
    ```
    IMMICH_UPLOAD_LOCATION=/mnt/nas/path/to/your/images
    ```

7. Also change your Postgres credentials to something more secure.
    ```
    # Database credentials
    IMMICH_POSTGRES_USER=username
    IMMICH_POSTGRES_PASSWORD=password
    ```

8. We are now ready to start our docker stack.
    ```
    docker compose up -d
    ```

## Configuration

### Immich

// TODO: ...

## Start on boot-up

To make this stack start on the boot-up of the LXC follow [these instructions](../BOOT-UP.md#adding-a-stack).

## Debugging

If you have any issues setting up `sharestack` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.

## References

- [Docker](https://www.docker.com/) - Hardware accelerated containers 
- [Immich](https://immich.app/) - Photo and video backup solution
