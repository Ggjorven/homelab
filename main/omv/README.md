# Open Media Vault

**Open Media Vault** is a NAS operating system run as a **Proxmox VM**, this branch contains the steps to easily redeploy an **Open Media Vault** setup with an SMB network share.

## Installation

1. Create a **Proxmox VM** with the [omv iso image](https://www.openmediavault.org/download.html).

2. Pass through all the disks following [these steps](https://github.com/Ggjorven/homelab/blob/main/tutorials/proxmox/DISK-PASSTHROUGH.md).

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

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- [Open Media Vault](https://www.openmediavault.org) - NAS Operating System
