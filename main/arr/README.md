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
    BRANCH=main
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/.env"
    ```

36. Create the `networking` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/networking
    cd ~/networking
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/networking/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/networking/compose.yaml"
    ```

37. Create the `monitoring` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/monitoring
    cd ~/monitoring
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/monitoring/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/monitoring/compose.yaml"
    ```

38. Create the `vpn1` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/vpn1
    cd ~/vpn1
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/vpn1/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/vpn1/compose.yaml"
    ```

39. Create the `vpn2` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/vpn2
    cd ~/vpn2
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/vpn2/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/vpn2/compose.yaml"
    ```

40. Create the `flaresolverr` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/flaresolverr
    cd ~/flaresolverr
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/flaresolverr/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/flaresolverr/compose.yaml"
    ```

41. Create the `qbittorrent` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/qbittorrent
    cd ~/qbittorrent
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/qbittorrent/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/qbittorrent/compose.yaml"
    ```

42. Create the `slskd` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/slskd
    cd ~/slskd
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/slskd/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/slskd/compose.yaml"
    ```

43. Create the `jackett` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/jackett
    cd ~/jackett
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/jackett/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/jackett/compose.yaml"
    ```

44. Create the `prowlarr` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/prowlarr
    cd ~/prowlarr
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/prowlarr/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/prowlarr/compose.yaml"
    ```

45. Create the `radarr` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/radarr
    cd ~/radarr
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/radarr/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/radarr/compose.yaml"
    ```

46. Create the `sonarr` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/sonarr
    cd ~/sonarr
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/sonarr/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/sonarr/compose.yaml"
    ```

47. Create the `lidarr` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/lidarr
    cd ~/lidarr
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/lidarr/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/lidarr/compose.yaml"
    ```

48. Create the `bazarr` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/bazarr
    cd ~/bazarr
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/bazarr/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/bazarr/compose.yaml"
    ```

49. Create the `metube` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/metube
    cd ~/metube
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/metube/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/metube/compose.yaml"
    ```

50. Get the `up` and `down` scripts:
    ```sh
    BRANCH=main
    sudo mkdir -p /lxc/scripts
    cd /lxc/scripts
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/up-networking.sh"
    sudo chmod +x up-networking.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/up-monitoring.sh"
    sudo chmod +x up-monitoring.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/up-vpn1.sh"
    sudo chmod +x up-vpn1.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/up-vpn2.sh"
    sudo chmod +x up-vpn2.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/up-flaresolverr.sh"
    sudo chmod +x up-flaresolverr.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/up-qbittorrent.sh"
    sudo chmod +x up-qbittorrent.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/up-slskd.sh"
    sudo chmod +x up-slskd.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/up-jackett.sh"
    sudo chmod +x up-jackett.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/up-prowlarr.sh"
    sudo chmod +x up-prowlarr.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/up-radarr.sh"
    sudo chmod +x up-radarr.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/up-sonarr.sh"
    sudo chmod +x up-sonarr.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/up-lidarr.sh"
    sudo chmod +x up-lidarr.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/up-bazarr.sh"
    sudo chmod +x up-bazarr.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/up-metube.sh"
    sudo chmod +x up-metube.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/down-networking.sh"
    sudo chmod +x down-networking.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/down-monitoring.sh"
    sudo chmod +x down-monitoring.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/down-vpn1.sh"
    sudo chmod +x down-vpn1.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/down-vpn2.sh"
    sudo chmod +x down-vpn2.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/down-flaresolverr.sh"
    sudo chmod +x down-flaresolverr.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/down-qbittorrent.sh"
    sudo chmod +x down-qbittorrent.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/down-slskd.sh"
    sudo chmod +x down-slskd.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/down-jackett.sh"
    sudo chmod +x down-jackett.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/down-prowlarr.sh"
    sudo chmod +x down-prowlarr.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/down-radarr.sh"
    sudo chmod +x down-radarr.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/down-sonarr.sh"
    sudo chmod +x down-sonarr.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/down-lidarr.sh"
    sudo chmod +x down-lidarr.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/down-bazarr.sh"
    sudo chmod +x down-bazarr.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/down-metube.sh"
    sudo chmod +x down-metube.sh
    ```

51. Also get the `compose-boot`, `compose-shutdown` and `compose-restart` scripts and services:
    ```sh
    BRANCH=main
    sudo mkdir -p /lxc/scripts
    cd /lxc/scripts
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/compose-boot.sh"
    sudo chmod +x compose-boot.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/compose-shutdown.sh"
    sudo chmod +x compose-shutdown.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/compose-restart.sh"
    sudo chmod +x compose-restart.sh
    cd /etc/systemd/system
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/services/compose-boot.service"
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/services/compose-shutdown.service"
    ```

52. Enable the `systemctl` for `compose-boot` and `compose-shutdown`:
    ```sh
    sudo systemctl daemon-reload
    sudo systemctl enable compose-boot
    sudo systemctl enable compose-shutdown
    ```

53. Now start the `networking` and `monitoring` stacks:
    ```sh
    sudo /lxc/scripts/up-networking.sh
    sudo /lxc/scripts/up-monitoring.sh
    ```
    You can now start configuring individual stacks listed below.

## Configuration

### VPN1

We can configure `vpn1` by editing the `.env` file and other files.

1. Edit the `.env` file:
    ```sh
    cd ~/vpn1
    nano .env
    ```
    Change `OPENVPN_USER` and `OPENVPN_PASSWORD` to your [pia](https://www.privateinternetaccess.com/) credentials.  
    Leave `VPN_PORT_FORWARDING` `on`.

2. Now start `vpn1`:
    ```sh
    sudo /lxc/scripts/up-vpn1.sh
    ```

3. Check the logs:
    ```sh
    docker logs vpn1
    ```
    You should see something like:
    ```
    [ip getter] Public IP address is xxx.xxx.xxx.xxx (Netherlands, North Holland, Amsterdam - source: ipinfo+ifconfig.co+ip2location+cloudflare)
    ...
    INFO [port forwarding] My forwarded ports are 9999, the first forwarded port is 9999 and the VPN network interface is tun0
    ```
    If you don't see this output checkout the [debugging guide](DEBUGGING.md#forwarded-port-not-showing-up).

4. To double check the port is actually open run these commands:
    ```sh
    docker exec -it vpn1 /bin/sh
    ```
    Install `port-checker` in the container:
    ```sh
    wget -qO port-checker https://github.com/qdm12/port-checker/releases/download/v0.4.0/port-checker_0.4.0_linux_amd64
    chmod +x port-checker
    ```
    Now start the webserver:
    ```
    ./port-checker --listening-address=":9999"
    ```
    Where you replace `9999` with the port you saw in the docker logs.

5. Open a browser and go the VPN's IP on port `9999` where `9999` is replaced with your actual listening port.

6. If everything works you will see a small output detailing your browser information. Something like:
    ```
    Listening address: :9999
    Client address: xxx.xxx.xxxx.xxx:xxx
    Browser: Chrome 145
    Device: Computer
    OS: Linux 0
    ```

8. To exit `vpn1`'s shell run:
    ```sh
    exit
    ```

9. To be able to use this port dynamically in other applications we also want to setup `gluetun` authentication. First we'll need to generate an API key:
    ```sh
    cd ~/vpn1
    docker run --rm -v ./config:/gluetun qmcgaw/gluetun:latest genkey
    ```
    Make sure to save this API key for later.

10. Create a new directory for setting up a safe path that someone with the API key can retrieve the dynamic port.
    ```sh
    sudo mkdir -p config/auth
    ```

11. Create a config file that sets up a route like so:
    ```
    sudo rm config/auth/config.toml
    sudo nano config/auth/config.toml
    ```
    And paste:
    ```
    [[roles]]
    name = "portchecker"
    routes = ["GET /v1/portforward", "GET /v1/openvpn/portforwarded", "GET /v1/publicip/ip"]
    auth = "apikey"
    apikey = "<APIKEY>"
    ```
    Replace `<APIKEY>` with your generated API Key.  
    If you have any other issues I have taken these instructions from [here](https://github.com/TechClusterHQ/qbt-portchecker/tree/main).

12. Restart the `vpn1` container:
    ```sh
    docker restart vpn1
    ```

13. (optional) Sometimes the VPN ip gets blocked by the services, so I have created a restart script, you can install it with:
    ```sh
    BRANCH=main
    cd /lxc/scripts
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/vpns-restart.sh"
    sudo chmod +x vpns-restart.sh
    ```

14. (optional) I like having a timer/service setup that restarts the VPN(s) automatically, you can also install these with:
    ```sh
    BRANCH=main
    cd /etc/systemd/system
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/services/vpns-restart.service"
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/services/vpns-restart.timer"
    ```

15. (optional) Enable and start the service with:
    ```sh
    systemctl daemon-reload
    systemctl enable vpns-restart.timer
    systemctl start vpns-restart.timer
    ```

### VPN2

We can configure `vpn2` by editing the `.env` file and other files.

1. Edit the `.env` file:
    ```sh
    cd ~/vpn2
    nano .env
    ```
    Change `OPENVPN_USER` and `OPENVPN_PASSWORD` to your [pia](https://www.privateinternetaccess.com/) credentials.  
    Leave `VPN_PORT_FORWARDING` `on`.

2. Now start `vpn2`:
    ```sh
    sudo /lxc/scripts/up-vpn2.sh
    ```

3. Check the logs:
    ```sh
    docker logs vpn2
    ```
    You should see something like:
    ```
    [ip getter] Public IP address is xxx.xxx.xxx.xxx (Netherlands, North Holland, Amsterdam - source: ipinfo+ifconfig.co+ip2location+cloudflare)
    ...
    INFO [port forwarding] My forwarded ports are 9999, the first forwarded port is 9999 and the VPN network interface is tun0
    ```
    If you don't see this output checkout the [debugging guide](DEBUGGING.md#forwarded-port-not-showing-up).

4. To double check the port is actually open run these commands:
    ```sh
    docker exec -it vpn2 /bin/sh
    ```
    Install `port-checker` in the container:
    ```sh
    wget -qO port-checker https://github.com/qdm12/port-checker/releases/download/v0.4.0/port-checker_0.4.0_linux_amd64
    chmod +x port-checker
    ```
    Now start the webserver:
    ```
    ./port-checker --listening-address=":9999"
    ```
    Where you replace `9999` with the port you saw in the docker logs.

5. Open a browser and go the VPN's IP on port `9999` where `9999` is replaced with your actual listening port.

6. If everything works you will see a small output detailing your browser information. Something like:
    ```
    Listening address: :9999
    Client address: xxx.xxx.xxxx.xxx:xxx
    Browser: Chrome 145
    Device: Computer
    OS: Linux 0
    ```

8. To exit `vpn2`'s shell run:
    ```sh
    exit
    ```

9. To be able to use this port dynamically in other applications we also want to setup `gluetun` authentication. First we'll need to generate an API key:
    ```sh
    cd ~/vpn2
    docker run --rm -v ./config:/gluetun qmcgaw/gluetun:latest genkey
    ```
    Make sure to save this API key for later.

10. Create a new directory for setting up a safe path that someone with the API key can retrieve the dynamic port.
    ```sh
    sudo mkdir -p config/auth
    ```

11. Create a config file that sets up a route like so:
    ```
    sudo rm config/auth/config.toml
    sudo nano config/auth/config.toml
    ```
    And paste:
    ```
    [[roles]]
    name = "portchecker"
    routes = ["GET /v1/portforward", "GET /v1/openvpn/portforwarded", "GET /v1/publicip/ip"]
    auth = "apikey"
    apikey = "<APIKEY>"
    ```
    Replace `<APIKEY>` with your generated API Key.  
    If you have any other issues I have taken these instructions from [here](https://github.com/TechClusterHQ/qbt-portchecker/tree/main).

12. Restart the `vpn2` container:
    ```sh
    docker restart vpn2
    ```

13. (optional) Sometimes the VPN ip gets blocked by the services, so I have created a restart script, if you haven't installed it during `vpn1`'s configuration you can install it with:
    ```sh
    BRANCH=main
    cd /lxc/scripts
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/vpns-restart.sh"
    sudo chmod +x vpns-restart.sh
    ```

14. (optional) I like having a timer/service setup that restarts the VPN(s) automatically, you can also install these with if you haven't already:
    ```sh
    BRANCH=main
    cd /etc/systemd/system
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/services/vpns-restart.service"
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/services/vpns-restart.timer"
    ```

15. (optional) Enable and start the service with these commands if you haven't already:
    ```sh
    systemctl daemon-reload
    systemctl enable vpns-restart.timer
    systemctl start vpns-restart.timer
    ```

### Flaresolverr

This container (stack) doesn't require any configuration.  
You can start the container with:
```sh
sudo /lxc/scripts/up-flaresolverr.sh
```

### QBitTorrent

First we'll start by configuring via the `.env` file.

1. [QBitTorrent](#QBitTorrent) is connected to [VPN1](#VPN1), we'll need to grab the API key from that and put it in `.env`. See the contents of the auth config:
    ```sh
    cat ~/vpn1/config/auth/config.toml
    ```
    Take note of the `apikey`.

2. Open the `.env`:
    ```sh
    nano ~/qbittorrent/.env
    ```
    Change `DOWNLOADS_FOLDER` to your downloads folder, I use `/mnt/downloads/qbittorrent/downloads`.  
    Change `INCOMPLETE_FOLDER` to your incomplete folder, I use `/mnt/downloads/qbittorrent/incomplete`.  
    Change `TORRENTS_FOLDER` to your torrents folder, I use `/mnt/downloads/qbittorrent/torrents`.  
    Change `PORTCHECKER_API_KEY` to the value of the vpn api key.

3. Make sure the folders actually exist:
    ```sh
    mkdir -p /mnt/downloads/qbittorrent/downloads
    mkdir -p /mnt/downloads/qbittorrent/incomplete
    mkdir -p /mnt/downloads/qbittorrent/torrents
    ```

4. You can now start the container:
    ```sh
    sudo /lxc/scripts/up-qbittorrent.sh
    ```

Now that the container is running we'll start configuring via the WebUI on port `8080`. This requires either having `vmbr0` still attached or having set up [`priv-net`](./../priv-net/README.md).

1. Check the `username` and `password`:
    ```sh
    docker logs qbittorrent
    ```
    You'll see a message like:
    ```
    The WebUI administrator username is: admin
    The WebUI administrator password was not set. A temporary password is provided for this session: xxxxxxxx
    ```
    Take note of the `username` and `password`.

2. Now go to the WebUI and login with those credentials. Be quick with next few steps because qbittorrent restarts every 120s until you finish step 4.

3. Then go to the **Settings** -> **WebUI** and change the `username` and `password` to something you can remember.

4. A bit below that set **Bypass authentication for clients on localhost**.

5. For security we also need to change the `network interface` in the **Settings** under **Advanced** to `tun0`.

6. Thirdly we need to set our directories. Go to **Settings** -> **Downloads**.
    - Set `Default Save Path` to `/downloads`
    - Set `Keep incomplete torrents` to `/incomplete`
    - And `Copy .torrent files` to `/torrents`

7. Since we are gonna be a good torrenter we'll be seeding after downloading, but we don't want to give up all our bandwith. So under **Settings** go to **Speed** under **Global Rate Limits** set your **Upload** to something you want. I have `5000 KiB/s`.

8. Also we want to allow multiple downloads and uploads simultaneously, go to **Settings** -> **BitTorrent**:
    - Set `Maximum active downloads` to something a lot higher, I use `40`.
    - Set `Maximum active uploads` to something higher, I use `10`.
    - Set `Maximum active torrents` to the max downloads + max uploads, in my case `50`.

9. (optional) If you really value every ounce of privacy you can also go to **Settings** and then **BitTorrent** and enable `anonymous mode`. Read [this](https://github.com/qbittorrent/qBittorrent/wiki/Anonymous-Mode) for more information.

### Slskd

We can fully configure `slskd` by editing the `.env` file.

1. [Slskd](#Slskd) is connected to [VPN2](#VPN2), we'll need to grab the API key from that and put it in `.env`. See the contents of the auth config:
    ```sh
    cat ~/vpn2/config/auth/config.toml
    ```
    Take note of the `apikey`.

2. Open the `.env`:
    ```sh
    nano ~/slskd/.env
    ```
    Change `DOWNLOADS_FOLDER` to your downloads folder, I use `/mnt/downloads/slskd/downloads`.  
    Change `INCOMPLETE_FOLDER` to your incomplete folder, I use `/mnt/downloads/slskd/incomplete`.  
    Change `SHARING_FOLDER` to your music folder, I use `/mnt/media/music`.  

3. For other apps to be able to access **Slskd** we'll need to create an API key. Generate one from [here](https://randomkeygen.com/jwt-secret) or another 16 to 255 character generator.

4. In the `.env` set the `SLSKD_API_KEY` to the generated key.

5. Set `PORTCHECKER_API_KEY` to the `vpn2`'s API key you took note of in step `1`.

6. Set `SOULSEEK_USERNAME` and `SOULSEEK_PASSWORD` to your existing soulseek username and password. Or you can just make one up.

7. You can now start the container:
    ```sh
    sudo /lxc/scripts/up-slskd.sh
    ```

Now that the container is running you can access the WebUI on port `5030`. This requires either having `vmbr0` still attached or having set up [`priv-net`](./../priv-net/README.md).  
The default `username` and `password` for **Slskd** are `slskd` and `slskd` respectively.

### Jackett

**Jackett** doesn't require any configuring via the `.env` file.  
So just start the container:
```sh
sudo /lxc/scripts/up-jackett.sh
```

Now that the container is running we'll start configuring via the WebUI on port `9117`. This requires either having `vmbr0` still attached or having set up [`priv-net`](./../priv-net/README.md).

1. Scroll down and setup authentication by setting an **Admin password**.

2. Scroll down further to **FlareSolverr API URL**. Set it to `http://172.24.1.12:8191` which is the [FlareSolverr](#FlareSolverr) (aggregate) URL.

3. Set the **FlareSolverr Max Timeout** to `60000` ms.

4. Scroll back up and **Apply server settings**.

5. Now we'll be adding our indexers, note that **Jackett** is the backup for **Prowlarr**, so only the most important indexers will be here. Follow these instructions for all indexers:
    1. Click **Add indexer**.
    2. Find your indexer and hit the **Configure** button.
    3. Under **Site link** click on the link you prefer (since this is a backup, make it the most popular one)
    4. Scroll down to tags and set the tags listed for that indexer below.
    5. Hit **Okay** to save the indexer.

6. Now add the indexers to **Jackett**. My current setup:
    - **1337x**, tags = (movies, series, music, flaresolverr)
    - **TorrentGalaxyClone**, tags = (movies, series, music)
    - **TorrentDownload**, tags = (movies, series, music)
    - **LimeTorrents**, tags = (movies, series, music, flaresolverr)
    - **EZTV**, tags = (series, flaresolverr)
    - **The Pirate Bay**, tags = (movies, series, music)
    - **YTS**, tags = (series)
    - **Uindex**, tags = (movies, series, music)
    - **TorrentHeaven** (private), tags = (movies, series), NOTE: This requires your credentials and a thank you message

### Prowlarr

**Prowlarr** doesn't require any configuring via the `.env` file.  
So just start the container:
```sh
sudo /lxc/scripts/up-prowlarr.sh
```

Now that the container is running we'll start configuring via the WebUI on port `9696`. This requires either having `vmbr0` still attached or having set up [`priv-net`](./../priv-net/README.md).

1. Once you open the WebUI the first thing you'll see is "Authentication Required". Set the **Authentication Method** to `Forms (login page)`.

2. Now set a safe **Username** and **Password** and repeat your password under **Password Confirmation** and **Save**!

3. Since I also prefer to be fully anonymous go to **Settings** -> **General** and under **Analytics** disable **Send Anonymous Usage Data**.

4. Now we're gonna setup our Download Clients. Go to **Settings** -> **Download Clients**. Add **QBitTorrent**, set the **Host** to `172.24.1.10`. Set it to the **Username** and **Password** you set during the [QBitTorrent](#QBitTorrent) configuration. Finally change the **Default Category** to something like `Movies` and **Save**!

5. Now go to **Settings** -> **Indexers** and add an **Index Proxy** and click `FlareSolverr` set it's ip to `172.24.1.12`. And give it the tag `flaresolverr`. Enable advanced options and set timeout to `180`.

6. Now we'll need to add all of our indexers, follow these steps for each indexer:
    1. Under **Indexers** click **Add Indexer**.
    2. Search for the name and click it.
    3. Set the **Name** field to `{NAME} ({N})`, where `{NAME}` is the name of the indexer and `{N}` is the nth indexer of that name, since there are multiple base URLs.
    4. Set the **Base URL** to the nth name, so for the first indexer of **Name** to the first URL.
    5. Scroll down to **Indexer Priority** and set it to the priority listed in the list. (If you don't see it click on the gear icon in the bottom right)
    6. Set the tags to the tags specified in the list.
    7. **Save**!
    8. Repeat these steps for the same indexer for `2` or `3` times with different **Base URL**'s, make sure to make the **Name** unique.

7. Follow the steps under step `5` for all of these indexers (most stolen from [torrentio](https://torrentio.strem.fun/)):
    - **1337x** priority = 1, tags = (movies, series, music, flaresolverr)
    - **TorrentGalaxyClone** priority = 2, tags = (movies, series, music, flaresolverr)
    - **BitSearch** priority = 3, tags = (movies, series, music)
    - **TorrentDownload** priority = 4, tags = (movies, series, music)
    - **LimeTorrents** priority = 5, tags = (movies, series, music, flaresolverr)
    - **EZTV** priority = 6, tags = (series, flaresolverr)
    - **The Pirate Bay** priority = 7, tags = (movies, series, music)
    - **YTS** priority = 8, tags = (series)
    - **Uindex** priority = 9, tags = (movies, series, music, flaresolverr)
    - **kickasstorrents.ws** priority = 10, tags = (movies, series, music, flaresolverr)
    - **World-torrent** priority = 11, tags = (movies, series, music, flaresolverr)
    - **SubsPlease** priority = 12, tags = (movies, series)
    - **BitRu** priority = 25 (default), tags = (movies, series, music, flaresolverr)
    - **BTdirectory** priority = 25 (default), tags = (movies, series, music, flaresolverr)
    - **FileMood** priority = 25 (default), tags = (movies, series, music)
    - **ilCorSaRoNeRo** priority = 25 (default), tags = (movies, series, music, flaresolverr)
    - **Internet Archive** priority = 25 (default), tags = (movies, series, music)
    - **MagnetDownload** priority = 25 (default), tags = (movies, series, music)
    - **Magnet Cat** priority = 25 (default), tags = (movies, series, music, flaresolverr)
    - **RuTor** priority = 25 (default), tags = (movies, series, music)
    - **RuTracker.RU** priority = 25 (default), tags = (movies, series, music)
    - **showRSS** priority = 25 (default), tags = (series)
    - **Tokyo Tokoshan** priority = 25 (default), tags = (series, music)
    - **Torrent9** priority = 25 (default), tags = (movies, series, music, flaresolverr)
    - **Torrent[CORE]** priority = 25 (default), tags = (movies, series, music)
    - **TorrentKitty** priority = 25 (default), tags = (movies, series, music, flaresolverr)
    - **TorrentProject2** priority = 25 (default), tags = (movies, series, music)
   
    If you also want indexers specially for anime use these (untested):

    - **Nyaa.si** priority = 25 (default), tags = (movies, series, music)
    - **ACG.RIP** priority = 25 (default), tags = (series)
    - **Anidex** priority = 25 (default), tags = (series)
    - **AniSource** priority = 25 (default), tags = (series)
    - **nekoBT** priority = 25 (default), tags = (series)
    - **Shana Project** priority = 25 (default), tags = (series)

    For higher availability I would recommend adding `2` or `3` different **Base URL** versions per indexer if possible.  

> [!NOTE]
> Some indexers get removed from **Prowlarr** because they supposedly don't work anymore, if you still wish to use these download the said indexer from: [here](https://github.com/Prowlarr/indexers) and place them under `~/prowlarr/config/Definitions/Custom`.

8. Now add the [Jackett](#Jackett) indexers to **Prowlarr**. Go to the **Jacket** WebUI on port `9117` if `vmbr0` is still attached or go to the url if you set up [`priv-net`](./../priv-net/README.md). For all of your indexers in **Jackett** follow these steps:
    1. In the **Jacket** WebUI indexer click **Copy Torznab Feed** for the indexer.
    2. Back in the **Prowlarr** WebUI under **Indexers** click **Add Indexer**.
    3. Search for "Generic Torznab" and click it.
    4. Make sure **Advanced Settings** are enabled by click the gear icon in the bottom right.
    5. Set the **Name** to `{NAME} (jackett)` where `{NAME}` is the name of the indexer.
    6. Set the **Url** to `http://172.24.1.10:9117`.
    7. Paste the just copied URL under **Api Path**, but from the front remove the `http://xxx.xxx.xxx.xxx:xxx` so the **API Path** looks something like `/api/xxxx`
    8. Go back to the **Jackett** WebUI and click the **Copy** icon in the top right to copy the **API Key**.
    9. Back in **Prowlarr** set the **API Key** field to that just copied value.
    10. Scroll down to **Tags** and set it to the tags set in **Jackett** for that indexer, but remove the `flaresolverr` tag if it exists.
    11. **Save**!

    To also add the RSS capabilities follow these steps:

    1. In the **Jacket** WebUI indexer click **Copy RSS Feed** for the indexer.
    2. Back in the **Prowlarr** WebUI under **Indexers** click **Add Indexer**.
    3. Search for "Torrent RSS Feed" and click it.
    4. Make sure **Advanced Settings** are enabled by click the gear icon in the bottom right.
    5. Set the **Name** to `{NAME} (jackett rss)` where `{NAME}` is the name of the indexer.
    6. Paste the just copied URL under **Full RSS Feed URL**, but from the front replace the `http://xxx.xxx.xxx.xxx:xxx` with `http://172.24.1.10:9117`, so the url looks something like `http://172.24.1.10:9117/api/xxxx`
    7. Enable **Allow Zero Size**.
    8. Scroll down to **Tags** and set it to the tags set in **Jackett** for that indexer, but remove the `flaresolverr` tag if it exists.
    9. **Save**!

9. Now **Sync App Indexers**.

---

After setting up [Radarr](#Radarr), [Sonarr](#Sonarr) & [Lidarr](#Lidarr) come back to these steps. These steps are pretty much the same for all of them so there is only 1 explanation:

1. Go to the application you want to add to **Prowlarr** and go to that apps WebUI and **Settings** -> **General** and copy your **API Key**.

2. Go back to **Prowlarr** and go to **Settings** -> **Apps** and add an application. 

3. Paste in the **API Key** under **API Key**. 

4. Set the **Prowlarr Server** to `http://172.24.1.10:9696`.

5. Set the ***Arr Server** to `http://172.24.1.13:7878` for **Radarr**, `http://172.24.1.14:8989` for **Sonarr** and `http://172.24.1.15:8686` for **Lidarr**.

6. Now set the **Tags**. For **Radarr** set it to `movies`, for **Sonarr** to `series` and for **Lidarr** set it to `music`.

7. **Save**!

### Radarr

First we'll start by configuring via the `.env` file.

1. Open the `.env`:
    ```sh
    nano ~/radarr/.env
    ```
    Change `DOWNLOADS_FOLDER` to your downloads folder, I use `/mnt/downloads/qbittorrent/downloads`.  
    Change `MOVIES_FOLDER` to your movies folder, I use `/mnt/media/films`.

2. Make sure the folders actually exist:
    ```sh
    mkdir -p /mnt/downloads/qbittorrent/downloads
    mkdir -p /mnt/media/films
    ```

3. You can now start the container:
    ```sh
    sudo /lxc/scripts/up-radarr.sh
    ```

Now that the container is running we'll start configuring via the WebUI on port `7878`. This requires either having `vmbr0` still attached or having set up [`priv-net`](./../priv-net/README.md).

1. Once you open the WebUI the first thing you'll see is "Authentication Required". Set the **Authentication Method** to `Forms (login page)`.

2. Now set a safe **Username** and **Password** and repeat your password under **Password Confirmation** and **Save**!

3. First we're gonna start by importing existing movies, click on **Import Existing Movies** and hit **Start Import** and select the `/movies` folder.

4. Wait for all the movies to be processed and click **Import X Movies** and wait again.

5. Now go to **Settings** -> **Media Management** and enable **Rename Movies** and set it to `{Movie Title} ({Release Year})`.

6. Since we'll be doing postprocessing on the files, we can't hardlink, so while in **Settings** -> **Media Management** enable **Advanced Settings** in the top left. Scroll down to **Importing** and disable **Use Hardlinks instead of Copy**.

7. Since I also prefer to be fully anonymous go to **Settings** -> **General** and under **Analytics** disable **Send Anonymous Usage Data**.

8. Now we're gonna setup our Download Clients. Go to **Settings** -> **Download Clients**. Add **QBitTorrent**, set the **Host** to `172.24.1.10`. Set it to the **Username** and **Password** you set during the [QBitTorrent](#QBitTorrent) configuration. Finally change the **Default Category** to something like `Movies` and **Save**!

9. Now we'll need to modify **Quality Profiles**. Go to **Settings** -> **Profiles**

10. Delete:
    - **HD - 720p/1080p**
    - **SD**

11. Now change these profiles titles:
    - **HD-720p** to **720p - HD**
    - **HD-1080p** to **1080p - HD**
    - **Ultra-HD** to **2160p - 4K**

12. Under **2160p - 4K** you can optionally add **1080p** profiles for if **4K** isn't available.

13. Now we'll need to set maximum **Quality** sizes. Go to **Settings** -> **Quality**.

14. The **Min**, **Preferred** and **Max** megabytes per minute are defined below:  
    - **HDTV-720p**: min = `0`, preferred = `20`, max = `30`
    - **WEBDL-720p**: min = `0`, preferred = `20`, max = `30`
    - **WEBRip-720p**: min = `0`, preferred = `20`, max = `30`
    - **Bluray-720p**: min = `0`, preferred = `20`, max = `30`  
    --
    - **HDTV-1080p**: min = `0`, preferred = `25`, max = `55`
    - **WEBDL-1080p**: min = `0`, preferred = `25`, max = `55`
    - **WEBRip-1080p**: min = `0`, preferred = `25`, max = `55`
    - **Bluray-1080p**: min = `0`, preferred = `25`, max = `55`  
    - **Remux-1080p**: min = `0`, preferred = `25`, max = `55`  
    --
    - **HDVTV-2160p**: min = `0`, preferred = `65`, max = `135`
    - **WEBDL-2160p**: min = `0`, preferred = `65`, max = `135`
    - **WEBRip-2160p**: min = `0`, preferred = `65`, max = `135`
    - **Bluray-2160p**: min = `0`, preferred = `65`, max = `135`
    - **Remux-2160p**: min = `0`, preferred = `65`, max = `135`

15. We'll now want to add **Radarr** as an **App** to **Prowlarr** go to [Prowlarr](#Prowlarr) and follow the final instruction set using the **Radarr** inputs.

---

// TODO: Gotify notifications after monitoring

### Sonarr

First we'll start by configuring via the `.env` file.

1. Open the `.env`:
    ```sh
    nano ~/sonarr/.env
    ```
    Change `DOWNLOADS_FOLDER` to your downloads folder, I use `/mnt/downloads/qbittorrent/downloads`.  
    Change `SERIES_FOLDER` to your series folder, I use `/mnt/media/series`.

2. Make sure the folders actually exist:
    ```sh
    mkdir -p /mnt/downloads/qbittorrent/downloads
    mkdir -p /mnt/media/series
    ```

3. You can now start the container:
    ```sh
    sudo /lxc/scripts/up-sonarr.sh
    ```

Now that the container is running we'll start configuring via the WebUI on port `8989`. This requires either having `vmbr0` still attached or having set up [`priv-net`](./../priv-net/README.md).

1. Once you open the WebUI the first thing you'll see is "Authentication Required". Set the **Authentication Method** to `Forms (login page)`.

2. Now set a safe **Username** and **Password** and repeat your password under **Password Confirmation** and **Save**!

3. First we're gonna start by importing existing series, click on **Import Existing Series** and hit **Start Import** and select the `/tv` folder.

4. Wait for all the series to be processed and click **Import X Series** and wait again.

5. Now go to **Settings** -> **Media Management** and enable **Rename Movies** and set:
   - **Standard Episode Format** to `{Series Title} - S{season:00}E{episode:00} - {Episode Title}`
   - **Daily Episode Format** to `{Series Title} - {Air-Date} - {Episode Title}`
   - **Anime Episode Format** to `{Series Title} - S{season:00}E{episode:00} - {Episode Title}`

6. Since we'll be doing postprocessing on the files, we can't hardlink, so while in **Settings** -> **Media Management** enable **Advanced Settings** in the top left. Scroll down to **Importing** and disable **Use Hardlinks instead of Copy**.

7. Since I also prefer to be fully anonymous go to **Settings** -> **General** and under **Analytics** disable **Send Anonymous Usage Data**.

8. Now we're gonna setup our Download Clients. Go to **Settings** -> **Download Clients**. Add **QBitTorrent**, set the **Host** to `172.24.1.10`. Set it to the **Username** and **Password** you set during the [QBitTorrent](#QBitTorrent) configuration. Finally change the **Default Category** to something like `Movies` and **Save**!

9. Now we'll need to modify **Quality Profiles**. Go to **Settings** -> **Profiles**

10. Delete:
    - **HD - 720p/1080p**
    - **SD**

11. Now change these profiles titles:
    - **HD-720p** to **720p - HD**
    - **HD-1080p** to **1080p - HD**
    - **Ultra-HD** to **2160p - 4K**

12. Under **2160p - 4K** you can optionally add **1080p** profiles for if **4K** isn't available.

13. Now we'll need to set maximum **Quality** sizes. Go to **Settings** -> **Quality**.

14. The **Min**, **Preferred** and **Max** megabytes per minute are defined below:  
    - **HDTV-720p**: min = `0`, preferred = `20`, max = `30`
    - **WEBDL-720p**: min = `0`, preferred = `20`, max = `30`
    - **WEBRip-720p**: min = `0`, preferred = `20`, max = `30`
    - **Bluray-720p**: min = `0`, preferred = `20`, max = `30`  
    --
    - **HDTV-1080p**: min = `0`, preferred = `25`, max = `55`
    - **WEBDL-1080p**: min = `0`, preferred = `25`, max = `55`
    - **WEBRip-1080p**: min = `0`, preferred = `25`, max = `55`
    - **Bluray-1080p**: min = `0`, preferred = `25`, max = `55`  
    - **Remux-1080p**: min = `0`, preferred = `25`, max = `55`  
    --
    - **HDVTV-2160p**: min = `0`, preferred = `65`, max = `135`
    - **WEBDL-2160p**: min = `0`, preferred = `65`, max = `135`
    - **WEBRip-2160p**: min = `0`, preferred = `65`, max = `135`
    - **Bluray-2160p**: min = `0`, preferred = `65`, max = `135`
    - **Remux-2160p**: min = `0`, preferred = `65`, max = `135`

15. We'll now want to add **Sonarr** as an **App** to **Prowlarr** go to [Prowlarr](#Prowlarr) and follow the final instruction set using the **Sonarr** inputs.

---

// TODO: Gotify notifications after monitoring

### Lidarr

First we'll start by configuring via the `.env` file.

1. Open the `.env`:
    ```sh
    nano ~/lidarr/.env
    ```
    Change `DOWNLOADS_FOLDER` to your downloads folder, I use `/mnt/downloads/slskd/downloads`.  
    Change `MUSIC_FOLDER` to your music folder, I use `/mnt/media/music`.

2. Make sure the folders actually exist:
    ```sh
    mkdir -p /mnt/downloads/slskd/downloads
    mkdir -p /mnt/media/music
    ```

3. You can now start the container:
    ```sh
    sudo /lxc/scripts/up-lidarr.sh
    ```

Now that the container is running we'll start configuring via the WebUI on port `8686`. This requires either having `vmbr0` still attached or having set up [`priv-net`](./../priv-net/README.md).

1. Once you open the WebUI the first thing you'll see is "Authentication Required". Set the **Authentication Method** to `Forms (login page)`.

2. Now set a safe **Username** and **Password** and repeat your password under **Password Confirmation** and **Save**!

3. Before we actually set up our `music` folder, we'll want to modify the **Standard** profile. Go to **Settings** -> **Profiles** and select **Standard**.

4. Under **Primary Types** enable:
    - Album
    - Single
    - EP

5. Under **Secondary Types** enable:
    - Studio
    - Soundtrack
    - Live
    - Demo
    - Compilation

6. Under **Release Statuses** enable:
    - Official

7. We'll now add the **Root Folder**, go to **Settings** -> **Media Management** and under **Root Folders** hit the plus.

8. Set the **Name** to something like `music` and the path to `/music`. 

9. Set **Monitor** to **Existing Albums** and **Monitor New Albums** to **No New Albums**.

10. (optional) Set the **Quality Profile** to **Lossless** and **Save**!

11. Since we'll be doing postprocessing on the files, we can't hardlink, so while in **Settings** -> **Media Management** enable **Advanced Settings** in the top left. Scroll down to **Importing** and disable **Use Hardlinks instead of Copy**.

12. Since I also prefer to be fully anonymous go to **Settings** -> **General** and under **Analytics** disable **Send Anonymous Usage Data**.

13. To automatically add metadata go to **Settings** -> **Metadata**. Set **Tag Audio Files with Metadata** to **For new downloads only**.

14. Enable both **Embed Covert Art In Audio Files** and **Scrub Existing Tags** too.

15. To get more customization in we'll also want to install a plugin: [Tubifarry](https://github.com/TypNull/Tubifarry). Go to **System** -> **Plugins** and paste:
    ```
    https://github.com/TypNull/Tubifarry
    ```
    And hit **Install**, it should install the latest version.

16. After it is done go to the **LXC**'s **Console** and restart **Lidarr**:
    ```sh
    docker restart lidarr
    ```

17. Back in the WebUI, we're gonna setup our Download Clients. Go to **Settings** -> **Download Clients**. Add **QBitTorrent**, set the **Host** to `172.24.1.10`. Set it to the **Username** and **Password** you set during the [QBitTorrent](#QBitTorrent) configuration. Finally change the **Default Category** to something like `Movies` and **Save**!

18. Still in **Download Clients** add another client and select **Slskd**. Set the **URL** to `http://172.24.1.11:5030`.

19. We'll also need the **API Key**, open the **Console** for the **LXC** back up and run:
    ```sh
    cat ~/slskd/.env
    ```
    And copy the value set under `SLSKD_API_KEY`.

20. Back in the WebUI paste that copied key under **API Key** and **Save**!

21. To also make it so **Lidarr** can use **Slskd** as an indexer go to **Settings** -> **Indexers** and hit the plus and select **Slskd**.

22. Set the **URL** to `http://172.24.1.11:5030` and set the **API Key** to the same API key you just copied and used in the download client.

23. Scroll down all the way to bottom and set the **Indexer Priority** to `1` (if you don't see it click the gear icon in the bottom right) and **Save**.

24. We'll now want to add **Lidarr** as an **App** to **Prowlarr** go to [Prowlarr](#Prowlarr) and follow the final instruction set using the **Lidarr** inputs.

---

// TODO: Gotify notifications after monitoring

### Bazarr

First we'll start by configuring via the `.env` file.

1. Open the `.env`:
    ```sh
    nano ~/bazarr/.env
    ```
    Change `MOVIES_FOLDER` to your movies folder, I use `/mnt/media/films`.  
    Change `SERIES_FOLDER` to your series folder, I use `/mnt/media/series`.

2. Make sure the folders actually exist:
    ```sh
    mkdir -p /mnt/media/films
    mkdir -p /mnt/media/series
    ```

3. You can now start the container:
    ```sh
    sudo /lxc/scripts/up-bazarr.sh
    ```

Now that the container is running we'll start configuring via the WebUI on port `6767`. This requires either having `vmbr0` still attached or having set up [`priv-net`](./../priv-net/README.md).

1. Once you open the WebUI the first thing you'll see is "Authentication Required". Set the **Authentication Method** to `Forms (login page)`.

2. Now set a safe **Username** and **Password** and repeat your password under **Password Confirmation** and **Save**!


1. Go to `Settings` -> `Languages` and set **Languages Filter** and add:
   - English
   - Dutch

2. Now we need to add **Language Profiles**. Add:
   - Name = "Nederlands", Tag = "dutch", Languages = (Dutch)
   - Name = "English", Tag = "english", Languages = (English)
   - Name = "Combined", Tag = "english_dutch", Languages = (English, Dutch)
     
3. Now scroll down to the bottom and under **Default Language Profiles For Newly Added Shows** enable **Series** and **Movies**. Set this profile to `Combined`.

4. Now go to `Settings` -> `Providers` and add:
   - **OpenSubtitles.com** (requires login details from [https://www.opensubtitles.com/](https://www.opensubtitles.com/))
   - **Subdl** (requires **API Key** from [https://subdl.com/](https://subdl.com/))
   - ~~**SuperSubtitles**~~
   - ~~**TVSubtitles**~~
   - ~~**YIFY Subtitles**~~

5. To make sure our subtitles are up to our standard of quality we need to go to `Settings` -> `Subtitles`.

6. Under **Sub-Zero Subtitle Content Modifications** enable:
    - Remove Tags
    - Remove Emoji
    - OCR Fixes
    - Common Fixes
    - Fix Uppercase

7. Now under **Audio Synchronization / Alignment** enable **Automatic Subtitles Audio Synchronization**.

8. Set **Series Score Threshold For Audio Sync** to `96` and **Movies Score Threshold For Audio Sync** to `86`. And save!

9. Now we're gonna start adding our media management tools like **Sonarr** and **Radarr**. We're gonna start with **Sonarr** under `Settings` -> `Sonarr`. Enable it.

10. Set the `Address` to `172.39.0.40` as defined in the [compose file](compose.yaml)

11. Now open another tab and go to your **Proxmox LXC**'s IP address on port `8989`. Go to `Settings` -> `General` and copy your **API Key**. Now paste it back in the Bazarr field called `API Key` and hit **Test**.

12. Now under **Options** set **Minimum Score For Episodes** to `90`. And save!

13. Now let's do the same for **Radarr**. Go to `Settings` -> `Radarr`. Enable it.

14. Set the `Address` to `172.39.0.41` as defined in the [compose file](compose.yaml)

15. Now open another tab and go to your **Proxmox LXC**'s IP address on port `7878`. Go to `Settings` -> `General` and copy your **API Key**. Now paste it back in the Bazarr field called `API Key` and hit **Test**.

16. Now under **Options** set **Minimum Score For Movies** to `80`. And save!

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
