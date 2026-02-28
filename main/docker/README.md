# docker

`docker` is a **Proxmox LXC** on the **Proxmox Node** with **docker** and **docker compose** installed.  
This folder contains the installation instructions and configuration files used for this device.

## Prerequisites

Before we can create our `docker` **Proxmox LXC**. We must have finished these steps:

- [`omv`](../omv/README.md) + extras.
- [`NVIDIA Driver`](../../tutorials/proxmox/NVIDIA-DRIVERS-NODE.md)

## Steps

1. From the **Proxmox Node**'s shell install a **Docker LXC** using the [community script](https://community-scripts.github.io/ProxmoxVE/scripts?id=docker):
    ```
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct/docker.sh)"
    ```

2. Choose `Advanced Install`. Go through the installation and choose your desired settings and specifications. I have given it `8vCPUs`, `12GB` of RAM and a `160GB` disk.

3. Make sure that when your installing you enable, **keyctl**, **nesting**, **gpu passthrough**, **TUN/TAP** and add `ext4` as a filesystem mount.

4. To give our **LXC** access to our network share mounted on the **Proxmox Node** we need to add these lines to `/etc/pve/lxc/<CTID>.conf`:
    ```
    nano /etc/pve/lxc/<CTID>.conf
    ```
    Add:
    ```
    mp0: /mnt/nas,mp=/mnt/nas
    ```

5. To give our **LXC** full access to `/dev/net/tun` for setting up a **VPN** we need to also add this:
    ```
    lxc.cgroup2.devices.allow: c 10:200 rwm
    lxc.mount.entry: /dev/net dev/net none bind,create=dir
    lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
    ```

6. After a restart your **Docker LXC** should have access to `/mnt/nas` and `/dev/net/tun`.

7. Now we'll create a new user on the **Proxmox LXC** that'll run our **docker compose**'s. Go to the **Shell** of your **LXC** and run:
    ```
    adduser <username>
    ```
    And choose all the default settings.

8. Now we need to give our user the proper permissions:
   ```
   usermod <username> -aG sudo
   usermod <username> -aG docker
   ```

9. Now change the shell to your docker user with:
   ```
   su <username> 
   ```

10. Now we can actually start setting up a place to work in:
    ```
    cd ~
    mkdir -p docker
    ```

11. Now we can install the NVIDIA Drivers on the LXC using [these instructions](../../tutorials/proxmox/NVIDIA-DRIVERS-LXC.md)

12. You're now ready to start setting up different compose stacks like:
    - [`networkstack`](networkstack/README.md)
    - [`downloadstack`](downloadstack/README.md)
    - [`arrstack`](arrstack/README.md)
    - [`mediastack`](mediastack/README.md)
    - [`musicstack`](musicstack/README.md)
    - [`tvstack`](tvstack/README.md)
    - [`immich`](immich/README.md)
    - [`nginx`](nginx/README.md)

## Debugging

If you have any issues setting up `docker` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.

## Extra 

To update a compose stack just run:
```
docker compose down
docker compose pull
docker compose up -d
docker image prune -f 
docker compose down
```
In the stack's directory

To remove all docker containers and their remains run:
```
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker network prune
```
To also delete cached images run:
```
docker image prune
```
