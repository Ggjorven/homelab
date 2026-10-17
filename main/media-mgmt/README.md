# media-mgmt

`media-mgmt` is a **Proxmox LXC** on the **Proxmox Node** with **docker** and **docker compose** installed.  
This folder contains the installation instructions and configuration files used for this device.

## Prerequisites

Before we can create our `media-mgmt` **Proxmox LXC**. We must have finished these steps:

- [`truenas`](../truenas/README.md)

## Steps

1. From the **Proxmox** WebUI navigate to the **Node**'s **Shell**.

2. Start creation of a **Docker LXC** using the [community script](https://community-scripts.org/scripts/docker):
    ```sh
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct/docker.sh)"
    ```

3. First you'll be prompted for the OS, choose `debian` (the default) or just wait, then in the script choose `Advanced Install`.

4. Choose **Unprivileged**, set a safe root password, set the container ID to `102` (matches with the VLAN) and set the hostname to `media-mgmt` (or something else).

5. For the `media-mgmt` LXC I have given it a disk of **10**, **2vCPU**s and **1024MiB** of RAM.

6. For the (primary) **Network Bridge** select `vmbr1` and set a static IP (since we don't have a DHCP server). Set the IP to `172.20.102.10/24` and the gateway to `172.20.102.1`. For IPv6 select `none`.

7. Leave **MTU Size** blank, same for **DNS search domain**.

8. For the **DNS server IP** set it to `172.20.102.1` (which is the gateway), this will forward it to the host's DNS servers.

9. Leave the **MAC-address** blank.

10. Set the **VLAN tag** to `102` to get the proper firewall rules.

11. You can keep the **Tags** as default or set it to something custom like: `docker;management`.

12. Provision the SSH for root by using the `found` option (or provide your own). Use space to select the key. And enable `root` SSH access.

13. Leave **FUSE support** disabled, same for **TUN/TAP** support.

14. **Enable nesting** and **Disable GPU passthrough**.

15. Leave **APT-cacher** disabled and don't set a **HTTP/HTTPS proxy**.

16. Set your **Timezone** to your timezone, mine is `Europe/Amsterdam`.

17. (optional) Personally I like to have **Container protection** enabled to avoid accidental deletion.

18. Set **Allow device node creation** to No and leave **Filesystem mounts** empty. Same for the **Post-install hook**.

19. (optional) If you want verbose output during installation enable it. (I like it)

20. Confirm the settings and wait... (If you're asked to update the defaults just hit Cancel)

21. When it asks you to install **Portainer** select **N**. Same for the **Portainer Agent**.

22. Also don't expose the **Docker TCP Socket**, so **N**.

23. Now that the container is installed go to the **LXC** in the WebUI and go to **Network**.

24. Double click on `net0`/`eth0`/`vmbr1` and disable the **Firewall**, since we'll be setting up our own firewall rules.

25. For debugging I also like to **Add** another **Network Device**.

26. Set the **Name** to `eth1`. Set the **Bridge** to `vmbr0` and disable the **Firewall**.

27. Set **IPv4** to **DHCP** (since it's only for debugging) and set **IPv6** to **Static** and leave it empty. **Add**!

28. We also want the **LXC** to boot properly on startup, go to **Options** tab and set **Start/Shutdown order** to `3`.

29. We also want to give the **LXC** access to our `media` dataset from [truenas](./../truenas/README.md), so open the **Proxmox Node**'s **Shell**.

30. Edit the **LXC**'s config file:
    ```sh
    nano /etc/pve/lxc/102.conf
    ```
    Where `102` is the container ID (CTID) or LXC ID.

31. Pass through the `/mnt/media` mountpoint by pasting:
    ```
    mp0: /mnt/media,mp=/mnt/media
    ```

32. Now reboot the **LXC**.

33. We'll want to SSH into the **LXC**, but we need the ip address for that, go to the **Network** tab and look for the IP address under `net1`/`eth1`/`vmbr0` (ex. `192.168.xxx.xxx`).

34. Now on your local machine open a terminal.

35. SSH into that machine via the `root` user.
    ```sh
    ssh root@<ip-address>
    ```
    Where `<ip-address>` is the IPv4 address of the **LXC**.

36. You may get an authenticity warning, type `yes` to continue. Then login with the `root` password you set during the installation.

37. Install the same NVIDIA drivers on the **LXC** as on the **Proxmox Node** with [this tutorial](./../../tutorials/proxmox/NVIDIA-DRIVERS-LXC.md).

38. Now install the NVIDIA Container runtime using [these instructions](./../../tutorials/docker/NVIDIA-RUNTIME.md).

39. Create a `mediamgmt` group and user in the LXC using:
    ```sh
    groupadd -g 1000 mediamgmt
    useradd -u 1000 -g 1000 -m -s /bin/bash mediamgmt
    usermod -aG docker mediamgmt
    usermod -aG sudo mediamgmt
    ```

40. Set a (safe) password for the `mediamgmt` user:
    ```sh
    passwd mediamgmt
    ```

41. Now login as the `mediamgmt` user:
    ```sh
    su mediamgmt
    ```

42. Now we're going to install all of the files. Start by navigating to the `home` directory:
    ```sh
    cd ~/
    ```

43. Get the global .env:
    ```sh
    BRANCH=main
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media-mgmt/.env"
    ```

44. Create the `networking` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/networking
    cd ~/networking
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media-mgmt/networking/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media-mgmt/networking/compose.yaml"
    ```

45. Create the `monitoring` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/monitoring
    cd ~/monitoring
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media-mgmt/monitoring/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media-mgmt/monitoring/compose.yaml"
    ```

46. Create the `metadata-remote` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/metadata-remote
    cd ~/metadata-remote
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media-mgmt/metadata-remote/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media-mgmt/metadata-remote/compose.yaml"
    ```

47. Get the `up` and `down` scripts:
    ```sh
    BRANCH=main
    sudo mkdir -p /lxc/scripts
    cd /lxc/scripts
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media-mgmt/scripts/up-networking.sh"
    sudo chmod +x up-networking.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media-mgmt/scripts/up-monitoring.sh"
    sudo chmod +x up-monitoring.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media-mgmt/scripts/up-metadata-remote.sh"
    sudo chmod +x up-metadata-remote.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media-mgmt/scripts/down-networking.sh"
    sudo chmod +x down-networking.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media-mgmt/scripts/down-monitoring.sh"
    sudo chmod +x down-monitoring.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media-mgmt/scripts/down-metadata-remote.sh"
    sudo chmod +x down-metadata-remote.sh
    ```

48. Also get the `compose-boot`, `compose-shutdown` and `compose-restart` scripts and services:
    ```sh
    BRANCH=main
    sudo mkdir -p /lxc/scripts
    cd /lxc/scripts
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media-mgmt/scripts/compose-boot.sh"
    sudo chmod +x compose-boot.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media-mgmt/scripts/compose-shutdown.sh"
    sudo chmod +x compose-shutdown.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media-mgmt/scripts/compose-restart.sh"
    sudo chmod +x compose-restart.sh
    cd /etc/systemd/system
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media-mgmt/services/compose-boot.service"
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/media-mgmt/services/compose-shutdown.service"
    ```

49. Enable the `systemctl` for `compose-boot` and `compose-shutdown`:
    ```sh
    sudo systemctl daemon-reload
    sudo systemctl enable compose-boot
    sudo systemctl enable compose-shutdown
    ```

50. Now start the `networking` and `monitoring` stacks:
    ```sh
    sudo /lxc/scripts/up-networking.sh
    sudo /lxc/scripts/up-monitoring.sh
    ```
    You can now start configuring individual stacks listed below.

## Configuration

### metadata-remote

We can fully configure `metadata-remote` by editing the `.env` file.

1. Open the `.env`:
    ```sh
    nano ~/metadata-remote/.env
    ```
    Change `MUSIC_FOLDER` to your music folder, I use `/mnt/media/music`.

2. Make sure the folders actually exist:
    ```sh
    mkdir -p /mnt/media/music
    ```

3. You can now start the container:
    ```sh
    sudo /lxc/scripts/up-metadata-remote.sh
    ```

Now that the container is running you can access the WebUI on port `8338`. This requires either having `vmbr0` still attached or having set up [`priv-net`](./../priv-net/README.md).  

## Debugging

If you have any issues setting up `media-mgmt` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.

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
