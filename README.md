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

8. Verify the drivers installed succesfully and continue to the [Installation](#Installation)
   ```
   nvidia-smi
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

3. Now go through the Jellyfin's setup from the web UI, but don't create any media libraries yet.

4. To be able to create the media libraries we need to mount our network share from [truenas](https://github.com/Ggjorven/homelab/tree/truenas). To do so we need to install the following packages:
   ```
   apt install cifs-utils smbclient
   ```

5. First we create a folder where to mount the share to:
   ```
   mkdir /mnt/media
   ```
   Then we mount the share to it:
   ```
   ```

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- [Jellyfin](https://jellyfin.org/) - Media streaming solution
