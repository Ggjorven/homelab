# Gluetun

**Gluetun** is a VPN Container for my **Docker Compose** stacks, this branch contains the installation instructions for installing **Gluetun** using **Docker Compose**.

## Installation

1. From the **Proxmox Node**'s shell install a **Docker LXC** using the [community script](https://community-scripts.github.io/ProxmoxVE/scripts?id=docker):
   ```
   bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct/docker.sh)"
   ```

2. To give our **LXC** access to our network share we need to add these lines to `/etc/pve/lxc/<CTID>.conf`:
   ```
   nano /etc/pve/lxc/<CTID>.conf
   ```
   Add:
   ```
   lxc.cgroup2.devices.allow: c 10:200 rwm
   lxc.mount.entry: /dev/net dev/net none bind,create=dir
   lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
   ```
   *Note: Also make sure nesting=1 and keyctl=1 are there.*

3. After a restart your **Docker LXC** should have access to `/dev/net/tun`.

4. Now we can actually start setting up the docker stack. We first need to create a nice place to work in:
    ```
    mkdir -p /docker/gluetun
    ```

5. To create the docker stack we use our premade [compose file](https://github.com/Ggjorven/homelab/blob/gluetun/compose.yaml). But before we can do so we need to install `wget`.
    ```
    apt install wget
    ```
    Now we can run:
    ```
    cd /docker/arrstack
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/gluetun/compose.yaml
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/gluetun/.env
    ```

6. Now modify your `.env` file to reflect your actual `username` and `password`.
    ```
    nano .env
    ```

7. Also make sure the `PUID` and `PGID` are set to your actual IDs in `.env` you can check this with this command *(your user is probably `root`)*:
    ```
    id <YOUR USER>
    ```
    If you run into errors also check [this](https://github.com/TechHutTV/homelab/tree/main/media#user-permissions).

8. We are now finally ready to start our docker stack.
    ```
    docker compose up -d
    ```

9. TODO: Automatic boot service

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- [Gluetun](https://gluetun.com/) - VPN Container
- [Docker](https://www.docker.com/) - Hardware accelerated containers
