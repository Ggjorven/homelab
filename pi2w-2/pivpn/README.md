# PiVPN

PiVPN is a VPN service that allows you to connect to your home network from anywhere, this branch contains the installation instructions for installing **PiVPN** on a **Pi 2 W**.

## Installation

1. Install PiVPN using [these instructions](https://docs.pivpn.io/install/).
    ```
    curl -L https://install.pivpn.io | bash
    ```

2. When the installer asks to assign a static IP either do it through the installer or set it up through your router (like me) and keep DHCP.

3. When the installer asks for which provider to use select **Wireguard**.

4. Set the DNS resolver to **Cloudflare**. Keep the rest of the settings default.

5. After installing reboot the system. We can now start adding users with:
    ```
    pivpn add
    ```
    Skip the IP address step and press Enter. Now give the client a name like `phone-name`

6. Before we can connect to **PiVPN** we need to import the client profiles to the device we want to connect with. The client profiles are located in `/home/<USERNAME>/configs`. These instructions are platform specific.
    ##### **Windows:**
    Use a program like WinSCP or Cyberduck. Note that you may need administrator permission to move files to some folders on your Windows machine, so if you have trouble transferring the profile to a particular folder with your chosen file transfer program, try moving it to your desktop.

    ##### **Mac/Linux:**
    aaa

    Extra Information can be found [here](https://docs.pivpn.io/wireguard/#windows).

7. Connecting to the **PiVPN** server differs on every platform. [Here](https://docs.pivpn.io/wireguard/#windowsmac) you can find more information. For this example I will use **Arch Linux**.
    // TODO: ...

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- [PiVPN](https://www.pivpn.io/) - VPN Service
- [Install Wireguard](https://www.wireguard.com/install/) - Wireguard installation
- [Extra docs](https://docs.pivpn.io/wireguard/) - Wireguard documentation for PiVPN

