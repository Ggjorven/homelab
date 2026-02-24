# NVIDIA Drivers on Proxmox Node

This file contains the steps for installing NVIDIA Drivers on the **Proxmox Node**.  
These steps have been taken from [here](https://forum.proxmox.com/threads/nvidia-drivers-instalation-proxmox-and-ct.156421/) and slightly modified.

## Steps

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
   wget https://us.download.nvidia.com/XFree86/Linux-x86_64/<VERSION>/NVIDIA-Linux-x86_64-<VERSION>.run
   chmod +x NVIDIA-Linux-x86_64-<VERSION>.run
   ```

6. Install the required build packages:
   ```
   apt install build-essential pve-headers-$(uname -r)
   ```

7. Run the installation:
   ```
   ./NVIDIA-Linux-x86_64-<VERSION>.run
   ```

8. Verify the drivers installed succesfully:
   ```
   nvidia-smi
   ```
   If you don't get any output. Restart your LXC

10. Now make we need to make sure that the NVIDIA drivers persist. We do so using a **systemctl service** on the main node. I have created a nice script for this you can get with this command:
    ```
    cd /etc/systemd/system
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/tutorials/proxmox/services/nvidia-persistence.service
    mkdir -p /lxc/scripts
    cd /lxc/scripts
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/tutorials/proxmox/scripts/nvidia-persistence.sh
    chmod +x nvidia-persistence.sh
    ```

11. Lastly we need to enable this service with:
    ```
    systemctl daemon-reload
    systemctl enable nvidia-persistence
    systemctl start nvidia-persistence
    ```
