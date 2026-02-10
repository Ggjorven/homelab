# Jellystack

**Jellystack** is a collection of media streaming tools for streaming my content from any device, this branch contains the installation instructions for installing **Jellyfin & More** using **Docker Compose**.

## Preview

![preview image](docs/images/jellyfin.png)

## Preperation

Before LXC container can access our SMB share we need to mount it to the root node and pass it through with these steps:
*If you have completed these steps from [jellyfin](https://github.com/Ggjorven/homelab/tree/jellyfin) before you can head straight to **Installation**.*

1. Install the following packages to help with mounting:
    ```
    apt install cifs-utils smbclient
    ```

2. Next we need to setup our credentials for our SMB share. We do this in the file `/root/.smbcred`.
    ```
    nano /root/.smbcred 
    ```

3. Paste in the following content and replace the placeholders with your actual `username` and `password`.
    ```
    username=<YOUR USERNAME FOR SMB>
    password=<YOUR PASSWORD FOR SMB>
    ```

4. Now we just need to make a service that mounts the TrueNAS **SMB Share** when it becomes available. I have also created a service script for this purpose:
    ```
    cd /etc/systemd/system
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/jellyfin/services/mount-smb.service
    mkdir /root/scripts
    cd /root/scripts
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/jellyfin/scripts/mount-smb.sh 
    chmod +x /root/scripts/mount-smb.sh
    ```

5. Edit the `/root/scripts/mount-smb.sh` script and replace the `SERVER_IP` with your NAS's actual IP. 
    ```
    nano /root/scripts/mount-smb.sh
    ```

6. Now make sure your mount point set in the `/root/scripts/mount-smb.sh` actually exists with:
    ```
    mkdir /mnt/nas
    ```

7. Now we need to enable this service with:
    ```
    systemctl daemon-reload
    systemctl enable mount-smb
    systemctl start mount-smb
    ```

## Installation

1. From the **Proxmox Node**'s shell install a **Docker LXC** using the [community script](https://community-scripts.github.io/ProxmoxVE/scripts?id=docker):
   ```
   bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct/docker.sh)"
   ```

2. To give our **LXC** access to our network share we need to add this line to `/etc/pve/lxc/<CTID>.conf`:
   ```
   nano /etc/pve/lxc/<CTID>.conf
   ```
   Add:
   ```
   mp0: /mnt/nas,mp=/mnt/nas
   ```
   And:
   ```
   lxc.cgroup2.devices.allow: c 10:200 rwm
   lxc.mount.entry: /dev/net dev/net none bind,create=dir
   lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
   ```
   *Note: Also make sure nesting=1 and keyctl=1*

3. After a restart your **Docker LXC** should have `/mnt/nas` mounted.

4. To give docker access to our GPU we need to install the nvidia-runtime, before we can do so we need to add the NVIDIA repository. We'll start by adding the GPG key:
   ```
   mkdir -p /usr/share/keyrings
   curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
   ```

5. Now we'll add the repository:
   ```
   distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
   curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
   sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
   tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
   ```
   
6. Now install the container toolkit:
    ```
    sudo apt update
    sudo apt install -y nvidia-container-toolkit
    ```

7. Configure docker to use the NVIDIA runtime:
   ```
   nvidia-ctk runtime configure --runtime=docker
   systemctl restart docker
   ```

8. Verify its install with:
   ```
   docker info | grep -i runtime
   ```
   You should see:
   ```
   Runtimes: runc io.containerd.runc.v2 nvidia
   ```

9. Now we can actually start setting up the docker stack. We first need to create a nice place to work in:
    ```
    mkdir -p /docker/jellystack
    ```

10. To create the docker stack we use our premade [compose file](https://github.com/Ggjorven/homelab/blob/jellystack/compose.yaml). But before we can do so we need to install `wget`.
    ```
    apt install wget
    ```
    Now we can run:
    ```
    cd /docker/arrstack
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/jellystack/compose.yaml
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/jellystack/.env
    ```

11. Now modify your `.env` file to reflect your actual `username` and `password`.
    ```
    nano .env
    ```

12. Also make sure the `PUID` and `PGID` are set to your actual IDs in `.env` you can check this with this command *(your user is probably `root`)*:
    ```
    id <YOUR USER>
    ```
    If you run into errors also check [this](https://github.com/TechHutTV/homelab/tree/main/media#user-permissions).

13. We are now finally ready to start our docker stack.
    ```
    docker compose up -d
    ```

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- [Jellyfin](https://jellyfin.org/) - Media streaming solution
- [Jellyseer](https://docs.seerr.dev/) - Media discovery
- [Threadfin](https://github.com/Ggjorven) - M3U Proxy
