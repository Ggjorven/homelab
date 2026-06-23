# Open Media Vault

**Open Media Vault** is a NAS operating system run as a **Proxmox VM**, this branch contains the steps to easily redeploy an **Open Media Vault** setup with an SMB network share.

## Steps

1. Create a **Proxmox VM** with the [omv iso image](https://www.openmediavault.org/download.html).

2. Pass through all the disks following [individual disk passthrough](../../tutorials/proxmox/DISK-PASSTHROUGH.md) or [hba (pcie) passthrough](../../tutorials/proxmox/DISK-PASSTHROUGH.md).

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

13. We also want an NFS share for internal use. Go to `Services` -> `NFS` -> `Shares`. And create a new share.

14. Select the just created shared folder and set the **Client** to your **Proxmox Node**'s IP address and prepend it with `/32`.

15. Set the **Permission** to **Read/Write**

16. And set the **Extra Options** to `rw,sync,no_subtree_check,all_squash,anonuid=0,anongid=0`.

17. To enable it go to `Services` -> `NFS` -> `Settings` and enable it.

## Useful extras

You have now succesfully completed all the necessary steps. Below are some other useful things.

### Mounting

It can be quite useful that the network share is always mounted to the **Proxmox Node**. This can help with passing it to **LXC**'s. I have created a helper script and service for this purpose. You can install them on the **Proxmox Node** using these commands:

1. Install the following packages to help with mounting:
    ```
    apt update
    apt install nfs-common nfs-kernel-server rpcbind
    ```

2. Now we just need to make a service that mounts the TrueNAS **SMB Share** when it becomes available. I have also created a service script for this purpose:
    ```
    cd /etc/systemd/system
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/omv/services/mount-nfs.service
    mkdir -p /node/scripts
    cd /node/scripts
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/omv/scripts/mount-nfs.sh 
    chmod +x mount-nfs.sh
    ```

3. Edit the `/node/scripts/mount-nfs.sh` script and replace the `SERVER_IP` with your NAS's actual IP and `SHARE_NAME` with your SMB's share name. 
    ```
    nano /node/scripts/mount-nfs.sh
    ```

4. Now make sure the mount point set in the `/node/scripts/mount-nfs.sh` actually exists with:
    ```
    mkdir -p /mnt/nas
    ```

5. Now we need to enable this service with:
    ```
    systemctl daemon-reload
    systemctl enable mount-nfs
    systemctl start mount-nfs
    ```

6. To check if the mounting script succeeded run:
   ```
   journalctl -xeu mount-nfs.service
   ```
   You should see the output from the script saying that the NFS was successfully mounted.

Having followed these extra instructions will help with `docker` related services later on.

### Notifications

To get notified when a drive fails we need to setup notifications. In `docker` we use **Gotify** for notifications. Here we will use this same instance, so these steps can only be follow after `monitoringstack` is setup in `docker`.

1. AAA

### Clipboard functionality

To be able to paste your clipboards contents into the **NoVNC** instance we need to change some settings on the host and the VM, the instructions can be found [here](./../../tutorials/proxmox/NOVNC-CLIPBOARD.md).

## Debugging

If you have any issues setting up `omv` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- [Open Media Vault](https://www.openmediavault.org) - NAS Operating System
