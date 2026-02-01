# RetroPie

**RetroPie** is a hardware emulator for old consoles, this branch contains the installation instructions for installing **RetroPie** as an **LXC Container**.

## Preview

![preview image](docs/images/preview.png)

## Installation

1. First create an **LXC** with the specs stated [here](https://github.com/Ggjorven/homelab/tree/main?tab=readme-ov-file#deployments).

2. Make sure your LXC is up to date:
   ```
   apt update
   apt upgrade
   ```

3. Install the needed packages for the **RetroPie** install script.
   ```
   apt install -y git dialog unzip xmlstarlet
   ```

4. Download the latest setup script:
   ```
   git clone --depth=1 https://github.com/RetroPie/RetroPie-Setup.git
   ```

5. Enter the folder and execute the script:
   ```
   cd RetroPie-Setup
   chmod +x retropie_setup.sh
   ./retropie_setup.sh
   ```

6. Choose `Basic Install`.

7. Install a minimal X desktop:
   ```
   apt install lxde -y
   ```

8. Install a display manager (optional):
   ```
   apt install lightdm -y
   systemctl enable lightdm
   ```

9. Install X11 and basic GUI support:
   ```
   apt install xorg xserver-xorg-video-all -y
   ```

10. Reboot

11. Install a virtual display buffer:
    ```
    apt install xfce4 xfce4-goodies tightvncserver -y
    ```

12. Configure the display buffer with a new password:
   ```
   vncserver :1
   ```
   Kill the vncserver for configuring:
   ```
   vncserver -kill :1
   ```

13. Edit the startup file:
    ```
    nano ~/.vnc/xstartup
    ```
    And replace the contents with:
    ```
    #!/bin/bash
    xrdb $HOME/.Xresources
    startxfce4 &
    ```
    Make it executable:
    ```
    chmod +x ~/.vnc/xstartup
    ```

15. 

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- [RetroPie](https://retropie.org.uk/) - RetroPie
- [RetroPie Docs](https://retropie.org.uk/docs/Debian/) - Documentation for Ubuntu & Debian
