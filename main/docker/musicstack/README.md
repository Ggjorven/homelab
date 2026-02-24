# Music Stack

**Music Stack** is a collection of Music streaming tools for streaming my music from any device, this branch contains the installation instructions for installing **Navidrome & More** using **Docker Compose**.

## Installation

1. Go to your users `home` directory and go to your dedicated docker directory and create a new directory for `musicstack`:
    ```
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

5. Now open the compose file and modify the path pointing to the music:
    ```
    nano compose.yaml
    ```
    Change this line:
    ```
    - /path/to/your/music/folder:/music:ro
    ```

6. We are now ready to start our docker stack.
    ```
    docker compose up -d
    ```

## Configuration

### Navidrome

To configure **Navidrome** you need to go to port `9191` of the ip address of the **Proxmox LXC**.

1. // TODO: ...

## Final step    

// TODO: Figure out

## References

- [Docker](https://www.docker.com/) - Hardware accelerated containers
- [Navidrome](https://www.navidrome.org/) - Music streaming backend
