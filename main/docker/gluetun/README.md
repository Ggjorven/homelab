# Gluetun

**Gluetun** is a VPN Container for my **Docker Compose** stacks, this branch contains the installation instructions for installing **Gluetun** using **Docker Compose**.

## Prerequisites

Before we can create our `*arr stack` on our `docker` **Proxmox LXC**. We must have finished these steps:

- [`docker`](https://github.com/Ggjorven/homelab/tree/main/docker/README.md)

## Installation

1. Go to your users `home` directory and go to your dedicated docker directory and create a new directory for `gluetun`:
    ```
    cd ~
    cd docker
    mkdir -p gluetun
    cd gluetun
    ```

2. Retrieve the compose file and .env file:
    ```
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/gluetun/compose.yaml 
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/gluetun/.env
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

5. Now we must change our credentials under:
    ```
    OPENVPN_USER=username
    OPENVPN_PASSWORD=password
    ```
    To reflect your actual PIA login details.

6. We are now ready to start our docker stack.
    ```
    docker compose up -d
    ```

## Start on boot-up

To make `gluetun` start-up on boot we can set up a **systemd** service. I have created a compose-boot service for this purpose.  

1. First make sure we have a folder for our script:
    ```
    mkdir -p /lxc/scripts
    cd /lxc/scripts
    ```

2. Now download my compose-boot script (if you have already downloaded it before, you can skip this):
    ```
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/scripts/compose-boot.sh
    chmod +x compose-boot.sh
    ```

3. Modify this script.
    ```
    nano compose-boot.sh
    ```
    Either add a `docker compose up -d` for your new stack or replace the existing one.  
    Modify `<username>` to reflect your linux user's username.
    ```
    cd /home/<username>/docker/gluetun
    docker compose up -d
    ```
    Eventually this script will contain all the stacks that need to start on start-up.

4. If you have already set up the **systemd** service you can skip the next steps. But now we need to create a **systemd** service to run this script on start-up.
    ```
    cd /etc/systemd/system
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/services/compose-boot.service
    ```

5. Modify the **systemd** service:
    ```
    nano compose-boot.service
    ```
    And change `User` and `Group` to reflect your linux user's username:
    ```
    User=<username>
    Group=<username>
    ```

6. Now enable this service:
    ```
    systemctl daemon-reload
    systemctl enable compose-boot
    systemctl start compose-boot
    ```

## References

- [Docker](https://www.docker.com/) - Hardware accelerated containers
- [Gluetun](https://gluetun.com/) - VPN Container
