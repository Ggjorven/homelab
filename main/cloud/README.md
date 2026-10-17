# cloud

`cloud` is a **Proxmox LXC** on the **Proxmox Node** with **docker** and **docker compose** installed.  
This folder contains the installation instructions and configuration files used for this device.

## Prerequisites

Before we can create our `cloud` **Proxmox LXC**. We must have finished these steps:

- [`truenas`](../truenas/README.md)

## Steps

1. From the **Proxmox** WebUI navigate to the **Node**'s **Shell**.

2. Start creation of a **Docker LXC** using the [community script](https://community-scripts.org/scripts/docker):
    ```sh
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct/docker.sh)"
    ```

3. First you'll be prompted for the OS, choose `debian` (the default) or just wait, then in the script choose `Advanced Install`.

4. Choose **Unprivileged**, set a safe root password, set the container ID to `104` (matches with the VLAN) and set the hostname to `cloud` (or something else).

5. For the `cloud` LXC I have given it a disk of **32GB**, **4vCPU**s and **8192MiB** of RAM.

6. For the (primary) **Network Bridge** select `vmbr1` and set a static IP (since we don't have a DHCP server). Set the IP to `172.20.104.10/24` and the gateway to `172.20.104.1`. For IPv6 select `none`.

7. Leave **MTU Size** blank, same for **DNS search domain**.

8. For the **DNS server IP** set it to `172.20.104.1` (which is the gateway), this will forward it to the host's DNS servers.

9. Leave the **MAC-address** blank.

10. Set the **VLAN tag** to `104` to get the proper firewall rules.

11. You can keep the **Tags** as default or set it to something custom like: `docker;cloud`.

12. Provision the SSH for root by using the `found` option (or provide your own). Use space to select the key. And enable `root` SSH access.

13. Leave **FUSE support** disabled, same for **TUN/TAP** support.

14. **Enable nesting**, but disable **GPU passthrough**.

15. Leave **APT-cacher** disabled and don't set a **HTTP/HTTPS proxy**.

16. Set your **Timezone** to your timezone, mine is `Europe/Amsterdam`.

17. (optional) Personally I like to have **Container protection** enabled to avoid accidental deletion.

18. Set **Allow device node creation** to **No** and leave **Filesystem mounts** empty. Same for the **Post-install hook**.

19. (optional) If you want verbose output during installation enable it. (I like it)

20. Confirm the settings and wait... (If you're asked to update the defaults just hit Cancel)

21. When it asks you to install **Portainer** select **N**. Same for the **Portainer Agent**.

22. Also don't expose the **Docker TCP Socket**, so **N**.

23. Now that the container is installed go to the **LXC** in the WebUI and go to **Network**.

24. Double click on `net0`/`eth0`/`vmbr1` and disable the **Firewall**, since we'll be setting up our own firewall rules.

25. For debugging I also like to **Add** another **Network Device**.

26. Set the **Name** to `eth1`. Set the **Bridge** to `vmbr0` and disable the **Firewall**.

27. Set **IPv4** to **DHCP** (since it's only for debugging) and set **IPv6** to **Static** and leave it empty. **Add**!

28. We also want the **LXC** to boot properly on startup, go to **Options** tab and set **Start/Shutdown order** to `5`.

29. We also want to give the **LXC** access to our `cloud` dataset from [truenas](./../truenas/README.md), so open the **Proxmox Node**'s **Shell**.

30. Edit the **LXC**'s config file:
    ```sh
    nano /etc/pve/lxc/104.conf
    ```
    Where `104` is the container ID (CTID) or LXC ID.

31. Pass through the `/mnt/cloud` mountpoint by pasting:
    ```
    mp0: /mnt/cloud,mp=/mnt/cloud
    ```

32. Now reboot the **LXC**.

33. Go to **LXC**'s **Shell** and login with `root` and the password you set in the installation.

34. Create a `cloud` group and user in the LXC using:
    ```sh
    groupadd -g 1000 cloud
    useradd -u 1000 -g 1000 -m -s /bin/bash cloud
    usermod -aG docker cloud
    usermod -aG sudo cloud
    ```

35. Set a (safe) password for the `cloud` user:
    ```sh
    passwd cloud
    ```

36. Now login as the `cloud` user:
    ```sh
    su cloud
    ```

37. Now we're going to install all of the files. Start by navigating to the `home` directory:
    ```sh
    cd ~/
    ```

38. Get the global .env:
    ```sh
    BRANCH=main
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/cloud/.env"
    ```

39. Create the `networking` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/networking
    cd ~/networking
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/cloud/networking/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/cloud/networking/compose.yaml"
    ```

40. Create the `monitoring` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/monitoring
    cd ~/monitoring
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/cloud/monitoring/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/cloud/monitoring/compose.yaml"
    ```

41. Get the `up` and `down` scripts:
    ```sh
    BRANCH=main
    sudo mkdir -p /lxc/scripts
    cd /lxc/scripts
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/cloud/scripts/up-networking.sh"
    sudo chmod +x up-networking.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/cloud/scripts/up-monitoring.sh"
    sudo chmod +x up-monitoring.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/cloud/scripts/down-networking.sh"
    sudo chmod +x down-networking.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/cloud/scripts/down-monitoring.sh"
    sudo chmod +x down-monitoring.sh
    ```

42. Also get the `compose-boot`, `compose-shutdown` and `compose-restart` scripts and services:
    ```sh
    BRANCH=main
    sudo mkdir -p /lxc/scripts
    cd /lxc/scripts
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/cloud/scripts/compose-boot.sh"
    sudo chmod +x compose-boot.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/cloud/scripts/compose-shutdown.sh"
    sudo chmod +x compose-shutdown.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/cloud/scripts/compose-restart.sh"
    sudo chmod +x compose-restart.sh
    cd /etc/systemd/system
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/cloud/services/compose-boot.service"
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/cloud/services/compose-shutdown.service"
    ```

43. Enable the `systemctl` for `compose-boot` and `compose-shutdown`:
    ```sh
    sudo systemctl daemon-reload
    sudo systemctl enable compose-boot
    sudo systemctl enable compose-shutdown
    ```

44. Now start the `networking` and `monitoring` stacks:
    ```sh
    sudo /lxc/scripts/up-networking.sh
    sudo /lxc/scripts/up-monitoring.sh
    ```
    You can now start configuring individual stacks listed below.

## Configuration

### NextCloud

First we'll start by configuring via the `.env` file.

// TODO: ...

Now that the container is running we'll start configuring via the WebUI on port `8080`. This requires either having `vmbr0` still attached or having set up [`priv-net`](./../priv-net/README.md).

// TODO: ...

## Debugging

If you have any issues setting up `cloud` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.

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
