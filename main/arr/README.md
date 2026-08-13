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

40. Create the `byparr` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/byparr
    cd ~/byparr
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/byparr/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/byparr/compose.yaml"
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
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/up-byparr.sh"
    sudo chmod +x up-byparr.sh
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
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/arr/scripts/down-byparr.sh"
    sudo chmod +x down-byparr.sh
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

### Byparr

This container doesn't require any configuration.  
You can start the container with:
```sh
sudo /lxc/scripts/up-byparr.sh
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

// TODO: ...

### Prowlarr

// TODO: ...

// TODO: Download test-indexers script, timer and service and add API key

### Radarr

// TODO: ...

// Add API key to test-indexers script

### Sonarr

// TODO: ...

// Add API key to test-indexers script

### Lidarr

// TODO: ...

// Add API key to test-indexers script

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
