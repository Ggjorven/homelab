# TV Stack

**TV Stack** is a collection of Live TV streaming tools for streaming my content from any device, this branch contains the installation instructions for installing **Dispatcharr & More** using **Docker Compose**.

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
   If you don't get any output. Restart your LXC

10. Now make we need to make sure that the NVIDIA drivers persist. We do so using a **systemctl service** on the main node. I have created a nice script for this you can get with this command:
    ```
    cd /etc/systemd/system
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/jellyfin/services/nvidia-persistence.service
    mkdir /root/scripts
    cd /root/scripts
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/jellyfin/scripts/nvidia-persistence.sh
    chmod +x nvidia-persistence.sh
    ```

11. Lastly we need to enable this service with:
    ```
    systemctl daemon-reload
    systemctl enable nvidia-persistence
    systemctl start nvidia-persistence
    ```

## Installation

1. From the **Proxmox Node**'s shell install a **Docker LXC** using the [community script](https://community-scripts.github.io/ProxmoxVE/scripts?id=docker):
   ```
   bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct/docker.sh)"
   ```

2. Before our GPU is actually visible in the LXC we need to also install GPU drivers in the LXC. Make sure you download the exact same drivers as before. This requires `wget`.
   ```
   apt install wget
   ```
   
3. Now install the exact same drivers as before:
   ```
   wget https://us.download.nvidia.com/XFree86/Linux-x86_64/550.90.07/NVIDIA-Linux-x86_64-550.90.07.run
   chmod +x NVIDIA-Linux-x86_64-550.90.07.run
   ```

4. But now we need to install it with a different command, make sure to add the `--no-kernel-module` flag:
   ```
   ./NVIDIA-Linux-x86_64-550.90.07.run --no-kernel-module
   ```
   
5. Make sure your LXC sees the drivers with:
   ```
   nvidia-smi
   ```
   You should see your GPU listed.

6. To give docker access to our GPU we need to install the nvidia-runtime, before we can do so we need to add the NVIDIA repository. We'll start by adding the GPG key:
   ```
   mkdir -p /usr/share/keyrings
   curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
   ```

7. Now we'll add the repository:
   ```
   distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
   curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
   sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
   tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
   ```
   
8. Now install the container toolkit:
    ```
    sudo apt update
    sudo apt install -y nvidia-container-toolkit
    ```

9. Configure docker to use the NVIDIA runtime:
   ```
   nvidia-ctk runtime configure --runtime=docker
   systemctl restart docker
   ```

10. Verify its install with:
   ```
   docker info | grep -i runtime
   ```
   You should see:
   ```
   Runtimes: runc io.containerd.runc.v2 nvidia
   ```

11. Now we can actually start setting up the docker stack. We first need to create a nice place to work in:
    ```
    mkdir -p /docker
    ```

12. To create the docker stack we use our premade [compose file](https://github.com/Ggjorven/homelab/blob/tvstack/tvstack.yaml). But before we can do so we need to install `wget`.
    ```
    apt install wget
    ```
    Now we can run:
    ```
    cd /docker
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/tvstack/tvstack.yaml
    ```

13. Now modify your `.env` file.
    ```
    nano .env
    ```
    And make sure this is present:
    ```
    # General UID/GIU and Timezone
    TZ=Europe/Amsterdam
    PUID=1000
    PGID=1000

    # Dispatcharr settings
    DISPATCHARR_STREAMING_PRIORITY=0 # -20 (highest) to 19 (lowest)
    DISPATCHARR_EPG_PRIORITY=5
    ```

14. Also make sure the `PUID` and `PGID` are set to your actual IDs in `.env` you can check this with this command *(your user is probably `root`)*:
    ```
    id <YOUR USER>
    ```
    If you run into errors also check [this](https://github.com/TechHutTV/homelab/tree/main/media#user-permissions).

15. We are now finally ready to start our docker stack.
    ```
    docker compose -f gluetun.yaml -f arrstack.yaml -f jellystack.yaml -f tvstack.yaml up -d
    ```

---

If you have any issues like:  
`
Error response from daemon: failed to create task for container: failed to create shim task: OCI runtime create failed: runc create failed: unable to start container process: error during container init: error running prestart hook #0: exit status 1, stdout: , stderr: Auto-detected mode as 'legacy'
nvidia-container-cli: mount error: failed to add device rules: unable to find any existing device filters attached to the cgroup: bpf_prog_query(BPF_CGROUP_DEVICE) failed: operation not permitted
`  
*Check out [this comment](https://github.com/NVIDIA/nvidia-container-toolkit/issues/1246#issuecomment-3194219487)*

## Configuration

### Dispatcharr

To configure **Dispatcharr** you need to go to port `9191` of the ip address of the **Proxmox LXC**.

1. First we'll need to create a new **Stream Profile** for **NVENC**. Go to **Settings** -> **Stream Profiles** and add a new stream profile.

2. Set the name to NVENC and set the command to:
    ```
    ffmpeg
    ```

3. Set the parameters to:
    ```
    -user_agent {userAgent} -hwaccel cuda -i {streamUrl} -c:v h264_nvenc -c:a copy -f mpegts pipe:1
    ```

4. Set the User-Agent to something like **TiviMate**. *Note: Sometimes **Dispatcharr** doesn't allow you to set the profile, that's okay, leave it blank.*

5. Now we need to go to **Settings** -> **Stream Settings**. And set the default stream profile to **NVENC**.

6. Some clients send multiple requests when starting a stream ([kodi](https://github.com/Dispatcharr/Dispatcharr/issues/979)). To prevent the stream from instantly stopping and starting and sometimes even crashing it's recommended to **Settings** -> **Proxy Settings** and set **Channel Shutdown Delay** to something like 1 or 2 seconds.

7. To allow IPTV clients to also stream VODs we need to enable **Xtream Codes** export. Go to **Users** and set the **XC Password** to anything.

8. Now we can use the `http://192.168.xxx.xxx:9191` IP and the `username` and `password` as **Xtream Code** credentials which allows both regular channels and VODs.

## Final step    

Finally we need to make it so our **TV stack** starts on bootup of the **Proxmox LXC**. For ease of use I have created a **systemctl service** and a **bash script** to help with this. You should have installed these when creating the `gluetun` stack. Now modify the script and add:
```
-f tvstack.yaml
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
- [Dispatcharr](https://github.com/Dispatcharr/Dispatcharr) - M3U & Xtream Proxy
