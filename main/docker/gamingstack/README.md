# Gaming Stack

**Gaming Stack** is a collection of gaming related services, this folder contains the installation instructions for installing these using **Docker Compose**.

## Prerequisites

Before we can create our `gaming stack` on our `docker` **Proxmox LXC**. We must have finished these steps:

- [`docker`](../README.md)
- [`networkstack`](../networkstack/README.md)

## Installation

1. Go to your users `home` directory and go to your dedicated docker directory and create a new directory for `gamingstack`:
    ```
    cd ~
    cd docker
    mkdir -p gamingstack
    cd gamingstack
    ```

2. Retrieve the compose file and .env file:
    ```
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/gamingstack/compose.yaml 
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/gamingstack/.env
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

### // TODO: ...

## Start on boot-up

To make this stack start on the boot-up of the LXC follow [these instructions](../BOOT-UP.md#adding-a-stack).

## Debugging

If you have any issues setting up `tvstack` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.

## References

- [Docker](https://www.docker.com/) - Hardware accelerated containers 
