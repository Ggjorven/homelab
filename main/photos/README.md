# photos

`photos` is a **Proxmox LXC** on the **Proxmox Node** with **docker** and **docker compose** installed.  
This folder contains the installation instructions and configuration files used for this device.

## Prerequisites

Before we can create our `media` **Proxmox LXC**. We must have finished these steps:

- [`truenas`](../truenas/README.md)
- [`Node NVIDIA Driver`](../../tutorials/proxmox/NVIDIA-DRIVERS-NODE.md)

## Steps

1. From the **Proxmox** WebUI navigate to the **Node**'s **Shell**.

2. Start creation of a **Docker LXC** using the [community script](https://community-scripts.org/scripts/docker):
    ```sh
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct/docker.sh)"
    ```

3. Choose `Advanced Install`. 

4. Choose **Unprivileged**, set a safe root password, set the container ID to `1` (matches with the VLAN) and set the hostname to `media` (or something else).

5. For the `media` LXC I have given it a disk of **32GB**, **4vCPU**s and **4096MiB** of RAM.

6. For the (primary) **Network Bridge** select `vmbr1` and set a static IP (since we don't have a DHCP server). Set the IP to `172.20.103.10/24` and the gateway to `172.20.103.1`. For IPv6 select `none`.

7. Leave **MTU Size** blank, same for **DNS search domain**, **DNS server IP** and **MAC-address**.

8. Set the **VLAN tag** to `103` to get the proper firewall rules.

9. You can keep the **Tags** as default or set it to something custom like: `docker;photos`.

10. Provision the SSH for root by using the `found` option (or provide your own). Use space to select the key. And enable `root` SSH access.

11. Leave **FUSE support** disabled, same for **TUN/TAP** support.

12. **Enable nesting** and **Enable GPU passthrough**.

13. Leave **APT-cacher** disabled and don't set a **HTTP/HTTPS proxy**.

14. Set your **Timezone** to your timezone, mine is `Europe/Amsterdam`.

15. (optional) Personally I like to have **Container protection** enabled to avoid accidental deletion.

16. Set **Allow device node creation** to No and leave **Filesystem mounts** empty. Same for the **Post-install hook**.

17. (optional) If you want verbose output during installation enable it. (I like it)

18. Confirm the settings and wait... (If you're asked to update the defaults just hit Cancel)

19. When it asks you to install **Portainer** select **N**. Same for the **Portainer Agent**.

20. Also don't expose the **Docker TCP Socket**, so **N**.

21. Now that the container is installed go to the **LXC** in the WebUI and go to **Network**.

22. Double click on `net0`/`eth0`/`vmbr1` and disable the **Firewall**, since we'll be setting up our own firewall rules.

23. For debugging I also like to **Add** another **Network Device**. 

24. Set the **Name** to `eth1`. Set the **Bridge** to `vmbr0` and disable the **Firewall**.

25. Set **IPv4** to **DHCP** (since it's only for debugging) and set **IPv6** to **Static** and leave it empty. **Add**!

26. We also want the **LXC** to boot properly on startup, go to **Options** tab and set **Start/Shutdown order** to `4`. 

27. We also want to give the **LXC** access to our `photos` dataset from [truenas](./../truenas/README.md), so open the **Proxmox Node**'s **Shell**.

28. Edit the **LXC**'s config file:
    ```sh
    nano /etc/pve/lxc/103.conf
    ```
    Where `103` is the container ID (CTID) or LXC ID.

29. Pass through the `/mnt/photos` mountpoint by pasting:
    ```
    mp0: /mnt/photos,mp=/mnt/photos
    ```

30. Now reboot the **LXC**.

31. Go to **LXC**'s **Shell** and login with `root` and the password you set in the installation.

32. Install the same NVIDIA drivers on the **LXC** as on the **Proxmox Node** with [this tutorial](./../../tutorials/proxmox/NVIDIA-DRIVERS-LXC.md).

33. Now install the NVIDIA Container runtime using [these instructions](./../../tutorials/docker/NVIDIA-RUNTIME.md).

34. Create a `photos` group and user in the LXC using:
    ```sh
    groupadd -g 1000 photos
    useradd -u 1000 -g 1000 -m -s /bin/bash photos
    usermod -aG docker photos
    usermod -aG sudo photos
    ```

35. Set a (safe) password for the `photos` user:
    ```sh
    passwd photos
    ```

36. Now login as the `photos` user:
    ```sh
    su photos
    ```

37. Now we're going to install all of the files. Start by navigating to the `home` directory:
    ```sh
    cd ~/
    ```

38. Get the global .env:
    ```sh
    BRANCH=main
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/photos/.env"
    ```

39. Create the `networking` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/networking
    cd ~/networking
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/photos/networking/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/photos/networking/compose.yaml"
    ```

40. Create the `monitoring` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/monitoring
    cd ~/monitoring
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/photos/monitoring/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/photos/monitoring/compose.yaml"
    ```

41. Create the `immich` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/immich
    cd ~/immich
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/photos/immich/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/photos/immich/compose.yaml"
    ```

42. Get the `up` and `down` scripts:
    ```sh
    BRANCH=main
    sudo mkdir -p /lxc/scripts
    cd /lxc/scripts
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/photos/scripts/up-networking.sh"
    sudo chmod +x up-networking.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/photos/scripts/up-monitoring.sh"
    sudo chmod +x up-monitoring.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/photos/scripts/up-immich.sh"
    sudo chmod +x up-immich.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/photos/scripts/down-networking.sh"
    sudo chmod +x down-networking.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/photos/scripts/down-monitoring.sh"
    sudo chmod +x down-monitoring.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/photos/scripts/down-immich.sh"
    sudo chmod +x down-immich.sh
    ```

43. Also get the `compose-boot`, `compose-shutdown` and `compose-restart` scripts and services:
    ```sh
    BRANCH=main
    sudo mkdir -p /lxc/scripts
    cd /lxc/scripts
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/photos/scripts/compose-boot.sh"
    sudo chmod +x compose-boot.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/photos/scripts/compose-shutdown.sh"
    sudo chmod +x compose-shutdown.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/photos/scripts/compose-restart.sh"
    sudo chmod +x compose-restart.sh
    cd /etc/systemd/system
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/photos/services/compose-boot.service"
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/photos/services/compose-shutdown.service"
    ```

44. Enable the `systemctl` for `compose-boot` and `compose-shutdown`:
    ```sh
    sudo systemctl daemon-reload
    sudo systemctl enable compose-boot
    sudo systemctl enable compose-shutdown
    ```

45. Now start the `networking` and `monitoring` stacks:
    ```sh
    sudo /lxc/scripts/up-networking.sh
    sudo /lxc/scripts/up-monitoring.sh
    ```
    You can now start configuring individual stacks listed below.

## Configuration

### Immich

First we'll start by configuring via the `.env` file.

1. Open the `.env`:
    ```sh
    cd ~/immich
    nano .env
    ```
    Change `PHOTOS_FOLDER` to your actual fotos directory, I use `/mnt/photos`.  
    Also change `DATABASE_PASSWORD` to a secure password.

2. You can now start the container:
    ```sh
    sudo /lxc/scripts/up-immich.sh
    ```

Now that the container is running we'll start configuring via the WebUI on port `2283`. This requires either having `vmbr0` still attached or having set up [`priv-net`](./../priv-net/README.md).

1. // TODO: Setup

2. // TODO: External url https://immich.local.mydomain.com

## Debugging

If you have any issues setting up `photos` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.

## Extra 

To update a compose stack's images just run:
```
docker compose pull
docker image prune
```
In the stack's directory and restart the stack.

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
