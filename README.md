# TV Stack

**Navi Stack** is a collection of Music streaming tools for streaming my music from any device, this branch contains the installation instructions for installing **Navidrome & More** using **Docker Compose**.

## Preparation

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

8. To check if the mounting script succeeded run:
   ```
   journalctl -xeu mount-smb.service
   ```
   You should see the output from the script saying that the SMB was successfully mounted.

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
   *Note: Also make sure nesting=1 and keyctl=1*

3. After a restart your **Docker LXC** should have `/mnt/nas` mounted. You can check with:
    ```
    ls /mnt
    ```
    You should see `nas` in the output.

4. // TODO: ...

## Configuration

### Navidrome

To configure **Navidrome** you need to go to port `9191` of the ip address of the **Proxmox LXC**.

1. // TODO: ...

## Final step    

Finally we need to make it so our **Navi Stack** starts on bootup of the **Proxmox LXC**. For ease of use I have created a **systemctl service** and a **bash script** to help with this. You should have installed these when creating the `gluetun` stack. Now modify the script and add:
```
-f navistack.yaml
```
to it. Do the same to the `compose-update.sh` script.
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
- [Navidrome](https://www.navidrome.org/) - Music streaming backend
