# Open Media Vault

**Open Media Vault** is a NAS operating system run as a **Proxmox VM**, this branch contains the steps to easily redeploy an **Open Media Vault** setup with an SMB network share.

## Steps

1. Create a **Proxmox VM** with the [omv iso image](https://www.openmediavault.org/download.html).

2. Pass through all the disks following [these steps](../../tutorials/proxmox/DISK-PASSTHROUGH.md).

3. Login to **OMV** with username `admin` and password `openmediavault`.

4. Click your profile in the top-right and change the `admin` password.

5. Add a new user under `Users` -> `Users`.

6. Now we need to install plugins. `Plugins` are located under `System` -> `Plugins`. We'll be installing the: `openmediavault-md` plugin.

7. Before we can create a 'pool'/multiple device, we need to qipe the current devices to remove their signatures. This can be done under `Storage` -> `Disks`. Select the disk and press `Wipe`. When asked which method to use just select `Quick`.

8. Now we can head to `Storage` -> `Multiple Devices`. Create your pool with your desired layout. Now it will clean and resync. This can take a WHILE.

9. After that's finally finished we need create a filesystem on this large pool. This can be found under `Storage` -> `File Systems`.

10. Now we can create a shader folder under `Storage` -> `Shared Folders`. Choose the filesystem you just created.

11. To make this shared folder visible on the network we need to create an SMB Share under `Services` -> `SMB/CIFS` -> `Shares`. And create a new share and use the just created shared folder.

12. To enable it go to `Services` -> `SMB/CIFS` -> `Settings` and enable it. Optional: You can also set the SMB version to 3.0.

## Useful extras

You have now succesfully completed all the necessary steps. Another useful step is to make it so the network share is always mounted to the **Proxmox Node**. This can help with passing it to **LXC**'s. I have created a helper script and service for this purpose. You can install them on the **Proxmox Node** using these commands:

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
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/omv/services/mount-smb.service
    mkdir -p /root/scripts
    cd /root/scripts
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/omv/scripts/mount-smb.sh 
    chmod +x /root/scripts/mount-smb.sh
    ```

5. Edit the `/root/scripts/mount-smb.sh` script and replace the `SERVER_IP` with your NAS's actual IP and `SHARE_NAME` with your SMB's share name. 
    ```
    nano /root/scripts/mount-smb.sh
    ```

6. Now make sure the mount point set in the `/root/scripts/mount-smb.sh` actually exists with:
    ```
    mkdir -p /mnt/nas
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

Having followed these extra instructions will help with `docker` related services later on.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- [Open Media Vault](https://www.openmediavault.org) - NAS Operating System
