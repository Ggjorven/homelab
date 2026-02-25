# Immich

**Immich** is a photo and video backup solution, this branch contains the installation instructions for installing **Immich** using **Docker Compose**.

## Prerequisites

Before we can create our `*arr stack` on our `docker` **Proxmox LXC**. We must have finished these steps:

- [`omv`](https://github.com/Ggjorven/homelab/tree/main/main/omv/README.md) + extras.
- [`NVIDIA Driver`](https://github.com/Ggjorven/homelab/tree/main/tutorials/proxmox/NVIDIA-DRIVERS-NODE.md)
- [`NVIDIA Driver LXC`](https://github.com/Ggjorven/homelab/tree/main/tutorials/proxmox/NVIDIA-DRIVERS-LXC.md)
- [`docker`](https://github.com/Ggjorven/homelab/tree/main/docker/README.md)
- [`gluetun`](https://github.com/Ggjorven/homelab/tree/main/docker/gluetun/README.md)

## Installation

1. Go to your users `home` directory and go to your dedicated docker directory and create a new directory for `immich`:
    ```
    cd ~
    cd docker
    mkdir -p immich
    cd immich
    ```

2. Retrieve the compose file and .env file:
    ```
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/immich/compose.yaml 
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/immich/.env
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
    IMMICH_UPLOAD_LOCATION=/mnt/nas
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

To make `immich` start-up on boot we can set up a **systemd** service. I have created a compose-boot service for this purpose.  

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
    cd /home/<username>/docker/immich
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

## References

- [Docker](https://www.docker.com/) - Hardware accelerated containers 
- [Immich](https://immich.app/) - Photo and video backup solution
