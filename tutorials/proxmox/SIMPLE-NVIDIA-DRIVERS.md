# Simple NVIDIA Drivers on Proxmox Node and LXC's

This file contains the steps for installing NVIDIA Drivers on the **Proxmox Node** and **LXC**'s in a simplified way.  

## Prerequisites

1. (Optional) Disable all of your containers and VMs that require your **GPU**.

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
    mkdir -p /node/downloads
    cd /node/downloads
    wget https://us.download.nvidia.com/XFree86/Linux-x86_64/<VERSION>/NVIDIA-Linux-x86_64-<VERSION>.run
    chmod +x NVIDIA-Linux-x86_64-<VERSION>.run
    ```

6. Install the required build packages:
    ```
    apt install build-essential pve-headers-$(uname -r) pve-headers dkms
    ```

7. Download my simplified installation script:
    ```
    BRANCH=main
    mkdir -p /node/scripts
    cd /node/scripts
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/tutorials/proxmox/scripts/install-nvidia-drivers.sh"
    chmod +x install-nvidia-drivers.sh
    ```

8. Run the script with the driver you had installed:
    ```
    ./install-nvidia-drivers.sh /node/downloads/NVIDIA-Linux-x86_64-<VERSION>.run
    ```

9. Verify the drivers installed succesfully:
    ```
    nvidia-smi
    ```
    If you don't get any output. Restart your **Proxmox Node**.

10. Now make we need to make sure that the NVIDIA drivers persist. We do so by using a **systemctl service**. I have created a nice script for this, you can get it with this command:
    ```
    BRANCH=main
    cd /etc/systemd/system
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/tutorials/proxmox/services/nvidia-persistence.service"
    mkdir -p /node/scripts
    cd /node/scripts
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/tutorials/proxmox/scripts/nvidia-persistence.sh"
    chmod +x nvidia-persistence.sh
    ```

11. Now enable this service with:
    ```
    systemctl daemon-reload
    systemctl enable nvidia-persistence
    systemctl start nvidia-persistence
    ```

12. Now just restart your **Proxmox Node**, to make sure any leftovers are cleaned up:
    ```
    reboot
    ```

## Updating

If you have already previously follow the steps and installed the drivers and want the quick steps for what to do to update them easily run the steps below:

1. Download the latest nvidia driver for your GPU [link](https://www.nvidia.com/en-us/drivers/) where the OS is **Linux 64-bit**. Example:
    ```
    mkdir -p /node/downloads
    cd /node/downloads
    wget https://us.download.nvidia.com/XFree86/Linux-x86_64/<VERSION>/NVIDIA-Linux-x86_64-<VERSION>.run
    chmod +x NVIDIA-Linux-x86_64-<VERSION>.run
    ```

2. Download my simplified installation script:
    ```
    BRANCH=main
    mkdir -p /node/scripts
    cd /node/scripts
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/tutorials/proxmox/scripts/install-nvidia-drivers.sh"
    chmod +x install-nvidia-drivers.sh
    ```

3. Run the script with the driver you had installed:
    ```
    ./install-nvidia-drivers.sh /node/downloads/NVIDIA-Linux-x86_64-<VERSION>.run
    ```

4. Verify the drivers installed succesfully:
    ```
    nvidia-smi
    ```
    If you don't get any output. Restart your **Proxmox Node**.


5. Now just restart your **Proxmox Node**, to make sure any leftovers are cleaned up:
    ```
    reboot
    ```
