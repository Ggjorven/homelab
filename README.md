# Gluetun

**Gluetun** is a VPN Container for my **Docker Compose** stacks, this branch contains the installation instructions for installing **Gluetun** using **Docker Compose**.

## Installation

1. From the **Proxmox Node**'s shell install a **Docker LXC** using the [community script](https://community-scripts.github.io/ProxmoxVE/scripts?id=docker):
   ```
   bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct/docker.sh)"
   ```

2. To give our **LXC** access to our network share we need to add these lines to `/etc/pve/lxc/<CTID>.conf`:
   ```
   nano /etc/pve/lxc/<CTID>.conf
   ```
   Add:
   ```
   lxc.cgroup2.devices.allow: c 10:200 rwm
   lxc.mount.entry: /dev/net dev/net none bind,create=dir
   lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
   ```
   *Note: Also make sure nesting=1 and keyctl=1 are there.*

3. After a restart your **Docker LXC** should have access to `/dev/net/tun`.

4. Now we can actually start setting up the docker stack. We first need to create a nice place to work in:
    ```
    mkdir -p /docker/gluetun
    ```

5. To create the docker stack we use our premade [compose file](https://github.com/Ggjorven/homelab/blob/gluetun/compose.yaml). But before we can do so we need to install `wget`.
    ```
    apt install wget
    ```
    Now we can run:
    ```
    cd /docker
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/gluetun/gluetun.yaml
    ```

6. Now create or modify your `.env` file. 
    ```
    nano .env
    ```
    Add this content:
    ```
    # General UID/GIU and Timezone
    TZ=Europe/Amsterdam
    PUID=1000
    PGID=1000

    # Input your VPN provider and type here
    VPN_SERVICE_PROVIDER="private internet access"
    VPN_TYPE=openvpn

    # Copy all these varibles from your generated configuration file
    OPENVPN_USER=username
    OPENVPN_PASSWORD=password

    SERVER_REGIONS=Netherlands

    # Heath check duration
    HEALTH_VPN_DURATION_INITIAL=120s
    ```

7. Also make sure the `PUID` and `PGID` are set to your actual IDs in `.env` you can check this with this command *(your user is probably `root`)*:
    ```
    id <YOUR USER>
    ```
    If you run into errors also check [this](https://github.com/TechHutTV/homelab/tree/main/media#user-permissions).

8. We are now finally ready to start our docker stack.
    ```
    docker compose -f gluetun.yaml up -d
    ```

## Final step

Finally we need to make it so our **Gluetun VPN** starts on bootup of the **Proxmox LXC**. For ease of use I have created a **systemctl service** and a **bash script** to help with this. Install these files with:
```
 cd /etc/systemd/system
 wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/gluetun/services/compose-boot.service
 mkdir /root/scripts
 cd /root/scripts
 wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/gluetun/scripts/compose-boot.sh
 chmod +x compose-boot.sh
 ```
To enable this service we run these commands:
```
systemctl daemon-reload
systemctl enable compose-boot
systemctl start compose-boot
```
Now you're all set.

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- [Gluetun](https://gluetun.com/) - VPN Container
- [Docker](https://www.docker.com/) - Hardware accelerated containers
