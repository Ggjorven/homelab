# PiVPN

PiVPN is a VPN service that allows you to connect to your home network from anywhere, this branch contains the installation instructions for installing **PiVPN** on a **Pi Zero 2 W**.

## Installation

1. SSH into your **Pi Zero 2 W** using the following command:
    ```
    ssh <username>@<ip address of pi zero 2 w>
    ```

2. Make sure your **Pi Zero 2 W** is up to date using the following commands:
    ```
    sudo apt update && sudo apt upgrade -y
    sudo reboot
    ```

3. Once you're back in install PiVPN using [these instructions](https://docs.pivpn.io/install/).
    ```
    curl -L https://install.pivpn.io | bash
    ```

4. When the installer asks to assign a static IP either do it through the installer or set it up through your router (like me) and keep DHCP.

5. When the installer asks for which provider to use select **Wireguard**.

6. Set the DNS resolver to **Cloudflare**.

7. If you have a domain, set the HOST IP to your domain and setup cloudflare-ddns // TODO: ... else use your public IP.

8. Enable unattended updates for security.

9. After installing reboot the system. We can now start adding users with:
    ```
    pivpn add
    ```
    Skip the IP address step and press Enter. Now give the client a name like `phone-name`

10. Before we can connect to **PiVPN** we need to import the client profiles to the device we want to connect with. The client profiles are located in `/home/<USERNAME>/configs`. These instructions are platform specific.
    ##### **Windows:**
    Use a program like WinSCP or Cyberduck. Note that you may need administrator permission to move files to some folders on your Windows machine, so if you have trouble transferring the profile to a particular folder with your chosen file transfer program, try moving it to your desktop.

    ##### **Mac/Linux:**
    aaa

    Extra Information can be found [here](https://docs.pivpn.io/wireguard/#windows).

11. Connecting to the **PiVPN** server differs on every platform. [Here](https://docs.pivpn.io/wireguard/#windowsmac) you can find more information. For this example I will use **Arch Linux**.
    // TODO: ...

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- [PiVPN](https://www.pivpn.io/) - VPN Service
- [Install Wireguard](https://www.wireguard.com/install/) - Wireguard installation
- [Extra docs](https://docs.pivpn.io/wireguard/) - Wireguard documentation for PiVPN

