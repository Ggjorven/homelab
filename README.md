# Jellyfin

Jellyfin is a media streaming solution for streaming from any device, this branch contains the installation instructions for installing **Jellyfin** as an **LXC Container**.

## Preview

![homepage](docs/images/jellyfin-homepage.png)

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
    cd /etc/systemd/system
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/jellyfin/services/nvidia-persistence.service
    mkdir /root/scripts
    cd /root/scripts
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/jellyfin/scripts/nvidia-persistence.sh
    chmod +x nvidia-persistence.sh
    ```

10. Lastly we need to enable this service with:
    ```
    systemctl daemon-reload
    systemctl enable nvidia-persistence
    systemctl start nvidia-persistence
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

### Optional (Live TV)

An extra feature we can add to **Jellyfin** is **Live TV**, we do this by using an **XStream IPTV Code**.

1. To make sure our *totally legitimate* **Live TV** library is kept hidden we'll need to use a VPN. I use [private internet access](https://www.privateinternetaccess.com/). So we'll need to install this on our **Proxmox LXC**. The download link can be found [here](https://www.privateinternetaccess.com/download/linux-vpn), copy the link address for the .run file. And run this command with the link:
   ```
   wget <link>
   ```
   Example:
   ```
   wget https://installers.privateinternetaccess.com/download/pia-linux-3.7-08412.run
   ```

3. Now we need to install it. This can be done with these commands:
   ```
   chmod +x ./pia-linux-3.7-08412.run
   ./pia-linux-3.7-08412.run
   ```

4. Before we can use PIA we need to give the LXC more permissions and more. We do this by editing `/etc/pve/lxc/<VMID>.conf`:
   ```
   nano /etc/pve/lxc/CTID.conf
   ```
   Add this:
   ```
   lxc.cgroup2.devices.allow: c 10:200 rwm
   lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
   ```
   And make sure that `features: nesting=1` is present in the file.

5. Now restart your LXC and we can login. To login via the terminal we create a temporary `login.txt` with our credentials in this format:
   ```
   p00000000
   PASSWORD
   ```
   Now run:
   ```
   piactl login login.txt
   ```
   
6. To allow **PIA** to connect without a graphical application we must enable `background` mode:
   ```
   piactl background enable
   ```

7. Now we need to enable killswitch.

8. Test if you can connect with:
   ```
   piactl connect
   piactl get connectionstate
   ```
   Double check with:
   ```
   curl https://ipinfo.io
   ```
   If this isn't working try rebooting your LXC.

9. To make it so the VPN boots up every time our LXC start we need to create an LXC service. I have also created a service script for this purpose:
    ```
    cd /etc/systemd/system
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/jellyfin/services/vpn-connect.service
    mkdir /root/scripts
    cd /root/scripts
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/jellyfin/scripts/vpn-connect.sh 
    chmod +x /root/scripts/vpn-connect.sh
    ```

10. Now we need to make it so **Jellyfin** isn't started before the VPN has properly connected. We do this by editing the **Jellyfin** systemctl service.
    ```
    nano /lib/systemd/system/jellyfin.service 
    ```
    And replace:
    ```
    After = network-online.target
    ```
    With:
    ```
    After=vpn-connect.service
    Wants=vpn-connect.service
    Requires=vpn-connect.service
    ```

11. Now we need to enable these services with:
    ```
    systemctl daemon-reload
    systemctl enable vpn-connect
    systemctl enable jellyfin
    ```

12. The easiest way to check if everything is working is to reboot.
    ```
    reboot now
    ```

*Additional safeguards:*

To prevent **Jellyfin** from streaming if **PIA** ever disconnects we can also deploy a watchdog service that checks we're still connected and if not it kills **Jellyfin**.

13. To make it so the VPN boots up every time our LXC start we need to create an LXC service. I have also created a service script for this purpose:
    ```
    cd /etc/systemd/system
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/jellyfin/services/vpn-watchdog.service
    mkdir /root/scripts
    cd /root/scripts
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/jellyfin/scripts/vpn-watchdog.sh 
    chmod +x /root/scripts/vpn-watchdog.sh
    ```

14. Now we need to enable this service with:
    ```
    systemctl daemon-reload
    systemctl enable vpn-watchdog
    systemctl start vpn-watchdog
    ```

15. Now head to: [XStream Codes](https://github.com/Ggjorven/homelab/tree/jellyfin?tab=readme-ov-file#xstream-codes)

## Configuration

**Jellyfin** has an awesome plugin system with plenty of awesome plugins, [examples](https://github.com/awesome-jellyfin/awesome-jellyfin). In my **Jellyfin** deployment I run a lot of plugins listed below.

### Xtream Codes

Configuration steps:

1. Go to **Dashboard** -> **Plugins** -> **Xtream** TODO

#### Manifest:
```
https://kevinjil.github.io/Jellyfin.Xtream/repository.json
```

### File Tranformation

Configuration steps:

1. Add the manifest listed below these steps to the repositories under **Dashboard** -> **Plugins** -> **Manage Repositories** -> **New Repository**.

#### Manifest:
```
https://www.iamparadox.dev/jellyfin/plugins/manifest.json
```

### Auto Collections

Configuration steps:

1. Add the manifest listed below these steps to the repositories under **Dashboard** -> **Plugins** -> **Manage Repositories** -> **New Repository**.

#### Manifest:
```
https://raw.githubusercontent.com/KeksBombe/jellyfin-plugin-auto-collections/refs/heads/main/manifest.json
```

### Jellyfin Enhanced

Configuration steps:

1. Add the manifest listed below these steps to the repositories under **Dashboard** -> **Plugins** -> **Manage Repositories** -> **New Repository**.

#### Manifest:
```
https://raw.githubusercontent.com/n00bcodr/jellyfin-plugins/main/10.11/manifest.json
```

### Intro Skipper

Configuration steps:

1. Add the manifest listed below these steps to the repositories under **Dashboard** -> **Plugins** -> **Manage Repositories** -> **New Repository**.

#### Manifest:
```
https://intro-skipper.org/manifest.json
```

### InPlayerEpisodePreview

Configuration steps:

1. Add the manifest listed below these steps to the repositories under **Dashboard** -> **Plugins** -> **Manage Repositories** -> **New Repository**.

#### Manifest:
```
https://raw.githubusercontent.com/Namo2/InPlayerEpisodePreview/master/manifest.json
```

### Custom Tabs

Configuration steps:

1. Add the manifest listed below these steps to the repositories under **Dashboard** -> **Plugins** -> **Manage Repositories** -> **New Repository**.

#### Manifest:
```
https://www.iamparadox.dev/jellyfin/plugins/manifest.json
```

### Jellyfin Tweaks

Configuration steps:

1. Add the manifest listed below these steps to the repositories under **Dashboard** -> **Plugins** -> **Manage Repositories** -> **New Repository**.

#### Manifest:
```
https://raw.githubusercontent.com/n00bcodr/jellyfin-plugins/main/10.11/manifest.json
```

### Subtitles Extract

Configuration steps:

1. TODO: ...

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- [Jellyfin](https://jellyfin.org/) - Media streaming solution
- [Private Internet Access](https://www.privateinternetaccess.com/) - VPN
- [Private Internet Access Docs](https://helpdesk.privateinternetaccess.com/guides/linux/linux-installing-the-pia-app#linux-installing-the-pia-app_step-2-run-installer) - Documentation for PIA
- [Awesome Jellyfin](https://github.com/awesome-jellyfin/awesome-jellyfin) - Collection of awesome Jellyfin plugins
