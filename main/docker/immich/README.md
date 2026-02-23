# Immich

**Immich** is a photo and video backup solution, this branch contains the installation instructions for installing **Immich** using **Docker Compose**.

## Installation

1. Go to your users `home` directory and go to your dedicated docker directory and create a new directory for `gluetun`:
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

5. Modify `PUID` to reflect your `uid` and `PGID` to reflect `gid`.

6. Modify // TODO: Upload location & Postgres credentials

7. We are now ready to start our docker stack.
    ```
    docker compose up -d
    ```

## Configuration

## Immich

// TODO: ...
## References

- [Docker](https://www.docker.com/) - Hardware accelerated containers 
- [Immich](https://immich.app/) - Photo and video backup solution
