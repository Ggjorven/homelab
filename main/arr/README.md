# arr

`arr` is a **Proxmox LXC** on the **Proxmox Node** with **docker** and **docker compose** installed.  
This folder contains the installation instructions and configuration files used for this device.

## Steps

1. From the **Proxmox** WebUI navigate to the **Node**'s **Shell**.

2. Start creation of a **Docker LXC** using the [community script](https://community-scripts.org/scripts/docker):
    ```sh
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct/docker.sh)"
    ```

3. Choose `Advanced Install`. 

4. Choose **Unprivileged**, set a safe root password, set the container ID to `105` (matches with the VLAN) and set the hostname to `arr` (or something else).

5. For the `arr` LXC I have given it a disk of **32GB**, **4vCPU**s and **4096MiB** of RAM.

6. For the (primary) **Network Bridge** select `vmbr1` and set a static IP (since we don't have a DHCP server). Set the IP to `172.20.105.10/24` and the gateway to `172.20.105.1`. For IPv6 select `none`.

7. Leave **MTU Size** blank, same for **DNS search domain**, **DNS server IP** and **MAC-address**.

8. Set the **VLAN tag** to `105` to get the proper firewall rules.

9. You can keep the **Tags** as default or set it to something custom like: `docker`.

10. Provision the SSH for root by using the `found` option (or provide your own). Use space to select the key. And enable `root` SSH access.

11. Leave **FUSE support** disabled, enable **TUN/TAP** support.

12. **Enable nesting**, but disable **GPU passthrough**.

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

26. We also want to give the **LXC** access to our `media` and `downloads` datasets from [truenas](./../truenas/README.md), so open the **Proxmox Node**'s **Shell**.

27. Edit the **LXC**'s config file:
    ```sh
    nano /etc/pve/lxc/105.conf
    ```
    Where `105` is the container ID (CTID) or LXC ID.

28. Pass through the `/mnt/media` mountpoint by pasting:
    ```
    mp0: /mnt/media,mp=/mnt/media
    mp1: /mnt/downloads,mp=/mnt/downloads
    ```

29. Reboot the **LXC** to apply the changes.

30. Now go to **LXC**'s **Shell** and login with `root` and the password you set in the installation.

31. Create the `arr` group and user in the LXC using:
    ```sh
    groupadd -g 1000 arr
    useradd -u 1000 -g 1000 -m -s /bin/bash arr
    usermod -aG docker arr
    usermod -aG sudo arr
    ```

32. Set a (safe) password for the `arr` user:
    ```sh
    passwd arr
    ```

33. Now login as the `arr` user:
    ```sh
    su arr
    ```

34. Now we're going to install all of the files. Start by navigating to the `home` directory:
    ```sh
    cd ~/
    ```

35. Get the global .env:
    ```sh
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/.env
    ```

36. Create the `networking` stack:
    ```sh
    mkdir -p ~/networking
    cd ~/networking
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/networking/.env
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/networking/compose.yaml
    ```

37. Create the `monitoring` stack:
    ```sh
    mkdir -p ~/monitoring
    cd ~/monitoring
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/monitoring/.env
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/monitoring/compose.yaml
    ```

38. Create the `vpn1` stack:
    ```sh
    mkdir -p ~/vpn1
    cd ~/vpn1
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/vpn1/.env
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/vpn1/compose.yaml
    ```

39. Create the `vpn2` stack:
    ```sh
    mkdir -p ~/vpn2
    cd ~/vpn2
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/vpn2/.env
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/vpn2/compose.yaml
    ```

40. Create the `byparr` stack:
    ```sh
    mkdir -p ~/byparr
    cd ~/byparr
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/byparr/.env
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/byparr/compose.yaml
    ```

41. Create the `qbittorrent` stack:
    ```sh
    mkdir -p ~/qbittorrent
    cd ~/qbittorrent
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/qbittorrent/.env
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/qbittorrent/compose.yaml
    ```

42. Create the `qbittorrent` stack:
    ```sh
    mkdir -p ~/qbittorrent
    cd ~/qbittorrent
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/qbittorrent/.env
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/qbittorrent/compose.yaml
    ```

43. Create the `slskd` stack:
    ```sh
    mkdir -p ~/slskd
    cd ~/slskd
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/slskd/.env
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/slskd/compose.yaml
    ```

44. Create the `jackett` stack:
    ```sh
    mkdir -p ~/jackett
    cd ~/jackett
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/jackett/.env
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/jackett/compose.yaml
    ```

45. Create the `prowlarr` stack:
    ```sh
    mkdir -p ~/prowlarr
    cd ~/prowlarr
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/prowlarr/.env
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/prowlarr/compose.yaml
    ```

46. Create the `radarr` stack:
    ```sh
    mkdir -p ~/radarr
    cd ~/radarr
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/radarr/.env
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/radarr/compose.yaml
    ```

47. Create the `sonarr` stack:
    ```sh
    mkdir -p ~/sonarr
    cd ~/sonarr
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/sonarr/.env
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/sonarr/compose.yaml
    ```

48. Create the `lidarr` stack:
    ```sh
    mkdir -p ~/lidarr
    cd ~/lidarr
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/lidarr/.env
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/lidarr/compose.yaml
    ```

49. Create the `bazarr` stack:
    ```sh
    mkdir -p ~/bazarr
    cd ~/bazarr
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/bazarr/.env
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/bazarr/compose.yaml
    ```

50. Create the `metube` stack:
    ```sh
    mkdir -p ~/metube
    cd ~/metube
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/metube/.env
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/metube/compose.yaml
    ```

51. Get the `up` and `down` scripts:
    ```sh
    sudo mkdir -p /lxc/scripts
    cd /lxc/scripts
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/scripts/up-networking.sh
    sudo chmod +x up-networking.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/scripts/up-monitoring.sh
    sudo chmod +x up-monitoring.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/scripts/up-vpn1.sh
    sudo chmod +x up-vpn1.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/scripts/up-vpn2.sh
    sudo chmod +x up-vpn2.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/scripts/up-byparr.sh
    sudo chmod +x up-byparr.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/scripts/up-qbittorrent.sh
    sudo chmod +x up-qbittorrent.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/scripts/up-slskd.sh
    sudo chmod +x up-slskd.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/scripts/up-jackett.sh
    sudo chmod +x up-jackett.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/scripts/up-prowlarr.sh
    sudo chmod +x up-prowlarr.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/scripts/up-radarr.sh
    sudo chmod +x up-radarr.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/scripts/up-sonarr.sh
    sudo chmod +x up-sonarr.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/scripts/up-lidarr.sh
    sudo chmod +x up-lidarr.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/scripts/up-bazarr.sh
    sudo chmod +x up-bazarr.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/scripts/up-metube.sh
    sudo chmod +x up-metube.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/scripts/down-networking.sh
    sudo chmod +x down-networking.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/scripts/down-monitoring.sh
    sudo chmod +x down-monitoring.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/scripts/down-vpn1.sh
    sudo chmod +x down-vpn1.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/scripts/down-vpn2.sh
    sudo chmod +x down-vpn2.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/scripts/down-byparr.sh
    sudo chmod +x down-byparr.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/scripts/down-qbittorrent.sh
    sudo chmod +x down-qbittorrent.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/scripts/down-slskd.sh
    sudo chmod +x down-slskd.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/scripts/down-jackett.sh
    sudo chmod +x down-jackett.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/scripts/down-prowlarr.sh
    sudo chmod +x down-prowlarr.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/scripts/down-radarr.sh
    sudo chmod +x down-radarr.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/scripts/down-sonarr.sh
    sudo chmod +x down-sonarr.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/scripts/down-lidarr.sh
    sudo chmod +x down-lidarr.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/scripts/down-bazarr.sh
    sudo chmod +x down-bazarr.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/arr/scripts/down-metube.sh
    sudo chmod +x down-metube.sh
    ```

52. Also get the `compose-boot`, `compose-shutdown` and `compose-restart` scripts and services:
    ```sh
    sudo mkdir -p /lxc/scripts
    cd /lxc/scripts
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/priv-net/scripts/compose-boot.sh
    sudo chmod +x compose-boot.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/priv-net/scripts/compose-shutdown.sh
    sudo chmod +x compose-shutdown.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/priv-net/scripts/compose-restart.sh
    sudo chmod +x compose-restart.sh
    cd /etc/systemd/system
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/priv-net/services/compose-boot.service
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/priv-net/services/compose-shutdown.service
    ```

53. Enable the `systemctl` for `compose-boot` and `compose-shutdown`:
    ```sh
    sudo systemctl daemon-reload
    sudo systemctl enable compose-boot
    sudo systemctl enable compose-shutdown
    ```

54. Now start the `networking` and `monitoring` stacks:
    ```sh
    sudo /lxc/scripts/up-networking.sh
    sudo /lxc/scripts/up-monitoring.sh
    ```
    You can now start configuring individual stacks listed below.

## Configuration

### VPN1

// TODO: ...

### VPN2

// TODO: ...

### Byparr

// TODO: ...

### QBitTorrent

// TODO: ...

### Slskd

// TODO: ...

### Jackett

// TODO: ...

### Prowlarr

// TODO: ...

### Radarr

// TODO: ...

### Sonarr

// TODO: ...

### Lidarr

// TODO: ...

### Bazarr

// TODO: ...

### MeTube

// TODO: ...

## Debugging

If you have any issues setting up `arr` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.

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
