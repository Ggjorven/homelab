# Gluetun

**Gluetun** is a VPN Container for my **Docker Compose** stacks, this branch contains the installation instructions for installing **Gluetun** using **Docker Compose**.

## Installation

1. Go to your users `home` directory and go to your dedicated docker directory and create a new directory for `gluetun`:
    ```
    cd docker
    mkdir -p gluetun
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

## Final step

// TODO: Figure out start-up

## References

- [Docker](https://www.docker.com/) - Hardware accelerated containers
- [Gluetun](https://gluetun.com/) - VPN Container
