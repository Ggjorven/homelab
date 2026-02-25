# NVIDIA Drivers on Proxmox LXC

This file contains the steps for installing NVIDIA Drivers on the **Proxmox LXC**.  

## Steps

1. Make sure you're the `root` user on the **Proxmox LXC**:
    ```
    su root
    ```

2. Install the same drivers as on the **Proxmox Node**:
    ```
    wget https://us.download.nvidia.com/XFree86/Linux-x86_64/<VERSION>/NVIDIA-Linux-x86_64-<VERSION>.run
    chmod +x NVIDIA-Linux-x86_64-<VERSION>.run
    ```

3. But now we need to install it with a different command, make sure to add the `--no-kernel-module` flag:
    ```
    ./NVIDIA-Linux-x86_64-<VERSION>.run --no-kernel-module
    ```

4. Choose `MIT/GPL` and select `No` on the 32-bit compatability drivers.
   
5. Make sure your LXC sees the drivers with:
    ```
    nvidia-smi
    ```
    You should see your GPU listed.
