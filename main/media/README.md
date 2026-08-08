# media

`media` is a **Proxmox LXC** on the **Proxmox Node** with **docker** and **docker compose** installed.  
This folder contains the installation instructions and configuration files used for this device.

## Prerequisites

Before we can create our `media` **Proxmox LXC**. We must have finished these steps:

- [`truenas`](../truenas/README.md)
- [`Node NVIDIA Driver`](../../tutorials/proxmox/NVIDIA-DRIVERS-NODE.md)

## Steps

1. From the **Proxmox** WebUI navigate to the **Node**'s **Shell**.

2. Start creation of a **Docker LXC** using the [community script](https://community-scripts.org/scripts/docker):
    ```
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct/docker.sh)"
    ```

3. Choose `Advanced Install`. 

4. Choose **Unpriviliged**, set a safe root password, set the container ID to `101` (matches with the VLAN) and set the hostname to `media` (or something else).

5. For the `media` LXC I have given it a disk of **48GB**, **4vCPU**s and **4096MiB** of RAM.

6. For the (primary) **Network Bridge** select `vmbr1` and set a static IP (since we don't have a DHCP server). Set the IP to `172.20.101.10/24` and the gateway to `172.20.101.1`. For IPv6 select `none`.

7. Leave **MTU Size** blank, same for **DNS search domain**, **DNS server IP** and **MAC-address**.

8. Set the **VLAN tag** to `101` to get the proper firewall rules.

9. You can keep the **Tags** as default or set it to something custom like: `docker;media`.

10. Provision the SSH for root by using the `found` option (or provide your own). Use space to select the key. And enable `root` SSH access.

11. Leave **FUSE support** disabled, same for **TUN/TAP** support.

12. **Enable nesting** and **Enable GPU passthrough**.

13. Leave **APT-cacher** disabled and don't set a **HTTP/HTTPS proxy**.

14. Set your **Timezone** to your timezone, mine is `Europe/Amsterdam`.

15. (Optional) Personally I like to have **Container protection** enabled to avoid accidental deletion.

16. Set **Allow device node creation** to No and leave **Filesystem mounts** empty. Same for the **Post-install hook**.

17. (Optional) If you want verbose output during installation enable it. (I like it)

18. Confirm the settings and wait... (If you're asked to update the defaults just hit Cancel)

19. When it asks you to install **Portainer** select **N**. Same for the **Portainer Agent**.

20. Also don't expose the **Docker TCP Socket**, so **N**.

21. Now that the container is installed aaa




Go through the installation and choose your desired settings and specifications. I have given it `8vCPUs`, `12GB` of RAM and a `160GB` disk.

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

## Debugging

If you have any issues setting up `media` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.

## Extra 

To update a compose stack's images just run:
```
docker compose down
docker compose pull
docker compose up -d
docker image prune
```
In the stack's directory

To remove all docker containers and their remains run:

> [!CAUTION]
> This action is irreversible and will delete docker containers and networks.

```
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker network prune
```
To also delete cached images run:
```
docker image prune
```
