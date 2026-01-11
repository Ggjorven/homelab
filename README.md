# Jellyfin

Jellyfin is a media streaming solution for streaming from any device, this branch contains the installation instructions for installing **Jellyfin** as an **LXC Container**.

## Preview

![preview image]()

## Preparation

Before you can get started you must ensure NVIDIA drivers are installed on the host system:
This is done using the following steps:  
These steps have been taken from [here](https://forum.proxmox.com/threads/nvidia-drivers-instalation-proxmox-and-ct.156421/).

1. Blacklist the nouveau drivers (this will create a new file):
   ```
   nano /etc/modprobe.d/blacklist-nouveau.conf
   ```
   Paste this inside:
   ```
   blacklist nouveau
   options nouveau modeset=0
   ```

2. Update initramfs:
   ```
   update-initramfs -u
   ```

3. Check if nouveau is enabled
   ```
   lsmod | grep nouveau
   ```
   If it gives output, disable it with the following command:
   ```
   rmmod nouveau
   ```
   Afterwards go back and verify it's actually disabled by running the following command again:
   ```
   lsmod | grep nouveau
   ```

4. Make sure your system can find your NVIDIA GPU:
   ```
   lspci | grep NVIDIA
   ```

5. Download the latest nvidia driver for your GPU [link](https://www.nvidia.com/en-us/drivers/) where the OS is **Linux 64-bit**. Example:
   ```
   wget https://us.download.nvidia.com/XFree86/Linux-x86_64/550.90.07/NVIDIA-Linux-x86_64-550.90.07.run
   chmod +x NVIDIA-Linux-x86_64-550.90.07.run
   ```

6. Install the required build packages:
   ```
   apt install build-essential pve-headers-$(uname -r)
   ```

7. Run the installation:
   ```
   ./NVIDIA-Linux-x86_64-550.90.07.run
   ```

8. Verify the drivers installed succesfully:
   ```
   nvidia-smi
   ```

9. Now make we need to make sure that the NVIDIA drivers persist. We do so using a **systemctl service** on the main node. I have created a nice script for this you can get with this command:
    ```
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/jellyfin/services/nvidia-persistence.service /etc/systemd/system/nvidia-persistenced.service 
    ```

10. Lastly we need to enable this service with:
    ```
    sudo systemctl daemon-reload
    sudo systemctl enable nvidia-persistence
    sudo systemctl start nvidia-persistence
    ```

And before the LXC container can access our SMB share we need to mount it to the root node and pass it through with these steps:

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
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/jellyfin/services/mount-smb.service /etc/systemd/system/mount-smb.service
    mkdir /root/scripts
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/jellyfin/scripts/mount-smb.sh /root/scripts/mount-smb.sh
    ```

5. Now we need to enable this service with:
    ```
    sudo systemctl daemon-reload
    sudo systemctl enable mount-smb
    sudo systemctl start mount-smb
    ```

## Installation

1. From the Proxmox Node's shell install **Jellyfin** as an **LXC Container** using the [community script](https://community-scripts.github.io/ProxmoxVE/scripts?id=jellyfin). Make sure to pass through the GPU.

2. Now open the **LXC**'s shell and install the exact same NVIDIA drivers:
   ```
   wget https://us.download.nvidia.com/XFree86/Linux-x86_64/550.90.07/NVIDIA-Linux-x86_64-550.90.07.run
   chmod +x NVIDIA-Linux-x86_64-550.90.07.run
   ```
   This time make sure to pass the `--no-kernel-module` flag. Example:
   ```
   ./NVIDIA-Linux-x86_64-550.90.07.run --no-kernel-module
   ```

3. Now go through the **Jellyfin**'s setup from the web UI, but don't create any media libraries yet.

4. To be able to create the media libraries we need to mount our network share from [truenas](https://github.com/Ggjorven/homelab/tree/truenas). To do so we need to ensure a proper boot order between Jellyfin and TrueNAS. Make sure that TrueNAS is booted before Jellyfin and has enough time to finish setting up the network share before booting Jellyfin.  
    This can be done in the **Promox UI** by setting a bootorder and timeouts.

5. Now we need to passthrough the mounted network share from the root node to the **LXC Container** with **Jellyfin** installed. We do so by editing the `/etc/pve/lxc/<CTID>.conf` file from the root container and adding this line:
   ```
   mp0: /mnt/nas,mp=/mnt/nas
   ```

6. Now when we restart the **LXC Container** with **Jellyfin** the **SMB Share** should be mounted and visible at `/mnt/nas`.

7. You can now setup your Movie and Series libraries.

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- [Jellyfin](https://jellyfin.org/) - Media streaming solution
