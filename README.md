# *Arr Stack

An *arr stack is collection of services that automate the management of personal media, this branch contains the instructions for installing all services on a **Proxmox VM** with **Docker**.
These instructions are heavily inspired by [this youtube video](https://www.youtube.com/watch?v=twJDyoj0tDc) and [this guide](https://wiki.servarr.com/docker-guide). For more details look at those instructions, since this is my personal setup.

## Preview

![preview image]()

## Installation

1. From the **Proxmox** Node's shell install a **Docker VM** as a **Proxmox VM** using the [community script](https://community-scripts.github.io/ProxmoxVE/scripts?id=docker-vm).

2. Now we need to pass through our network share where we will store the movies, series & more.. To start we need to install some dependencies:
    ```
    apt install cifs-utils smbclient
    ```

3. Now we need to store our credentials in `/root/.smbcred` so we can use them when mounting:
    ```
    nano /root/.smbcred
    ```
    And paste:
    ```
    username=<YOUR USERNAME FOR SMB>
    password=<YOUR PASSWORD FOR SMB>
    ```

4. Before we can mount the network share we need to know which user on the host to give the permissions to. Check your `PUID` and `PGID` with the following command *(your user is probably `root`)*:
    ```
    id <YOUR USER>
    ```

5. To make the mount persistent we need to modify `/etc/fstab`:
    ```
    nano /etc/fstab
    ```
    And paste this *(Replace the IP and SMB share name)*:
    ```
    //<IP ADDRESS>/<SHARENAME> /mnt/nas cifs credentials=/root/.smbcred,uid=<YOUR UID>,gid=<YOUR GID>,file_mode=0777,dir_mode=0777,vers=3.0
    ```

    TODO: ME UID GID instructions

6. Before we can actually mount it we need to actually create the `/mnt/nas` folder.
    ```
    mkdir /mnt/nas
    ```
    Now we can mount:
    ```
    mount -a
    ```

7. Now we can actually start setting up the docker stack. We first need to create a nice place to work in:
    ```
    mkdir -p /docker/arrstack
    ```

8. To create the docker stack we use our premade [compose file](https://github.com/Ggjorven/homelab/blob/arrstack/compose.yaml). But before we can do so we need to install `wget`.
    ```
    apt install wget
    ```
    Now we can run:
    ```
    cd /docker/arrstack
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/arrstack/compose.yaml
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/arrstack/.env
    ```

9. Now modify your `.env` file to reflect your actual `username` and `password`.
    ```
    nano .env
    ```

9. Also make sure the `PUID` and `PGID` are set to your actual IDs in `.env` you can check this with this command *(your user is probably `root`)*:
    ```
    id <YOUR USER>
    ```
    If you run into errors also check [this](https://github.com/TechHutTV/homelab/tree/main/media#user-permissions).

10. We are now finally ready to start our docker stack.
    ```
    docker compose up -d
    ```

11. Once everything was pulled and everything started properly and `gluetun` is healthy we can start configuring.

## Configuring 

### QBitTorrent

1. First login to QBitTorrent using the password from `docker logs qbittorrent`, then go to the settings and `WebUI` and change the `username` and `password` to something you can remember.

2. Secondly we need to change the `network interface` in `Advanced` to `tun0`.

3. Lastly we need to our directories under `downloads`.
    - Set `Default Save Path` to a path in your NAS.
    - Do the same for `Keep incomplete torrents`
    - And `Copy .torrent files`

### NZBGet

TODO:

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- [Docker](https://github.com/Ggjorven) - Container ecosystem
- [Guide](https://github.com/TechHutTV/homelab/tree/main/media) - *Arr stack guide by [TechHutTV](https://github.com/TechHutTV).
