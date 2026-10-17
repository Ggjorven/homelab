# misc

`misc` is a **Proxmox LXC** on the **Proxmox Node** with **docker** and **docker compose** installed.  
This folder contains the installation instructions and configuration files used for this device.

## Steps

1. From the **Proxmox** WebUI navigate to the **Node**'s **Shell**.

2. Start creation of a **Docker LXC** using the [community script](https://community-scripts.org/scripts/docker):
    ```sh
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct/docker.sh)"
    ```

3. First you'll be prompted for the OS, choose `debian` (the default) or just wait, then in the script choose `Advanced Install`.

4. Choose **Unprivileged**, set a safe root password, set the container ID to `116` (matches with the VLAN) and set the hostname to `misc` (or something else).

5. For the `misc` LXC I have given it a disk of **32GB**, **2vCPU**s and **2048MiB** of RAM.

6. For the (primary) **Network Bridge** select `vmbr1` and set a static IP (since we don't have a DHCP server). Set the IP to `172.20.116.10/24` and the gateway to `172.20.116.1`. For IPv6 select `none`.

7. Leave **MTU Size** blank, same for **DNS search domain**.

8. For the **DNS server IP** set it to `172.20.116.1` (which is the gateway), this will forward it to the host's DNS servers.

9. Leave the **MAC-address** blank.

10. Set the **VLAN tag** to `116` to get the proper firewall rules.

11. You can keep the **Tags** as default or set it to something custom like: `docker`.

12. Provision the SSH for root by using the `found` option (or provide your own). Use space to select the key. And enable `root` SSH access.

13. Leave **FUSE support** disabled, same for **TUN/TAP** support.

14. **Enable nesting**, but disable **GPU passthrough**.

15. Leave **APT-cacher** disabled and don't set a **HTTP/HTTPS proxy**.

16. Set your **Timezone** to your timezone, mine is `Europe/Amsterdam`.

17. (Optional) Personally I like to have **Container protection** enabled to avoid accidental deletion.

18. Set **Allow device node creation** to No and leave **Filesystem mounts** empty. Same for the **Post-install hook**.

19. (Optional) If you want verbose output during installation enable it. (I like it)

20. Confirm the settings and wait... (If you're asked to update the defaults just hit Cancel)

21. When it asks you to install **Portainer** select **N**. Same for the **Portainer Agent**.

22. Also don't expose the **Docker TCP Socket**, so **N**.

23. Now that the container is installed go to the **LXC** in the WebUI and go to **Network**.

24. Double click on `net0`/`eth0`/`vmbr1` and disable the **Firewall**, since we'll be setting up our own firewall rules.

25. For debugging I also like to **Add** another **Network Device**.

26. Set the **Name** to `eth1`. Set the **Bridge** to `vmbr0` and disable the **Firewall**.

27. Set **IPv4** to **DHCP** (since it's only for debugging) and set **IPv6** to **Static** and leave it empty. **Add**!

28. We also want the **LXC** to boot properly on startup, go to **Options** tab and set **Start/Shutdown order** to `15`.

29. Reboot the **LXC** to apply the changes.

30. We'll want to SSH into the **LXC**, but we need the ip address for that, go to the **Network** tab and look for the IP address under `net1`/`eth1`/`vmbr0` (ex. `192.168.xxx.xxx`).

31. Now on your local machine open a terminal.

32. SSH into that machine via the `root` user.
    ```sh
    ssh root@<ip-address>
    ```
    Where `<ip-address>` is the IPv4 address of the **LXC**.

33. You may get an authenticity warning, type `yes` to continue. Then login with the `root` password you set during the installation.

34. Create the `misc` group and user in the LXC using:
    ```sh
    groupadd -g 1000 misc
    useradd -u 1000 -g 1000 -m -s /bin/bash misc
    usermod -aG docker misc
    usermod -aG sudo misc
    ```

35. Set a (safe) password for the `misc` user:
    ```sh
    passwd misc
    ```

36. Now login as the `misc` user:
    ```sh
    su misc
    ```

37. Now we're going to install all of the files. Start by navigating to the `home` directory:
    ```sh
    cd ~/
    ```

38. Get the global .env:
    ```sh
    BRANCH=main
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/.env"
    ```

39. Create the `networking` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/networking
    cd ~/networking
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/networking/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/networking/compose.yaml"
    ```

40. Create the `monitoring` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/monitoring
    cd ~/monitoring
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/monitoring/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/monitoring/compose.yaml"
    ```

41. Create the `memos` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/memos
    cd ~/memos
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/memos/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/memos/compose.yaml"
    ```

42. Create the `leantime` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/leantime
    cd ~/leantime
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/leantime/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/leantime/compose.yaml"
    ```

43. Get the `up` and `down` scripts:
    ```sh
    BRANCH=main
    sudo mkdir -p /lxc/scripts
    cd /lxc/scripts
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/scripts/up-networking.sh"
    sudo chmod +x up-networking.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/scripts/up-monitoring.sh"
    sudo chmod +x up-monitoring.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/scripts/up-memos.sh"
    sudo chmod +x up-memos.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/scripts/up-leantime.sh"
    sudo chmod +x up-leantime.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/scripts/down-networking.sh"
    sudo chmod +x down-networking.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/scripts/down-monitoring.sh"
    sudo chmod +x down-monitoring.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/scripts/down-memos.sh"
    sudo chmod +x down-memos.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/scripts/down-leantime.sh"
    sudo chmod +x down-leantime.sh
    ```

44. Also get the `compose-boot`, `compose-shutdown` and `compose-restart` scripts and services:
    ```sh
    BRANCH=main
    sudo mkdir -p /lxc/scripts
    cd /lxc/scripts
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/scripts/compose-boot.sh"
    sudo chmod +x compose-boot.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/scripts/compose-shutdown.sh"
    sudo chmod +x compose-shutdown.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/scripts/compose-restart.sh"
    sudo chmod +x compose-restart.sh
    cd /etc/systemd/system
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/services/compose-boot.service"
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/services/compose-shutdown.service"
    ```

45. Enable the `systemctl` for `compose-boot` and `compose-shutdown`:
    ```sh
    sudo systemctl daemon-reload
    sudo systemctl enable compose-boot
    sudo systemctl enable compose-shutdown
    ```

46. Now start the `networking` and `monitoring` stacks:
    ```sh
    sudo /lxc/scripts/up-networking.sh
    sudo /lxc/scripts/up-monitoring.sh
    ```
    You can now start configuring individual stacks listed below.

## Configuration

### Memos

**Memos** doesn't require any configuring via the `.env` file.  
So just start the container:
```sh
sudo /lxc/scripts/up-memos.sh
```

Now that the container is running we'll start configuring via the WebUI on port `5230`. This requires either having `vmbr0` still attached or having set up [`priv-net`](./../priv-net/README.md).

1. TODO

### Leantime

First we'll start by configuring via the `.env` file.

1. Open the `.env`:
    ```sh
    nano ~/leantime/.env
    ```
    Set secure passwords in the `DATABASE_ROOT_PASSWORD` and `DATABASE_USER_PASSWORD` variables.  
    Also [generate a JWT secret](https://randomkeygen.com/jwt-secret) to set as the `SESSION_SALT`.  
    (optional) Set `BASE_DOMAIN` to your domain if you're using a reverse proxy (ex. `example.com`).

2. Create the config and log directories:
    ```sh
    mkdir -p ~/leantime/config
    mkdir -p ~/leantime/config/public
    mkdir -p ~/leantime/config/user
    mkdir -p ~/leantime/config/plugins
    mkdir -p ~/leantime/logs
    ```

3. You can now start the container:
    ```sh
    sudo /lxc/scripts/up-leantime.sh
    ```

Now that the container is running we'll start configuring via the WebUI on port `8080`. This requires either having `vmbr0` still attached or having set up [`priv-net`](./../priv-net/README.md).

1. TODO

## Debugging

If you have any issues setting up `misc` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.

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
docker network prune
```
To also delete cached images run:
```
docker image prune
```
