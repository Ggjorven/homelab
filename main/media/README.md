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

21. Now that the container is installed go to the **LXC** in the WebUI and go to **Network**.

22. Double click on `net0`/`eth0`/`vmbr1` and disable the **Firewall**, since we'll be setting up our own firewall rules.

23. For debugging I also like to **Add** another **Network Device**. 

24. Set the **Name** to `eth1`. Set the **Bridge** to `vmbr0` and disable the **Firewall**.

25. Set **IPv4** to **DHCP** (since it's only for debugging) and set **IPv6** to **Static** and leave it empty. **Add**!

26. We also want to give the **LXC** access to our `media` dataset from [truenas](./../truenas/README.md), so open the **Proxmox Node**'s **Shell**.

27. Edit the **LXC**'s config file:
    ```sh
    nano /etc/pve/lxc/101.conf
    ```
    Where `101` is the container ID (CTID) or LXC ID.

28. Pass through the `/mnt/media` mountpoint by pasting:
    ```
    mp0: /mnt/media,mp=/mnt/media
    ```

29. We'll also want to make the `media`'s user and group ID to be properly passed through to the mountpoint/NFS share. `media`:`media` is `1001`:`1001` as set during the [truenas installation](./../truenas/README.md). So also paste this in `/etc/pve/lxc/101.conf`:
    ```
    lxc.idmap: g 0 100000 1001
    lxc.idmap: g 1001 1001 1
    lxc.idmap: g 1002 101002 64534
    lxc.idmap: u 0 100000 1001
    lxc.idmap: u 1001 1001 1
    lxc.idmap: u 1002 101002 64534
    ```
    The explanation/tutorial for these id mappings can be found [here](./../../tutorials/proxmox/UNPRIVILEGED-LXC-UID-GID-PASSTHROUGH.md).

30. Now reboot the **LXC**.

31. Now go to **LXC**'s **Shell** and login with `root` and the password you set in the installation.

32. Install the same NVIDIA drivers on the **LXC** as on the **Proxmox Node** with [this tutorial](./../../tutorials/proxmox/NVIDIA-DRIVERS-LXC.md).

33. Create a `media` group and user in the LXC using:
    ```sh
    groupadd -g 1001 media
    useradd media -u 1001
    usermod -aG media media
    usermod -aG docker media
    usermod -aG sudo media
    ```

34. Set a (safe) password for the `media` user:
    ```sh
    passwd media
    ```

35. Now login as the `media` user:
    ```sh
    su media
    ```

36. Now we're going to set up the required compose stacks: `networking` & `monitoring`. Start by navigating to the `home` directory:
    ```sh
    cd ~/
    ```

37. aaa

## Configuration

### Jellyfin

// TODO: Aaa

## Automatic boot/shutdown

// TODO: ...

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
